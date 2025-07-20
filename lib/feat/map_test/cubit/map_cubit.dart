import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/materials.dart';
import 'package:katlavan24/core/enums/status_enum.dart';
import 'package:katlavan24/core/enums/units.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapState()) {
    volumeController.addListener(checkThirdStage);
  }

  final volumeController = TextEditingController();

  void setLoading() {
    emit(state.copyWith(selectedAddressStatus: Status.loading));
  }

  void lowerStage() {
    emit(state.copyWith(stage: Stage.values[state.stage.index-1]));
  }

  bool checkThirdStage() {
    final isEligible =
        state.selectedMaterial != null && state.selectedAddress != null && volumeController.text.isNotEmpty;
    if (isEligible) {
      emit(state.copyWith(stage: Stage.third));
      return true;
    } else {
      return false;
    }
  }

  void enableIgnore() {
    emit(state.copyWith(tapIgnore: true));
  }

  void disableIgnore() {
    emit(state.copyWith(tapIgnore: false));
  }

  void selectTruck(Truck truck) {
    emit(state.copyWith(selectedTruck: truck));
  }

  void selectUnit(Units? unit) {
    emit(state.copyWith(selectedUnit: unit));
    checkThirdStage();
  }

  void selectMaterial(Materials material) {
    emit(state.copyWith(selectedMaterial: material));
    checkThirdStage();
  }

  void setInit() {
    emit(state.copyWith(selectedAddressStatus: Status.init));
  }

  void selectAddress(String address) {
    emit(state.copyWith(selectedAddress: address));

  }

  void hideBottom() {
    emit(state.copyWith(hideBottom: true));
  }

  void showBottom() {
    emit(state.copyWith(hideBottom: false));
  }

  void goFourth() {
    if (checkThirdStage()) {
      emit(state.copyWith(stage: Stage.fourth));
    }
  }

  void goFifth() {
    if (checkThirdStage()) {
      emit(state.copyWith(stage: Stage.fifth));
    }
  }

  void goToTheInitial() {
    emit(state.copyWith(stage: Stage.initial));
  }

  void goToTheSelectedLocation() {
    emit(state.copyWith(stage: Stage.selectedLocation));
  }
}
