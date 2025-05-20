import 'dart:async';

import 'package:flutter/services.dart';
import 'package:katlavan24/core/services/azimuth_calculate.dart';
import 'package:katlavan24/core/services/get_geometry.dart';
import 'package:katlavan24/feat/map/data/models/app_lat_long.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'app_location.dart';

class MapService {
  final Completer<YandexMapController> mapControllerCompleter =
      Completer<YandexMapController>();

  Future<void> loadMapStyle(YandexMapController controller) async {
    final styleJson = await rootBundle.loadString('assets/map_style.json');
    controller.setMapStyle(styleJson);
    controller.setMaxZoom(zoom: 17);
    controller.moveCamera(CameraUpdate.tiltTo(67.5));
  }

  Future<AppLatLong> fetchCurrentLocation() async {
    try {
      return await LocationService().getCurrentLocation();
    } catch (_) {
      return const TashkentLocation();
    }
  }

  Future<void> moveToCurrentLocation(YandexMapController controller,
      AppLatLong userLocation, List<AppLatLong> merchantLocation) async {
    merchantLocation.add(userLocation);
    final geometry = getGeometry(merchantLocation);
    controller.moveCamera(CameraUpdate.azimuthTo(
        calculateAzimuth(userLocation, merchantLocation.first)));


    controller.moveCamera(
      animation:
          const MapAnimation(type: MapAnimationType.smooth, duration: 0.4),
      CameraUpdate.newGeometry(
        geometry,
      ),
    );
  }

  PlacemarkMapObject createUserLocationPlacemark(AppLatLong location) {
    return PlacemarkMapObject(
      opacity: 0.9,
      mapId: const MapObjectId('user_location'),
      point: Point(latitude: location.lat, longitude: location.long),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('assets/current.png'),
        scale: 0.5,
      )),
    );
  }

  Future<List<PlacemarkMapObject>> initializePlacemarks(
    List<Merchant> merchants, {
    required void Function(Merchant) onMerchantTap,
  }) async {
    final placemarks = merchants
        .map(
          (merchant) => PlacemarkMapObject(
            opacity: 0.8,
            mapId: MapObjectId(merchant.guid),
            text: PlacemarkText(
                text: merchant.name,
                style: const PlacemarkTextStyle(
                  offsetFromIcon: true,
                  offset: 23,
                  outlineColor: Color(0xFF000000),
                  placement: TextStylePlacement.right,
                  color: Color(0xFFFFFFFF),
                )),
            point: Point(
                latitude: merchant.address.latitude,
                longitude: merchant.address.longitude),
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                anchor: const Offset(0, 0),
                isFlat: false,
                zIndex: 1,
                image: BitmapDescriptor.fromAssetImage('assets/merchant.png'),
                scale: 0.5,
              ),
            ),
            onTap: (PlacemarkMapObject self, Point point) {
              onMerchantTap(merchant);
            },
          ),
        )
        .toList();

    return placemarks;
  }
}
