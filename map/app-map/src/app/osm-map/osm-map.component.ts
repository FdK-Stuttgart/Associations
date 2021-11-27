import {
  ChangeDetectorRef, Component, ElementRef,
  OnDestroy, OnInit, Renderer2, ViewChild
} from '@angular/core';
import {
  SocialMediaPlatform, Association,
  Link, SocialMediaLink, Image, Contact
} from '../model/association';
import Map from 'ol/Map';
import View from 'ol/View';
import TileLayer from 'ol/layer/Tile';
import {fromLonLat} from 'ol/proj';
import OSM from 'ol/source/OSM';
import {Overlay} from 'ol';
import OverlayPositioning from 'ol/OverlayPositioning';
import {Coordinate} from 'ol/coordinate';
import {ResizeObserver} from 'resize-observer';
import {Size} from 'ol/size';
import {
  DropdownOption, getAllOptions,
  getSubOptions
} from '../model/dropdown-option';
import {AutoComplete} from 'primeng/autocomplete';
import {MysqlQueryService} from '../services/mysql-query.service';
import {MyHttpResponse} from '../model/http-response';
import {MessageService} from 'primeng/api';
import VectorSource from 'ol/source/Vector';
import Cluster from 'ol/source/Cluster';
import Feature from 'ol/Feature';
import CircleStyle from 'ol/style/Circle';
import VectorLayer from 'ol/layer/Vector';
import Style from 'ol/style/Style';
import Stroke from 'ol/style/Stroke';
import Fill from 'ol/style/Fill';
import Text from 'ol/style/Text';
import Point from 'ol/geom/Point';
import RenderFeature from 'ol/render/Feature';
import Geometry from 'ol/geom/Geometry';
import Icon from 'ol/style/Icon';
import {createEmpty, extend, Extent} from 'ol/extent';
// @ts-ignore
import AnimatedCluster from 'ol-ext/layer/AnimatedCluster';
import {
  getFeatureCoordinate,
  getFirstOriginalFeatureId,
  getOriginalFeatures,
  getOriginalFeaturesIds,
  isClusteredFeature
} from './map.utils';

@Component({
  selector: 'app-osm-map',
  templateUrl: './osm-map.component.html',
  styleUrls: ['./osm-map.component.scss'],
  providers: [
    MessageService
  ]
})
export class OsmMapComponent implements OnInit, OnDestroy {
  sidebarExpanded = true;
  sidebarAnimationDuration = 300;

  zoomDefault = 14;
  zoomViewDetails = 14.5;

  blocked = true;
  loadingText = 'Vereine abrufen...';
  queryString?: string;
  queryStringMarker = '<mark>$&</mark>';

  advancedSearchVisible = false;
  districtOptions: DropdownOption[] = [];
  selectedDistricts: any[] = [];

  map?: Map;
  clusterSource?: VectorSource<Geometry>;
  cluster?: Cluster;
  clusterFeatures: Feature<Geometry>[] = [];
  clusterLayer?: VectorLayer<AnimatedCluster>;

  markers: Overlay[] = [];
  popup?: Overlay;

  popupLat?: number;
  popupLng?: number;
  popupId?: string;
  popupZoomIn?: boolean;

  popupVisible = false;
  popupContentAssociationId?: string;

  associations: Association[] = [];
  filteredAssociations: Association[] = [];

  noPubAddrAssocIds: string[] = [];

  @ViewChild('osmContainer',
    {static: true}) osmContainer!: ElementRef<HTMLDivElement>;
  @ViewChild('autoComplete',
    {static: true}) autoComplete?: AutoComplete;
  resizeObserver?: ResizeObserver;

  constructor(private renderer2: Renderer2,
              private mySqlQueryService: MysqlQueryService,
              private messageService: MessageService,
              private changeDetectorRef: ChangeDetectorRef) {
  }

  /**
   * queries the association data from the database and initializes map and
   * sidebar
   */
  async ngOnInit(): Promise<void> {
    this.blocked = true;
    this.loadingText = 'Vereine abrufen...';

    const httpResponse: MyHttpResponse<Association[]>
      = (await this.mySqlQueryService.getAssociations());
    this.associations = httpResponse?.data ? httpResponse.data.sort(
      (a: Association, b: Association) => {
        const name1 = a.shortName || a.name;
        const name2 = b.shortName || b.name;
        return name1.toLowerCase() > name2.toLowerCase()
          ? 1 : (name1.toLowerCase() < name2.toLowerCase() ? -1 : 0);
      }
    ) : [];

    this.districtOptions =
      (await this.mySqlQueryService.getDistrictOptions())?.data || [];

    if (!this.associations?.length) {
      this.messageService.add({
        severity: 'error',
        summary: 'Fehler beim Abrufen der Vereine',
        detail: httpResponse?.errorMessage || '',
        key: 'mapToast'
      });
    }

    const noPubAddrAssocs: Association[] = this.associations.filter(
      (a: Association) => this.noPublicAddress(a.addressLine1));
    this.noPubAddrAssocIds = noPubAddrAssocs.map((a: Association) => a.id);
    this.filteredAssociations = this.associations;

    if (this.osmContainer?.nativeElement?.clientWidth < 360
      && this.sidebarExpanded) {
      this.sidebarExpanded = false;
    }

    this.initMap();

    // detects browser resize events
    this.resizeObserver = new ResizeObserver(() => {
      this.resizeMapContainer();
    });
    this.resizeObserver.observe(this.osmContainer.nativeElement);

    this.blocked = false;
  }

  /**
   * toggles visibility of the sidebar
   */
  toggleSidebar(): void {
    this.sidebarExpanded = !this.sidebarExpanded;
  }

  /**
   * (re-)initializes the map and the map markers
   */
  initMap(): void {
    if (this.map) {
      this.map.setTarget(undefined);
      this.map = undefined;
    }

    this.changeDetectorRef.detectChanges();

    const rasterLayer = new TileLayer({
      source: new OSM()
    });

    this.clusterLayer = this.initCluster();

    this.map = new Map({
      target: document.getElementById('osm-map') ?? undefined,
      // controls
      layers: [rasterLayer, this.clusterLayer],
      view: new View({
        center: fromLonLat([9.179747886339912, 48.77860400126555]),
        zoom: this.zoomDefault
      })
    });

    this.map.on('click', this.mapClickHandler);
    this.map.on('pointermove', this.mapPointerMoveHandler);

    this.associations.map((s: Association) => {
      this.addMarker(s.lat, s.lng, s.id);
    });

    this.changeDetectorRef.detectChanges();
    this.map.redrawText();
  }

  /**
   * initializes the cluster layer with the map marker features
   */
  initCluster(): VectorLayer<AnimatedCluster> {
    this.clusterSource = new VectorSource({
      features: this.clusterFeatures
    });

    this.cluster = new Cluster({
      distance: 50,
      source: this.clusterSource
    });

    const clusterLayer = new AnimatedCluster({
      source: this.cluster,
      style: this.getAnimatedClusterStyle,
      animationDuration: this.sidebarAnimationDuration
    });
    return clusterLayer;
  }

  /**
   * style function that returns the style for marker cluster features
   * @param feature map feature
   */
  getAnimatedClusterStyle = (feature: Feature<Geometry> | RenderFeature) => {
    const originalFeatures = getOriginalFeatures(feature);
    const featureIds: string[] = getOriginalFeaturesIds(feature);
    const filteredIds: string[] =
      this.filteredAssociations.map((a: Association) => a.id);
    const allIncluded: boolean =
      featureIds.every((id: string) => filteredIds.includes(id));
    const isFiltered: boolean =
      featureIds.some((id: string) => filteredIds.includes(id));
    const size = originalFeatures?.length;
    let style;
    const baseColor = '#d13858'; // '#ed2227'
    if (!style) {
      if (size && size > 1) {
        style = new Style({
          image: new CircleStyle({
            radius: 15,
            stroke: new Stroke({
              color: 'white',
            }),
            fill: new Fill({
              color: allIncluded ?
                baseColor : isFiltered ? '#B47172' : '#989898',
            }),
          }),
          text: new Text({
            text: size.toString(),
            font: '14px Alegreya',
            fill: new Fill({
              color: '#fff'
            }),
            offsetY: 2, // default: 0
          }),
        });
      } else {
        const noPubAddr: boolean = featureIds.some(
          (id: string) => this.noPubAddrAssocIds.includes(id));
        const noPubAddrColor = '#00bfff'; // DeepSkyBlue
        const color = noPubAddr ? noPubAddrColor : baseColor;

        style = new Style({
          image: new Icon({
            img: isFiltered ?
              // this.getActiveMarkerImgColor(color)
              this.getActiveMarkerImg(noPubAddr)
              : this.getInactiveMarkerImg(noPubAddr),
            imgSize: [30, 40],
            anchor: [0.5, 1]
          })
        });
      }
    }
    return style;
  }

  /**
   * updates map size when the map container resizes (the resize observer's
   * callback function)
   */
  resizeMapContainer(): void {
    this.map?.updateSize();
  }

  /**
   * handles the event when the user clicks directly onto the map
   * @param event ol event
   */
  mapClickHandler = (event: any) => {
    if (this.map) {
      const feature = this.map.forEachFeatureAtPixel(event.pixel,
        (f: Feature<Geometry> | RenderFeature) => {
          return f;
        });
      if (feature) {
        const originalFeatures: Feature<Geometry>[]
          = getOriginalFeatures(feature) || [];
        if (isClusteredFeature(feature)) {
          this.zoomToClusterExtent(originalFeatures);
        } else {
          const coordinate: { lat: number, lng: number }
            | undefined = getFeatureCoordinate(feature);
          const id: string | undefined = getFirstOriginalFeatureId(feature);
          if (coordinate?.lat && coordinate?.lng && id) {
            this.handleMarkerClick(coordinate.lat, coordinate.lng, id);
          }
        }
      } else {
        this.removePopup();
        this.popupVisible = false;
        this.popupContentAssociationId = undefined;
      }
    }
    return true;
  }

  /**
   * handles the event of clicking on the close button in the popup
   * @param event click event
   */
  closeButtonClickHandler = (event: MouseEvent) => {
    if (this.popupVisible) {
      this.removePopup();
      this.popupVisible = false;
      this.popupContentAssociationId = undefined;
      return true;
    }
    return false;
  }

  /**
   * handles the event when the user moves the mouse over the map
   * @param event ol event
   */
  mapPointerMoveHandler = (event: any) => {
    if (this.map) {
      const hasFeature = this.map.hasFeatureAtPixel(event.pixel);
      const target = this.map.getTarget();
      if (target && target instanceof HTMLElement) {
        if (hasFeature) {
          target.style.cursor = 'pointer';
        } else {
          target.style.cursor = '';
        }
      }
    }
  }

  /**
   * checks if an association is currently displayed within a clustered feature
   * @param id the association's id
   */
  isDisplayedInACluster(id: string): boolean {
    const allFeatures: Feature<Geometry>[] = this.cluster?.getFeatures() || [];
    const clusteredFeature: Feature<Geometry> | undefined
      = allFeatures?.find((f: Feature<Geometry>) => {
      const ids = getOriginalFeaturesIds(f);
      if (!ids || ids.length <= 1) {
        return false;
      }
      return ids.includes(id);
    });
    if (clusteredFeature) {
      const originalFeatures = getOriginalFeatures(clusteredFeature);
      if (originalFeatures) {
        const length = originalFeatures.length;
        return originalFeatures && !!length && (length > 1);
      }
    }
    return false;
  }

  /**
   * get the extent to fit all features of a cluster into the viewport
   * @param originalFeatures list of features in a cluster
   */
  getClusterExtent(originalFeatures: Feature<Geometry>[]): Extent {
    const extent: Extent = createEmpty();
    originalFeatures.forEach((f: any) => {
      extend(extent, f.getGeometry().getExtent());
    });
    return extent;
  }

  /**
   * zoom the map view to a new viewport so that all features of a cluster fit
   * onto the screen
   * @param originalFeatures list of features in a cluster
   */
  zoomToClusterExtent(originalFeatures: any): void {
    if (this.map) {
      const extent = this.getClusterExtent(originalFeatures);
      this.map.getView().fit(extent, {
        size: this.map.getSize(),
        padding: [72, 48, 24, 48],
        duration: this.sidebarAnimationDuration * 2
      });
    }
  }

  /**
   * handles clicking onto a marker features
   * @param lat association's latitude
   * @param lng association's longitude
   * @param id association's id
   */
  handleMarkerClick(lat: number, lng: number, id: string): void {
    this.togglePopupOverlay(lat, lng, id);
  }

  /**
   * Filter the association list by search string and district options.
   * @param queryString if the filter operation is triggered by a change event
   * in the autocomplete input, use the input query string to filter the
   * associations.
   */
  filterAssociations(queryString?: string): boolean {
    this.blocked = true;
    this.loadingText = 'Vereinsdaten durchsuchen...';
    const previousFilteredResult = this.filteredAssociations;
    let filteredResult: Association[] = [];

    if (!queryString) {
      queryString = this.autoComplete?.inputEL?.nativeElement?.value;
    }

    if (!queryString) {
      filteredResult = this.associations;
      this.queryString = undefined;
    } else {
      this.queryString = queryString;
      filteredResult = this.associations
        .filter((s: Association) => {
          const q: string = queryString ? queryString.toLowerCase() : '';
          return s.name.toLowerCase().includes(q)
            || s.shortName?.toLowerCase().includes(q)
            || s.street?.toLowerCase().includes(q)
            || s.postcode?.toLowerCase().includes(q)
            || s.city?.toLowerCase().includes(q)
            || s.country?.toLowerCase().includes(q)
            || s.goals?.text?.toLowerCase().includes(q)
            || s.activities?.text?.toLowerCase().includes(q)
            || s.contacts?.some((contact: Contact) =>
              contact.name?.toLowerCase().includes(q)
              || contact.poBox?.toLowerCase().includes(q)
              || contact.phone?.toLowerCase().includes(q)
              || contact.fax?.toLowerCase().includes(q)
              || contact.mail?.toLowerCase().includes(q)
            )
            || s.links?.some((link: Link) =>
              link.url.toLowerCase().includes(q)
              || link.linkText?.toLowerCase().includes(q)
            ) || s.socialMedia?.some((socialMedia: SocialMediaLink) =>
              socialMedia.url.toLowerCase().includes(q)
              || socialMedia.linkText?.toLowerCase().includes(q)
              || socialMedia.platform?.toLowerCase().includes(q)
            ) || s.images?.some((image: Image) =>
              image.url.toLowerCase().includes(q)
              || image.altText?.toLowerCase().includes(q)
            );
        });
    }

    if (this.selectedDistricts?.length) {

      filteredResult = filteredResult.filter((s: Association) => {
        return !!s.districtList?.some((value: any) =>
          this.selectedDistricts.includes(value)
        );
      });
    }
    this.filteredAssociations = filteredResult;
    if (JSON.stringify(filteredResult)
      !== JSON.stringify(previousFilteredResult)) {
      if (this.clusterLayer) {
        this.updateClusterLayerStyle();
      }
    }
    if (this.popupVisible
      && this.popupLat != undefined
      && this.popupLng != undefined
      && this.popupId != undefined
      && this.popupZoomIn != undefined) {
      this.popupVisible = false;
      this.togglePopupOverlay(
        this.popupLat,
        this.popupLng,
        this.popupId,
        this.popupZoomIn);
    }
    this.blocked = false;
    return true;
  }

  /**
   * update cluster layer style and check view times to update the map correctly
   */
  updateClusterLayerStyle(): void {
    // BUG FIX: after the cluster layer style changed, render the map a few
    // times to prevent markers from disappearing with no replacement
    this.clusterLayer?.setStyle(this.getAnimatedClusterStyle);
    for (let i = 0; i <= 1500; i += 100) {
      setTimeout(() => {
        this.clusterLayer?.changed();
      }, i);
    }
  }

  /**
   * returns only the sub options for an array of selected options
   * @param selectedItems an array of ids
   * @param options the options array
   */
  getSubOptions(selectedItems: string[], options: DropdownOption[]): string[] {
    return selectedItems.filter((s: string) => {
      const option = options.find((o: DropdownOption) => o.value === s);
      return option && !!option.category;
    });
  }


  /**
   * adds a new marker feature to the cluster on the map
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   */
  private addMarker(lat: number, lng: number, id: string): void {
    const pos = fromLonLat([lng, lat]);

    const newFeature = new Feature(new Point(pos));
    newFeature.setId(id);
    this.clusterFeatures.push(newFeature);

    if (!this.clusterSource) {
      this.clusterSource = new VectorSource({
        features: this.clusterFeatures
      });
    }

    if (!this.cluster) {
      this.cluster = new Cluster({
        distance: 50,
        source: this.clusterSource
      });
    }

    this.clusterSource.addFeature(newFeature);
    this.cluster.setSource(this.clusterSource);
  }

  /**
   * return the active marker image element.
   */
  getActiveMarkerImg(noPubAddr: boolean): HTMLImageElement {
    const markerImg: HTMLImageElement = this.renderer2.createElement('img');
    const attr = noPubAddr ? 'assets/pin-noPubAddr.png' : 'assets/pin-prod.png';
    markerImg.setAttribute('src', attr);
    return markerImg;
  }

  /**
   * return the inactive marker image element (gray marker)
   */
  getInactiveMarkerImg(noPubAddr: boolean): HTMLImageElement {
    const markerImg: HTMLImageElement = this.renderer2.createElement('img');
    // TODO different colors for inactive associations with no public address?
    const attr = noPubAddr ?
      'assets/pin-noPubAddr-inactive.png' : 'assets/pin-inactive-small.png';
    markerImg.setAttribute('src', attr);
    return markerImg;
  }

  /**
   * selects an association and toggles its popup overlay
   * @param association the association to select
   */
  selectAssociation(association: Association): void {
    const zoomIn = this.isDisplayedInACluster(association.id);
    this.togglePopupOverlay(
      association.lat, association.lng, association.id, zoomIn);
  }

  /**
   * shows or hides a popup containing the association's data
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   * @param zoomIn zoom to association
   */
  togglePopupOverlay(
    lat: number, lng: number, id: string, zoomIn: boolean = false): void {
    this.removePopup();

    if (!this.popupVisible || this.popupContentAssociationId !== id) {
      let removeSidebar = false;
      if (this.osmContainer.nativeElement.clientWidth < 360
        && this.sidebarExpanded) {
        this.sidebarExpanded = false;
        removeSidebar = true;
      }

      const pos = fromLonLat([lng, lat]);
      this.popup = this.createPopup(pos, id, removeSidebar, zoomIn);
      this.map?.addOverlay(this.popup);
      this.popupVisible = true;
      this.popupContentAssociationId = id;

      this.popupLat = lat;
      this.popupLng = lng;
      this.popupId = id;
      this.popupZoomIn = zoomIn;

      // add the listener for the popup close button
      document.getElementById('popup-close')?.addEventListener(
        'click',
        this.closeButtonClickHandler);

    } else {
      this.popupLat = undefined;
      this.popupLng = undefined;
      this.popupId = undefined;
      this.popupZoomIn = undefined;

      this.popupVisible = false;
      this.popupContentAssociationId = undefined;
    }
  }

  /**
   * removes the currently displayed popup overlay
   */
  removePopup(): boolean {
    if (this.popup && this.map) {
      document.getElementById('popup-close')?.removeEventListener(
        'click', this.closeButtonClickHandler);
      this.map.removeOverlay(this.popup);
      this.popup = undefined;
      return true;
    }
    return false;
  }

  /**
   * creates a new popup overlay
   * @param coordinates latitude, longitude of popup position
   * @param id the society id to later address the specific marker by its id
   * @param sidebarChange whether the sidebar needs to be hidden
   * (small screen sizes)
   * @param zoomIn zoom to association
   */
  createPopup(coordinates: Coordinate,
              id: string, sidebarChange?: boolean, zoomIn = false): Overlay {
    const sidebarTimeout
      = sidebarChange ? (this.sidebarAnimationDuration / 2) : 0;

    const popupElement: HTMLDivElement = this.renderer2.createElement('div');
    popupElement.setAttribute(
      'class', 'association-container osm-association-container');

    const closeIcon: HTMLElement = this.renderer2.createElement('a');
    closeIcon.setAttribute('class', 'association-container-close-icon');
    closeIcon.setAttribute('id', 'popup-close');
    closeIcon.setAttribute('style', 'cursor: pointer;');
    closeIcon.innerHTML = `<i class="pi pi-times"></i>`;
    popupElement.appendChild(closeIcon);

    const association: Association
      | undefined = this.associations.find((s: Association) => s.id === id);
    if (association) {
      popupElement.innerHTML += this.getPopupContent(association);
    }

    // trigger re-center map to the newly opened popup's position
    setTimeout(() => {
      const size = this.map?.getSize();
      const zoom = zoomIn ?
        this.zoomViewDetails : this.map?.getView().getZoom();
      if (this.map && size) {
        const mapContainer:
          HTMLElement | null = document.getElementById('osm-map');
        const horizontalCenter = mapContainer
          ? (mapContainer.clientWidth / 2)
          : (this.osmContainer.nativeElement.clientWidth / 2);
        const verticalCenter = mapContainer
          ? (mapContainer.clientHeight * 0.975)
          : (this.osmContainer.nativeElement.clientHeight * 0.975);
        const positioning = [horizontalCenter, verticalCenter];
        this.animateViewTo(coordinates, size, positioning, zoom);
      }
    }, sidebarTimeout);

    return new Overlay({
      position: coordinates,
      positioning: OverlayPositioning.BOTTOM_CENTER,
      // -56px to show the popup above its marker (marker is 48px high)
      offset: [0, -56],
      element: popupElement,
      stopEvent: true,
      className: 'on-top'
    });
  }

  /**
   * animate the map view to a new center
   * @param coordinates latitude, longitude of new position
   * @param size zoom
   * @param positioning screen position
   * @param zoom zoom level
   */
  animateViewTo(coordinates: number[],
                size: Size, positioning: number[], zoom?: number): void {
    const view = this.map?.getView();
    if (view) {
      const oldCenter = view.getCenter();
      view.centerOn(coordinates, size, positioning);
      const newCenter = view.getCenter();
      view.setCenter(oldCenter);
      view.animate({
        center: newCenter,
        anchor: coordinates,
        duration: this.sidebarAnimationDuration * 2
      }, () => {
        view.centerOn(coordinates, size, positioning);
        if (zoom) {
          view.animate({
            anchor: coordinates,
            zoom,
            duration: this.sidebarAnimationDuration * 2
          });
        }
      });
    }
  }

  /**
   * returns the html content of the association popup. The html needs to be
   * composed in typescript as we are not able to inject a component as a popup
   * into the OpenLayers map.
   * @param association the association data which needs to be displayed within
   * the popup
   */
  getPopupContent(association: Association): string {
    association.markedName = association.name;
    if (association.street) {
      association.markedStreet = association.street;
    }
    if (association.postcode) {
      association.markedPostcode = association.postcode;
    }
    if (association.city) {
      association.markedCity = association.city;
    }
    if (association.country) {
      association.markedCountry = association.country;
    }
    if (association.goals) {
      association.goals.markedText = association.goals.text;
    }
    if (association.activities) {
      association.activities.markedText = association.activities.text;
    }
    association.contacts?.map((contact: Contact) => {
      if (contact.name) {
        contact.markedName = contact.name;
      }
      if (contact.phone) {
        contact.markedPhone = contact.phone;
      }
      if (contact.fax) {
        contact.markedFax = contact.fax;
      }
      if (contact.mail) {
        contact.markedMail = contact.mail;
      }
      if (contact.poBox) {
        contact.markedPoBox = contact.poBox;
      }
    });
    association.links?.some((link: Link) => {
      if (link.linkText) {
        link.markedLink = link.linkText;
      }
    });

    if (this.queryString) {
      const re = new RegExp(this.queryString, 'gi');
      association.markedName =
        association.name.replace(re, '<mark>$&</mark>');
      if (association.street) {
        association.markedStreet =
          association.street.replace(re, '<mark>$&</mark>');
      }
      if (association.postcode) {
        association.markedPostcode =
          association.postcode.replace(re, '<mark>$&</mark>');
      }
      if (association.city) {
        association.markedCity =
          association.city.replace(re, '<mark>$&</mark>');
      }
      if (association.country) {
        association.markedCountry =
          association.country.replace(re, '<mark>$&</mark>');
      }
      if (association.goals) {
        association.goals.markedText =
          association.goals.text.replace(re, '<mark>$&</mark>');
      }
      if (association.activities) {
        association.activities.markedText =
          association.activities.text.replace(re, '<mark>$&</mark>');
      }
      association.contacts?.map((contact: Contact) => {
        if (contact.name) {
          contact.markedName = contact.name.replace(re, '<mark>$&</mark>');
        }
        if (contact.phone) {
          contact.markedPhone = contact.phone.replace(re, '<mark>$&</mark>');
        }
        if (contact.fax) {
          contact.markedFax = contact.fax.replace(re, '<mark>$&</mark>');
        }
        if (contact.mail) {
          contact.markedMail = contact.mail.replace(re, '<mark>$&</mark>');
        }
        if (contact.poBox) {
          contact.markedPoBox = contact.poBox.replace(re, '<mark>$&</mark>');
        }
      });
      association.links?.some((link: Link) => {
        if (link.linkText) {
          link.markedLink = link.linkText.replace(re, '<mark>$&</mark>');
        }
      });
    }

    let content = `<div class="osm-association-inner-container">`;
    content += `<div class="association-title"><h2>`;
    content += association.markedName;
    content += `</h2></div>`;

    if (association.images && association.images.length > 0) {
      content += `<div class="association-images">`;
      for (const img of association.images) {
        content += `<div class="association-image">`;
        content += `<img src="${img.url}" alt="${img.altText}" />`;
        content += `</div>`;
      }
      content += `</div>`;
    }

    if (association.addressLine1 || association.addressLine2
      || association.addressLine3
      || association.street || association.postcode
      || association.city || association.country) {
      content += `<div class="association-address">`;
      if (association.addressLine1) {
        content += `<p class="name"><strong>`;
        content += `${association.addressLine1}`;
        content += `</strong></p>`;
      }
      if (association.addressLine2) {
        content += `<p class="name">${association.addressLine2}</p>`;
      }
      if (association.addressLine3) {
        content += `<p class="name">${association.addressLine3}</p>`;
      }
      if (association.street) {
        content += `<p class="street">${association.markedStreet}</p>`;
      }
      if (association.postcode || association.city) {
        content += `<p class="postcode-city">`;
        content += `${association.postcode ? (association.markedPostcode + ' ') : ''}`;
        content += `${association.city}`;
        content += `</p>`;
      }
      if (association.country) {
        content += `<p class="country">${association.markedCountry}</p>`;
      }
      content += `</div>`;
    }

    if (association.contacts && association.contacts.length > 0) {
      content += `<div class="association-contacts">`;
      for (const contact of association.contacts) {
        content += `<div class="association-contact">`;
        if (contact.poBox) {
          content += `<div class="association-contact">`;
          content += `<div class="association-contact-row">`;
          content += this.getSocialMediaIcon('pobox', false);
          content += `<p class="pobox">`;
          content += `${contact.markedPoBox}`;
          content += `</a></p></div></div>`;
        }
        content += `</div>`;
      }
      for (const contact of association.contacts) {
        content += `<div class="association-contact">`;
        if (contact.phone) {
          content += `<div class="association-contact">`;
          content += `<div class="association-contact-row">`;
          content += this.getSocialMediaIcon('phone', false);
          content += `<p class="phone">`;
          content += `<a href="${telephoneLink(contact.phone)}">`;
          content += `${contact.markedPhone}`;
          content += `</a></p></div></div>`;
        }
        content += `</div>`;
      }
      for (const contact of association.contacts) {
        content += `<div class="association-contact">`;
        if (contact.fax) {
          content += `<div class="association-contact">`;
          content += `<div class="association-contact-row">`;
          content += this.getSocialMediaIcon('fax', false);
          content += `<p class="fax"><a href="${telephoneLink(contact.fax)}">`;
          content += `${contact.markedFax}`;
          content += `</a></p></div></div>`;
        }
        content += `</div>`;
      }
      for (const contact of association.contacts) {
        content += `<div class="association-contact">`;
        if (contact.mail) {
          content += `<div class="association-contact">`;
          content += `<div class="association-contact-row">`;
          content += this.getSocialMediaIcon('mail', false);
          content += `<p class="mail"><a href="mailto:${contact.mail}">`;
          content += `${contact.markedMail}`;
          content += `</a></p></div></div>`;
        }
        content += `</div>`;
      }
      content += `</div>`;
    }

    if (association.goals && association.goals.text !== '') {
      content += `<div class="association-description">`;
      content += `<h3>Ziele des Vereins</h3>`;
      content += association.goals.markedText;
      content += `</div>`;
    }

    if (association.activities && association.activities.text !== '') {
      content += `<div class="association-description"><h3>Aktivitäten</h3>`;
      content += association.activities.markedText;
      content += `</div>`;
    }

    if (association.districtList && association.districtList.length > 0) {
      content += `<div class="association-active-in">`;
      content += `<h3>Aktivitätsgebiete</h3>`;
      content += `<div class="association-chips-container">`;
      for (const activeIn of getAllOptions(this.districtOptions,
        association.districtList)) {
        content += `<div class="association-chips">`;
        content += activeIn.label;
        content += `</div>`;
      }
      content += `</div>`;
      content += `</div>`;
    }

    if (association.links && association.links.length > 0) {
      content += `<div class="association-links"><h3>Links</h3>`;
      for (const link of association.links) {
        content += `<ul><li>`;
        content += `<a href="${link.url}" `;
        content += ` title="${link.linkText || link.url}"`;
        content += ` target="_blank">`;
        content += `${link.markedLink || link.url}`;
        content += `</a></li></ul>`;
      }
      content += `</div>`;
    }

    if (association.socialMedia && association.socialMedia.length > 0) {
      content += `<div class="association-social-media">`;
      for (const socialMedia of association.socialMedia) {
        content += `<div class="social-media-link">`;
        content += `<a href="${socialMedia.url}"`;
        content += ` title="${socialMedia.linkText || socialMedia.platform || socialMedia.url}"`;
        content += ` target="_blank">`;
        content += this.getSocialMediaIcon(socialMedia.platform);
        content += `</a>`;
        content += `</div>`;
      }
      content += `</div>`;
    }

    return content;
  }

  /**
   * returns the html element containing social media links (including icon)
   * @param platform the social media platform
   * @param alt whether to add an alt attribute to the image
   */
  getSocialMediaIcon(platform?: SocialMediaPlatform | string,
                     alt = true): string {
    if (!platform || platform === ''
      || platform === SocialMediaPlatform.OTHER || platform === 'Other') {
      return '';
    }
    return `<div class="social-media-icon mini-icon">`
      + `<img src="assets/${platform.toLowerCase()}.png"`
      + ` alt="${alt ? platform : ''}"/></div>`;
  }

  /**
   * toggles visibility of advanced search filters
   */
  toggleAdvancedSearchFilters(): void {
    this.advancedSearchVisible = !this.advancedSearchVisible;
  }

  /**
   * select districts (advanced search)
   * @param value the districts selected from the grouped multi-select component
   */
  selectDistricts(value: any): void {
    this.selectedDistricts = value;
    this.filterAssociations();
  }

  /**
   * clears all search filters
   */
  clearFilters(): void {
    this.selectedDistricts = [];
    this.clearAutocomplete();
    this.filterAssociations();
  }

  /**
   * clears the autocomplete search string value
   */
  clearAutocomplete(): void {
    this.autoComplete?.writeValue('');
    this.filterAssociations('');
  }

  /**
   * resets the districts filter
   */
  resetDistrictsFilter(): void {
    this.selectedDistricts = [];
    this.filterAssociations();
  }

  /**
   * removes event listeners
   */
  ngOnDestroy(): void {
    document.getElementById('popup-close')?.removeEventListener(
      'click', this.closeButtonClickHandler);
  }

  // TODO DRY noPublicAddress implementation
  // see map/app-form/src/app/association-form/association-form.component.ts
  noPublicAddress(normAddr: string | undefined): boolean {
    if (normAddr) {
      return !!normAddr.match(/.*keine|Postfach.*/i);
    } else {
      return false;
    }
  }
}

/**
 * returns a valid telephone number only consisting of '+' and numbers
 * @param input telephone number string
 */
export function telephoneLink(input: string): string {
  let output = 'tel:';
  const num = input.match(/\d/g);
  if (!num) {
    return '';
  }
  let processedNum: string = num.join('');
  // TODO support other countries
  if (processedNum.startsWith('0049')) {
    processedNum = processedNum.replace('0049', '+49');
  } else if (processedNum.startsWith('0')) {
    processedNum = processedNum.replace('0', '+49');
  }
  output += processedNum;
  return output;
}
