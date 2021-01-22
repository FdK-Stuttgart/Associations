import {Component, EventEmitter, Input, OnChanges, OnDestroy, OnInit, Output, Renderer2, SimpleChanges} from '@angular/core';
import Map from 'ol/Map';
import View from 'ol/View';
import {fromLonLat, toLonLat} from 'ol/proj';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import {Overlay} from 'ol';
import OverlayPositioning from 'ol/OverlayPositioning';

@Component({
  selector: 'app-simple-map-with-single-marker',
  templateUrl: './simple-map-with-single-marker.component.html',
  styleUrls: ['./simple-map-with-single-marker.component.scss']
})
export class SimpleMapWithSingleMarkerComponent implements OnInit, OnChanges, OnDestroy {
  @Input() lat = 0;
  @Input() lng = 0;

  private map?: Map;
  private marker?: Overlay;

  readonly markerId = 'central-marker';

  @Output() mapClick: EventEmitter<{ lat: number, lng: number }> = new EventEmitter<{ lat: number, lng: number }>();

  constructor(private renderer2: Renderer2) {
  }

  ngOnInit(): void {
    const rasterLayer = new TileLayer({
      source: new OSM()
    });

    this.map = new Map({
      target: document.getElementById('osm-map') ?? undefined,
      layers: [rasterLayer],
      view: new View({
        center: fromLonLat([this.lng, this.lat]),
        zoom: 15,
        minZoom: 3,
        maxZoom: 20,
      })
    });

    this.createMarker(this.lat, this.lng);

    this.map.addEventListener('click', this.mapClickHandler);
  }

  mapClickHandler = (event: any) => {
    if (event.coordinate && event.coordinate.length && event.coordinate.length >= 2) {
      const coordinate = toLonLat(event.coordinate);
      this.mapClick.emit({lat: coordinate[1], lng: coordinate[0]});
      return true;
    }
    return false;
  };

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.lat || changes.lng) {
      this.createMarker(this.lat, this.lng);
    }
  }

  ngOnDestroy(): void {
    this.map?.removeEventListener('click', this.mapClickHandler);
  }

  private createMarker(lat: number, lng: number): void {
    if (this.marker) {
      this.map?.removeOverlay(this.marker);
      this.marker = undefined;
    }

    const pos = fromLonLat([lng, lat]);

    const markerImg: HTMLImageElement = this.getMarkerActiveElement();

    const marker = new Overlay({
      id: this.markerId,
      position: pos,
      positioning: OverlayPositioning.BOTTOM_CENTER,
      element: markerImg,
      insertFirst: false,
      stopEvent: true,
    });

    this.marker = marker;
    this.map?.addOverlay(marker);

    this.map?.getView()?.setCenter(pos);
  }

  private getMarkerActiveElement(): HTMLImageElement {
    const markerImg: HTMLImageElement = this.renderer2.createElement('img');
    markerImg.setAttribute('src', 'assets/marker.png');
    markerImg.setAttribute('width', '48');
    markerImg.setAttribute('height', '48');
    markerImg.setAttribute('style', 'cursor: not-allowed; pointer-events: none;');
    return markerImg;
  }
}
