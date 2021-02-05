import Feature from 'ol/Feature';
import Geometry from 'ol/geom/Geometry';
import RenderFeature from 'ol/render/Feature';
import Point from 'ol/geom/Point';
import {Coordinate} from 'ol/coordinate';
import {toLonLat} from 'ol/proj';

export function isClusteredFeature(feature: Feature<Geometry> | RenderFeature): boolean {
  if (!feature || !feature.get('features')) {
    return false;
  }
  return feature.get('features').length > 1;
}

export function getOriginalFeatures(feature: Feature<Geometry> | RenderFeature): Feature[] | undefined {
  return feature.get('features');
}

export function getOriginalFeaturesIds(feature: Feature<Geometry> | RenderFeature): string[] {
  const features: Feature[] | undefined = getOriginalFeatures(feature)

  if (features) {
    return features
      .filter(
        (f: Feature) => !!f.getId()
      )
      .map(
        (f: Feature) => (f.getId() as string).toString()
      );
  }
  return [];
}

export function getFirstOriginalFeature(feature: Feature<Geometry> | RenderFeature): Feature | undefined {
  const originalFeatures = getOriginalFeatures(feature);
  if (!originalFeatures || !originalFeatures.length || originalFeatures.length < 1) {
    return undefined;
  }
  return originalFeatures[0];
}

export function getFirstOriginalFeatureId(feature: Feature<Geometry> | RenderFeature): string | undefined {
  return getFirstOriginalFeature(feature)?.getId()?.toString();
}

export function getFeatureCoordinate(feature: Feature<Geometry> | RenderFeature): { lat: number, lng: number } | undefined {
  if (!isClusteredFeature(feature)) {
    const point: Point = feature.getGeometry() as Point;
    if (point) {
      const coordinate: Coordinate = point.getCoordinates();
      if (coordinate && coordinate.length && coordinate.length >= 2) {
        const lonLat = toLonLat(coordinate);
        const lat = lonLat[1];
        const lng = lonLat[0];
        return ({lat, lng});
      }
    }
  }
  return undefined;
}
