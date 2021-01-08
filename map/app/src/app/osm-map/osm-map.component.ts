import {ChangeDetectorRef, Component, ElementRef, OnDestroy, OnInit, Renderer2, ViewChild} from '@angular/core';
import {SocialMediaPlatform, Association} from '../model/association';
import Map from 'ol/Map';
import View from 'ol/View';
import TileLayer from 'ol/layer/Tile';
import {fromLonLat, toLonLat} from 'ol/proj';
import OSM from 'ol/source/OSM';
import {Overlay} from 'ol';
import OverlayPositioning from 'ol/OverlayPositioning';
import {Coordinate} from 'ol/coordinate';
import BaseEvent from 'ol/events/Event';
import {ResizeObserver} from 'resize-observer';
import {Size} from 'ol/size';
import {DropdownOption, getSubOptions} from '../model/dropdown-option';
import {AutoComplete} from 'primeng/autocomplete';
import {MysqlQueryService} from '../services/mysql-query.service';
import {MyHttpResponse} from '../model/http-response';
import {MessageService} from 'primeng/api';

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
  SIDEBAR_ANIMATION_DURATION = 300;

  blocked = true;

  advancedSearchVisible = false;
  districtOptions: DropdownOption[] = [];
  activitiesOptions: DropdownOption[] = [];
  selectedDistricts: number[] = [];
  selectedActivities: number[] = [];

  map?: Map;
  markers: Overlay[] = [];
  popup?: Overlay;

  popupVisible = false;
  popupContentAssociationId?: string;

  // @ts-ignore
  associations: Association[] = [];
  filteredAssociations: Association[] = [];

  @ViewChild('osmContainer', {static: true}) osmContainer!: ElementRef<HTMLDivElement>;
  @ViewChild('autoComplete', {static: true}) autoComplete?: AutoComplete;
  resizeObserver?: ResizeObserver;

  constructor(private renderer2: Renderer2,
              private mySqlQueryService: MysqlQueryService,
              private messageService: MessageService,
              private changeDetectorRef: ChangeDetectorRef) {
  }

  /**
   * queries the association data from the database and initializes map and sidebar
   */
  async ngOnInit(): Promise<void> {
    this.blocked = true;

    const httpResponse: MyHttpResponse<Association[]> = (await this.mySqlQueryService.getAssociations());
    this.associations = httpResponse?.data ? httpResponse.data.sort(
      (a: Association, b: Association) => {
        return a.name.toLowerCase() > b.name.toLowerCase() ? 1 : (a.name.toLowerCase() < b.name.toLowerCase() ? -1 : 0);
      }
    ) : [];

    this.districtOptions = (await this.mySqlQueryService.getDistrictOptions())?.data || [];
    this.activitiesOptions = (await this.mySqlQueryService.getActivitiesOptions())?.data || [];

    if (!this.associations?.length) {
      this.messageService.add({
        severity: 'error',
        summary: 'Fehler beim Abrufen der Vereine',
        detail: httpResponse?.errorMessage || '',
        key: 'mapToast'
      });
    }

    this.filteredAssociations = this.associations;

    if (this.osmContainer?.nativeElement?.clientWidth < 360 && this.sidebarExpanded) {
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
      this.map.removeEventListener('click', this.mapClickHandler);
      this.map.setTarget(undefined);
      this.map = undefined;
    }

    this.changeDetectorRef.detectChanges();

    const rasterLayer = new TileLayer({
      source: new OSM()
    });

    this.map = new Map({
      target: document.getElementById('osm-map') ?? undefined,
      layers: [rasterLayer],
      view: new View({
        center: fromLonLat([9.179336633969378, 48.777691287676]),
        zoom: 12,
        minZoom: 3,
        maxZoom: 20,
      })
    });

    this.map.addEventListener('click', this.mapClickHandler);

    this.associations.map((s: Association) => {
      this.addMarker(s.lat, s.lng, s.id);
    });

    this.changeDetectorRef.detectChanges();
    this.map.redrawText();
  }

  /**
   * updates map size when the map container resizes (the resize observer's callback function)
   */
  resizeMapContainer(): void {
    this.map?.updateSize();
  }

  /**
   * handles the event when the user clicks directly onto the map
   * @param event MouseEvent (click)
   */
  mapClickHandler = (event: Event | BaseEvent) => {
    const res = this.removePopup();
    this.popupVisible = false;
    this.popupContentAssociationId = undefined;
    return res;
  };

  /**
   * handles the marker click event and opens or hides the popup overlay
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   */
  markerClickHandler(lat: number, lng: number, id: string): (event: MouseEvent) => void {
    return (event: MouseEvent) => {
      this.togglePopupOverlay(lat, lng, id);
      event.stopPropagation();
    };
  }

  /**
   * "enables" a map marker (uses the active marker image for the marker)
   * @param id the marker's (association's) id
   */
  enableMarker(id: string): void {
    const marker: Overlay | undefined = this.map?.getOverlayById(id);

    if (marker) {
      const pos: Coordinate | undefined = marker.getPosition();
      if (pos && pos.length >= 2) {
        const coord = toLonLat(pos);
        const lat = coord[1];
        const lng = coord[0];

        const oldElement: HTMLElement | undefined = marker.getElement();
        if (oldElement) {
          oldElement.removeEventListener('click', this.markerClickHandler(lat, lng, id));
        }

        const element: HTMLImageElement = this.getMarkerActiveElement(lat, lng, id);
        marker.setElement(element);
      }
    }
  }

  /**
   * "disables" a map marker (uses the inactive marker image for the marker)
   * @param id the marker's (association's) id
   */
  disableMarker(id: string): void {
    const marker: Overlay | undefined = this.map?.getOverlayById(id);

    if (marker) {
      const pos: Coordinate | undefined = marker.getPosition();
      if (pos && pos.length >= 2) {
        const coord = toLonLat(pos);
        const lat = coord[1];
        const lng = coord[0];

        const oldElement: HTMLElement | undefined = marker.getElement();
        if (oldElement) {
          oldElement.removeEventListener('click', this.markerClickHandler(lat, lng, id));
        }

        const element: HTMLImageElement = this.getMarkerInactiveElement(lat, lng, id);
        marker.setElement(element);
      }
    }
  }

  /**
   * enables or disables map markers according to the filtered associations
   */
  enablesAndDisableMapMarkers(): void {
    const activeAssociations = this.associations.filter((s: Association) => {
      return this.filteredAssociations.includes(s);
    });
    const inactiveAssociations = this.associations.filter((s: Association) => {
      return !this.filteredAssociations.includes(s);
    });

    activeAssociations.forEach((s: Association) => {
      this.enableMarker(s.id);
    });

    inactiveAssociations.forEach((s: Association) => {
      this.disableMarker(s.id);
    });
  }

  /**
   * filters the association list (filtered by search string, activity options and district options).
   * @param queryString if the filter operation is triggered by a change event in the autocomplete input, use the input query string to
   * filter the associations.
   */
  filterAssociations(queryString?: string): boolean {
    const previousFilteredResult = this.filteredAssociations;
    let filteredResult: Association[] = [];

    if (!queryString) {
      queryString = this.autoComplete?.inputEL?.nativeElement?.value;
    }

    if (!queryString) {
      filteredResult = this.associations;
    } else {
      filteredResult = this.associations
        .filter((s: Association) => s.name.toLowerCase().startsWith(queryString ? queryString.toLowerCase() : ''));
    }

    if (this.selectedActivities?.length || this.selectedDistricts?.length) {
      filteredResult = filteredResult.filter((s: Association) => {
        let filtered = true;
        if (this.selectedDistricts?.length) {
          filtered = s.districtIds?.some((id: number) =>
            this.selectedDistricts.includes(id)
          ) ?? false;
          if (!filtered) {
            return filtered;
          }
        }
        if (this.selectedActivities?.length) {
          filtered = s.activityIds?.some((id: number) =>
            this.selectedActivities.includes(id)
          ) ?? false;
        }
        return filtered;
      });
    }
    this.filteredAssociations = filteredResult;
    if (JSON.stringify(filteredResult) !== JSON.stringify(previousFilteredResult)) {
      this.enablesAndDisableMapMarkers();
    }
    return true;
  }

  /**
   * adds a new marker to the map
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   */
  private addMarker(lat: number, lng: number, id: string): void {
    const pos = fromLonLat([lng, lat]);

    const markerImg: HTMLImageElement = this.getMarkerActiveElement(lat, lng, id);

    const marker = new Overlay({
      id,
      position: pos,
      positioning: OverlayPositioning.BOTTOM_CENTER,
      element: markerImg,
      insertFirst: false,
      stopEvent: true,
    });

    this.markers.push(marker);
    this.map?.addOverlay(marker);
  }

  /**
   * creates an html active marker image element
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   */
  getMarkerActiveElement(lat: number, lng: number, id: string): HTMLImageElement {
    const markerImg: HTMLImageElement = this.renderer2.createElement('img');
    markerImg.setAttribute('src', 'assets/marker.png');
    markerImg.setAttribute('width', '48');
    markerImg.setAttribute('height', '48');
    markerImg.setAttribute('style', 'cursor: pointer;');
    markerImg.addEventListener('click', this.markerClickHandler(lat, lng, id));
    return markerImg;
  }

  /**
   * creates an html inactive (greyed out) marker image element
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   */
  getMarkerInactiveElement(lat: number, lng: number, id: string): HTMLImageElement {
    const markerImg: HTMLImageElement = this.renderer2.createElement('img');
    markerImg.setAttribute('src', 'assets/marker-inactive.png');
    markerImg.setAttribute('width', '48');
    markerImg.setAttribute('height', '48');
    markerImg.setAttribute('style', 'cursor: pointer;');
    markerImg.addEventListener('click', this.markerClickHandler(lat, lng, id));
    return markerImg;
  }

  /**
   * selects an association and toggles its popup overlay
   * @param association the association to select
   */
  selectAssociation(association: Association): void {
    this.togglePopupOverlay(association.lat, association.lng, association.id);
  }

  /**
   * shows or hides a popup containing the association's data
   * @param lat latitude of position
   * @param lng longitude of position
   * @param id association id
   */
  togglePopupOverlay(lat: number, lng: number, id: string): void {
    this.removePopup();

    if (!this.popupVisible || this.popupContentAssociationId !== id) {
      let removeSidebar = false;
      if (this.osmContainer.nativeElement.clientWidth < 360 && this.sidebarExpanded) {
        this.sidebarExpanded = false;
        removeSidebar = true;
      }

      const pos = fromLonLat([lng, lat]);
      this.popup = this.createPopup(pos, id, removeSidebar);
      this.map?.addOverlay(this.popup);
      this.popupVisible = true;
      this.popupContentAssociationId = id;

      // add the listener for the popup close button
      document.getElementById('popup-close')?.addEventListener('click', this.mapClickHandler);

    } else {
      this.popupVisible = false;
      this.popupContentAssociationId = undefined;
    }
  }

  /**
   * removes the currently displayed popup overlay
   */
  removePopup(): boolean {
    if (this.popup && this.map) {
      document.getElementById('popup-close')?.removeEventListener('click', this.mapClickHandler);
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
   * @param sidebarChange whether the sidebar needs to be hidden (small screen sizes)
   */
  createPopup(coordinates: Coordinate, id: string, sidebarChange = false): Overlay {
    const sidebarTimeout = sidebarChange ? (this.SIDEBAR_ANIMATION_DURATION / 2) : 0;

    const popupElement: HTMLDivElement = this.renderer2.createElement('div');
    popupElement.setAttribute('class', 'association-container osm-association-container');

    const closeIcon: HTMLElement = this.renderer2.createElement('a');
    closeIcon.setAttribute('class', 'association-container-close-icon');
    closeIcon.setAttribute('id', 'popup-close');
    closeIcon.setAttribute('style', 'cursor: pointer;');
    closeIcon.innerHTML = `<i class="pi pi-times"></i>`;
    popupElement.appendChild(closeIcon);

    const association: Association | undefined = this.associations.find((s: Association) => s.id === id);
    if (association) {
      popupElement.innerHTML += this.getPopupContent(association);
    }

    // trigger re-center map to the newly opened popup's position
    setTimeout(() => {
      const size = this.map?.getSize();
      if (this.map && size) {
        const mapContainer: HTMLElement | null = document.getElementById('osm-map');
        const horizontalCenter = mapContainer ? (mapContainer.clientWidth / 2) : (this.osmContainer.nativeElement.clientWidth / 2);
        const verticalCenter = mapContainer ? (mapContainer.clientHeight * 0.975) : (this.osmContainer.nativeElement.clientHeight * 0.975);
        const positioning = [horizontalCenter, verticalCenter];
        this.animateViewTo(coordinates, size, positioning);
      }
    }, sidebarTimeout);

    return new Overlay({
      position: coordinates,
      positioning: OverlayPositioning.BOTTOM_CENTER,
      offset: [0, -56], // -56px to show the popup above its marker (marker is 48px high)
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
   */
  animateViewTo(coordinates: number[], size: Size, positioning: number[]): void {
    const view = this.map?.getView();
    if (view) {
      const oldCenter = view.getCenter();
      view.centerOn(coordinates, size, positioning);
      const newCenter = view.getCenter();
      view.setCenter(oldCenter);
      view.animate({center: newCenter, anchor: coordinates, duration: (this.SIDEBAR_ANIMATION_DURATION * 2)}, () => {
        view.centerOn(coordinates, size, positioning);
      });
    }
  }

  /**
   * returns the html content of the association popup. The html needs to be composed in typescript as we are not able
   * to inject a component as a popup into the OpenLayers map.
   * @param association the association data which needs to be displayed within the popup
   */
  getPopupContent(association: Association): string {
    let content = `<div class="osm-association-inner-container"><div class="association-title"><h2>`;
    content += association.name;
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

    content += `<h2>Basisdaten</h2>`;

    if (association.addressLine1 || association.addressLine2 || association.addressLine3
      || association.street || association.postcode || association.city || association.country) {
      content += `<div class="association-address"><h3>Adresse</h3>`;
      if (association.addressLine1) {
        content += `<p class="name"><strong>${association.addressLine1}</strong></p>`;
      }
      if (association.addressLine2) {
        content += `<p class="name">${association.addressLine2}</p>`;
      }
      if (association.addressLine3) {
        content += `<p class="name">${association.addressLine3}</p>`;
      }
      if (association.street) {
        content += `<p class="street">${association.street}</p>`;
      }
      if (association.postcode || association.city) {
        content += `<p class="postcode-city">`;
        content += `${association.postcode ? (association.postcode + ' ') : ''}${association.city}`;
        content += `</p>`;
      }
      if (association.country) {
        content += `<p class="country">${association.country}</p>`;
      }
      content += `</div>`;
    }

    if (association.contacts && association.contacts.length > 0) {
      content += `<div class="association-contacts"><h3>Kontaktinformationen</h3>`;
      for (const contact of association.contacts) {
        content += `<div class="association-contact">`;
        if (contact.name) {
          content += `<p class="name">${contact.name}</p>`;
        }
        if (contact.phone) {
          content += `<div class="association-contact">`;
          content += `<div class="association-contact-row">`;
          content += this.getSocialMediaIcon('phone', false);
          content += `<p class="phone">${contact.phone}</p></div></div>`;
        }
        if (contact.mail) {
          content += `<div class="association-contact">`;
          content += `<div class="association-contact-row">`;
          content += this.getSocialMediaIcon('mail', false);
          content += `<p class="mail"><a href="mailto:${contact.mail}">${contact.mail}</a></p></div></div>`;
        }
        content += `</div>`;
      }
      content += `</div>`;
    }

    if ((association.goals && association.goals.text !== '') || (association.activities && association.activities.text !== '')) {
      content += `<h2>Beschreibung</h2>`;
    }

    if (association.goals && association.goals.text !== '') {
      content += `<div class="association-description"><h3>Ziele des Vereins</h3>`;
      content += association.goals.text;
      content += `</p></div>`;
    }

    if (association.activities && association.activities.text !== '') {
      content += `<div class="association-description"><h3>Aktivitäten</h3>`;
      content += association.activities.text;
      content += `</p></div>`;
    }

    if (association.links && association.links.length > 0) {
      content += `<div class="association-links"><h3>Links</h3>`;
      for (const link of association.links) {
        content += `<ul>`;
        content += `<li><a href="${link.url}" title="${link.linkText || link.url}">${link.linkText || link.url}</a></li>`;
        content += `</ul>`;
      }
      content += `</div>`;
    }

    if (association.socialMedia && association.socialMedia.length > 0) {
      content += `<div class="association-social-media"><h3>Social Media</h3>`;
      for (const socialMedia of association.socialMedia) {
        content += `<div class="social-media-link">`;
        content += this.getSocialMediaIcon(socialMedia.platform);
        content += `<a href="${socialMedia.url}" title="${socialMedia.linkText || socialMedia.platform}">${socialMedia.linkText || socialMedia.platform}</a>`;
        content += `</div>`;
      }
      content += `</div>`;
    }

    if ((association.districtIds && association.districtIds.length > 0)
      || (association.activityIds && association.activityIds.length > 0)) {
      content += `<h2>Schlagwörter</h2>`;
    }

    if (association.districtIds && association.districtIds.length > 0) {
      content += `<div class="association-active-in"><h3>Aktivitätsgebiete</h3>`;
      content += `<div class="association-chips-container">`;
      for (const activeIn of getSubOptions(this.districtOptions, association.districtIds)) {
        content += `<div class="association-chips">`;
        content += activeIn.label;
        content += `</div>`;
      }
      content += `</div>`;
      content += `</div>`;
    }

    if (association.activityIds && association.activityIds.length > 0) {
      content += `<div class="association-chips-container"><h3>Tätigkeitsfelder</h3>`;
      content += `<div class="association-chips-container">`;
      for (const activity of getSubOptions(this.activitiesOptions, association.activityIds)) {
        content += `<div class="association-chips">`;
        content += activity.label;
        content += `</div>`;
      }
      content += `</div>`;
      content += `</div>`;
    }

    return content;
  }

  /**
   * returns the html element containing social media links (including icon)
   * @param platform the social media platform
   * @param alt whether to add an alt attribute to the image
   */
  getSocialMediaIcon(platform?: SocialMediaPlatform | string, alt = true): string {
    if (!platform || platform === '' || platform === SocialMediaPlatform.OTHER || platform === 'Other') {
      return '';
    }
    return `<div class="social-media-icon mini-icon"><img src="assets/${platform.toLowerCase()}.png" alt="${alt ? platform : ''}"/></div>`;
  }

  /**
   * toggles visibility of advanced search filters
   */
  showAdvancedSearchFilters(): void {
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
   * select activities (advanced search)
   * @param value the activities selected from the grouped multi-select component
   */
  selectActivities(value: any): void {
    this.selectedActivities = value;
    this.filterAssociations();
  }

  /**
   * clears all search filters
   */
  clearFilters(): void {
    this.selectedDistricts = [];
    this.selectedActivities = [];
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
   * resets the activities filter
   */
  resetActivitiesFilter(): void {
    this.selectedActivities = [];
    this.filterAssociations();
  }

  /**
   * returns only the sub options for an array of selected options
   * @param selectedItems an array of ids
   */
  getSubOptions(selectedItems: number[]): number[] {
    return selectedItems.filter((v: number) => v % 100 !== 0);
  }

  /**
   * removes event listeners
   */
  ngOnDestroy(): void {
    document.getElementById('popup-close')?.removeEventListener('click', this.mapClickHandler);
    this.map?.removeEventListener('click', this.mapClickHandler);
  }
}
