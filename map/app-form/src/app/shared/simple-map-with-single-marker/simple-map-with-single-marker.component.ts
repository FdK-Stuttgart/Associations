import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnDestroy,
  OnInit,
  Output,
  Renderer2,
  SimpleChanges
} from '@angular/core';
import Map from 'ol/Map';
import View from 'ol/View';
import {fromLonLat, toLonLat} from 'ol/proj';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import * as geocoder from 'ol-geocoder';
import Point from 'ol/geom/Point';
import Feature from 'ol/Feature';
import {Vector as VectorLayer} from 'ol/layer';
import Icon from 'ol/style/Icon';
import IconAnchorUnits from 'ol/style/IconAnchorUnits';
import Style from 'ol/style/Style';
import {Vector} from 'ol/source';

@Component({
  selector: 'app-simple-map-with-single-marker',
  templateUrl: './simple-map-with-single-marker.component.html',
  styleUrls: ['./simple-map-with-single-marker.component.scss']
})
export class SimpleMapWithSingleMarkerComponent implements OnInit, OnChanges, OnDestroy {
  @Input() lat = 0;
  @Input() lng = 0;

  @Input() showAddressField = true;

  private map?: Map;
  private marker?: Feature;
  private markersLayer?: VectorLayer;

  readonly markerId = 'central-marker';

  @Output() mapClick: EventEmitter<{ lat: number, lng: number }> = new EventEmitter<{ lat: number, lng: number }>();

  geocoder = new geocoder('nominatim', {
    provider: 'osm',
    lang: 'gr',
    placeholder: 'Nach Adresse suchen...',
    limit: 5,
    autoComplete: true,
    featureStyle: undefined,
    keepOpen: true
  });

  constructor(private renderer2: Renderer2) {
  }

  ngOnInit(): void {
    this.initMap();
  }

  initMap(): void {
    this.marker = new Feature({
      geometry: new Point(fromLonLat([this.lng, this.lat])),
    });

    this.markersLayer = new VectorLayer({
      source: new Vector({features: [this.marker]}),
      style: new Style({
        image: new Icon({
          anchor: [0.5, 1],
          img: this.getMarkerActiveElement(),
          imgSize: [48, 48],
          anchorXUnits: IconAnchorUnits.FRACTION,
          anchorYUnits: IconAnchorUnits.FRACTION
        })
      })
    });

    const rasterLayer = new TileLayer({
      source: new OSM()
    });

    this.map = new Map({
      target: document.getElementById('osm-map') ?? undefined,
      layers: [rasterLayer, this.markersLayer],
      view: new View({
        center: fromLonLat([this.lng, this.lat]),
        zoom: 15,
        minZoom: 3,
        maxZoom: 20,
      })
    });

    if (this.showAddressField) {
      this.geocoder.on('addresschosen', this.chooseAddressHandler);

      this.map.addControl(this.geocoder);
    }

    this.map.addEventListener('click', this.mapClickHandler);
  }

  chooseAddressHandler = (event: any) => {
    if (event && event.coordinate && event.coordinate.length && event.coordinate.length >= 2) {
      const coordinate = toLonLat(event.coordinate);
      this.mapClick.emit({lat: coordinate[1], lng: coordinate[0]});
      return true;
    }
    return false;
  }

  mapClickHandler = (event: any) => {
    if (event.coordinate && event.coordinate.length && event.coordinate.length >= 2) {
      const coordinate = toLonLat(event.coordinate);
      this.mapClick.emit({lat: coordinate[1], lng: coordinate[0]});
      return true;
    }
    return false;
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (this.map && this.markersLayer && (changes.lat || changes.lng)) {
      this.createMarker(this.lat, this.lng);
    }
  }

  ngOnDestroy(): void {
    this.map?.removeEventListener('click', this.mapClickHandler);
  }

  private createMarker(lat: number, lng: number): void {
    if (this.marker) {
      this.marker = undefined;
    }

    const pos = fromLonLat([lng, lat]);

    this.marker = new Feature({
      geometry: new Point(pos)
    });

    if (!this.map || !this.markersLayer) {
      this.initMap();
    }

    this.markersLayer?.setSource(new Vector({features: [this.marker]}));
    this.map?.getView()?.setCenter(pos);
  }

  private getMarkerActiveElement(): HTMLImageElement {
    const markerImg: HTMLImageElement = this.renderer2.createElement('img');
    markerImg.setAttribute('src', 'assets/marker-small.png');
    return markerImg;
  }
}
