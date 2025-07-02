import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/status_enum.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapState()){
    volumeController.addListener(checkThirdStage);
  }
  final volumeController = TextEditingController();

  void setLoading() {
    emit(state.copyWith(selectedAddressStatus: Status.loading));
  }

  void checkThirdStage() {
    final isEligible=state.selectedMaterial!=null&&state.selectedAddress!=null&&volumeController.text.isNotEmpty;
    if(isEligible){
      emit(state.copyWith(stage: Stage.third));

    }else{}
  }
  void selectTruck(Truck truck){
    emit(state.copyWith(selectedTruck: truck));
  }
  void selectUnit(Units? unit){
    emit(state.copyWith(selectedUnit: unit));
    checkThirdStage();
  }
  void selectMaterial(Materials material){
    emit(state.copyWith(selectedMaterial: material));
    checkThirdStage();

  }
  void setInit() {
    emit(state.copyWith(selectedAddressStatus: Status.init));
  }

  void selectAddress(String address) {
    emit(state.copyWith(selectedAddress: address));
    checkThirdStage();
  }

  void hideBottom() {
    emit(state.copyWith(hideBottom: true));
  }

  void showBottom() {
    emit(state.copyWith(hideBottom: false));
  }

  void goToTheSelectedLocation() {
    emit(state.copyWith(stage: Stage.selectedLocation));
  }
}
