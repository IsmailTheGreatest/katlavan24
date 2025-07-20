import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/materials.dart';
import 'package:katlavan24/core/enums/status_enum.dart';
import 'package:katlavan24/core/enums/units.dart';
import 'package:katlavan24/core/utils/extension_utils/is_null.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

part 'map_rent_state.dart';

class MapRentCubit extends Cubit<MapRentState> {
  MapRentCubit() : super(MapRentState()) {
    volumeController.addListener(isButtonEnabled);
    roundTripController.addListener(isButtonEnabled);
  }

  final volumeController = TextEditingController();
  final descriptionController = TextEditingController();
  final roundTripController = TextEditingController();

  void setLoading() {
    emitG(state.copyWith(selectedAddressStatus: Status.loading));
  }

  emitG(MapRentState state) {
    emit(state);
    isButtonEnabled();
  }

  void lowerStage() {
    emitG(state.copyWith(stage: StageRent.values[state.stage.index - 1]));
  }

  void enableIgnore() {
    emitG(state.copyWith(tapIgnore: true));
  }

  void disableIgnore() {
    emitG(state.copyWith(tapIgnore: false));
  }

  void setInit() {
    emitG(state.copyWith(selectedAddressStatus: Status.init));
  }

  void selectPickupAddress(GeoObject address, {bool isTapping = false, required Point point}) {
    emitG(state.copyWith(selectedPickUp: address, isTappingOnMap: isTapping, selectedPickUpPoint: point));
  }

  void selectDropOffAddress(GeoObject address, {bool isTapping = false, required Point point}) {
    emitG(state.copyWith(selectedDropOff: address, isTappingOnMap: isTapping, selectedDropOffPoint: point));
  }

  void hideBottom() {
    emitG(state.copyWith(hideBottom: true));
  }

  void showBottom() {
    emitG(state.copyWith(hideBottom: false));
  }

  void goFourth() {
    emitG(state.copyWith(stage: StageRent.fourth));
  }

  bool shouldButtonBeEnabled() {
    switch (state.stage) {
      case StageRent.initial:
        return state.selectedPickUp.isNotNull && state.selectedDropOff.isNotNull;
      case StageRent.selectedLocation:
        return state.selectedMaterial.isNotNull && volumeController.text.trim().isNotEmpty;
      case StageRent.third:
        return state.trucks.isNotEmpty && state.selectedPayment.isNotNull;
      case StageRent.fourth:
        return false;
      case StageRent.fifth:
        return false;
      case StageRent.sixth:
        return false;
    }
  }

  void isButtonEnabled() {
    bool isEnabled = shouldButtonBeEnabled();
    emit(state.copyWith(buttonEnabled: isEnabled ? ToggleState.enabled : ToggleState.disabled));
  }

  void goToTheInitial() {
    emitG(state.copyWith(stage: StageRent.initial));
  }

  void goToTheSelectedLocation() {
    emitG(state.copyWith(stage: StageRent.selectedLocation));
  }

  void selectMaterial(Materials material) {
    emitG(state.copyWith(selectedMaterial: material));
  }

  void selectUnit(Units unit) {
    emitG(state.copyWith(selectedUnit: unit));
  }

  void changeRoundTrip(bool val) {
    emitG(state.copyWith(roundTripEnabled: val));
  }

  void increaseStage() {
    emitG(state.copyWith(stage: StageRent.values[state.stage.index + 1]));

    if (StageRent.values[state.stage.index].isFourth) {
      Future.delayed(Duration(seconds: 5), () {
        increaseStage();
      });
    }
    if (StageRent.values[state.stage.index].isFifth) {
      Future.delayed(Duration(seconds: 10), () {
        increaseStage();
      });
    }
  }

  void replaceTruck(int index, TruckRent truck) {
    final list = [...state.trucks];
    list.removeAt(index);
    list.insert(index, truck);
    emitG(state.copyWith(trucks: list));
  }

  void addTruck() {
    emitG(state.copyWith(trucks: [...state.trucks, TruckRent.small]));
  }

  void removeTruck(int i) {
    final list = [...state.trucks];
    list.removeAt(i);
    emitG(state.copyWith(trucks: list));
  }

  void selectPayment(Payment payment) {
    emitG(state.copyWith(selectedPayment: payment));
  }
}
