import 'dart:math';

double calculateAzimuth(AppLatLong start, AppLatLong end) {
  // Convert latitudes and longitudes from degrees to radians
  double startLatRad = start.lat * pi / 180;
  double startLonRad = start.long * pi / 180;
  double endLatRad = end.lat * pi / 180;
  double endLonRad = end.long * pi / 180;

  // Compute delta longitude
  double deltaLon = endLonRad - startLonRad;

  // Calculate azimuth
  double y = sin(deltaLon) * cos(endLatRad);
  double x = cos(startLatRad) * sin(endLatRad) - sin(startLatRad) * cos(endLatRad) * cos(deltaLon);

  double azimuthRad = atan2(y, x);

  // Convert radians to degrees and normalize to [0, 360)
  double azimuthDeg = (azimuthRad * 180 / pi + 360) % 360;
  return azimuthDeg;
}

class AppLatLong {
  const AppLatLong(this.lat, this.long);

  final double lat, long;
}
