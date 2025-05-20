class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

class TashkentLocation extends AppLatLong {
 // 41.312062,69.243188
  const TashkentLocation({
    super.lat = 41.312062,
    super.long = 69.243188,
  });
}