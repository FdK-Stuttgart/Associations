export interface LatLng {
  lat: number;
  lng: number;
}

export interface MapSettings
// extends LatLng
{
  id: string;
  center_latitude: number;
  center_longitude: number;
  zoom_level: number;
  description: string;
}
