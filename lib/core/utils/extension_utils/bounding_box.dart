import 'dart:math';

import 'package:yandex_maps_mapkit/mapkit.dart';

extension BoundingcBox on BoundingBox{
  double get recommendedZoom {
    const double maxZoom = 17;
    const double minZoom = 7;

    // Calculate the lat/lng span
    final latSpan = (northEast.latitude - southWest.latitude).abs();
    final lonSpan = (northEast.longitude - southWest.longitude).abs();
    final maxSpan = latSpan > lonSpan ? latSpan : lonSpan;

    // Prevent log(0)
    if (maxSpan == 0) return maxZoom;

    // This is an empirically derived formula that fits Yandex/Google Maps zoom behavior
    final zoom = (log(360 / maxSpan) / ln2).clamp(minZoom, maxZoom);

    return double.parse(zoom.toStringAsFixed(2)); // optional: round to 2 decimals
  }
  Point get point=>Point(latitude: (northEast.latitude+southWest.latitude)/2, longitude: (northEast.longitude+southWest.longitude)/2,);
}
