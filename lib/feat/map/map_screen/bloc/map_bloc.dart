
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/services/map_service.dart';
import 'package:katlavan24/feat/map/data/models/app_lat_long.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';
import 'package:katlavan24/feat/map/map_screen/bloc/state.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/overlays/bottom_overlay.dart';

import 'event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapService mapService;

  final List<Merchant> merchants;

  MapBloc(this.mapService, this.merchants)
      : super(const MapState(placemarks: [])) {
    on<InitializeMap>((event, emit) async {
      mapService.mapControllerCompleter.complete(event.controller);
      final controller = await mapService.mapControllerCompleter.future;
      await mapService.loadMapStyle(controller);
      final location = await mapService.fetchCurrentLocation();
      await mapService.moveToCurrentLocation(
          controller,
          location,
          merchants
              .map((e) => AppLatLong(
              lat: e.address.latitude, long: e.address.longitude))
              .toList());
      final userPlacemark = mapService.createUserLocationPlacemark(location);
      final placemarks = await mapService.initializePlacemarks(
        merchants,
        onMerchantTap: (merchant) {
          showBottomOverlay(event.context, merchant);
        }
      );
      emit(MapState(
        placemarks: [...placemarks, userPlacemark],
      ));
    });

    on<GoToUserLocation>((event, emit) async {
      final controller = await mapService.mapControllerCompleter.future;
      final location = await mapService.fetchCurrentLocation();
      await mapService.moveToCurrentLocation(controller, location, [location]);
    });

    on<SelectMerchant>((event, emit) async {
      final controller = await mapService.mapControllerCompleter.future;
      final location = AppLatLong(
          lat: event.merchant.address.latitude,
          long: event.merchant.address.longitude);
      await mapService.moveToCurrentLocation(controller, location, [location]);
    });
  }
}
