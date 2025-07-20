part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    this.tapIgnore = false,
    this.selectedUnit = Units.m3,
    this.selectedTruck = Truck.small,
    this.selectedMaterial,
    this.hideBottom = false,
    this.selectedAddress,
    this.selectedAddressStatus = Status.init,
    this.stage = Stage.initial,
  });

  final String? selectedAddress;
  final Status selectedAddressStatus;
  final bool hideBottom;
  final Truck selectedTruck;
  final Stage stage;
  final Materials? selectedMaterial;
  final Units selectedUnit;
  final bool tapIgnore;

  MapState copyWith({
    String? selectedAddress,
    Truck? selectedTruck,
    Materials? selectedMaterial,
    Units? selectedUnit,
    Status? selectedAddressStatus,
    bool? hideBottom,
    Stage? stage,
    bool? tapIgnore,
  }) =>
      MapState(
          tapIgnore: tapIgnore ?? this.tapIgnore,
          selectedTruck: selectedTruck ?? this.selectedTruck,
          selectedMaterial: selectedMaterial ?? this.selectedMaterial,
          selectedUnit: selectedUnit ?? this.selectedUnit,
          stage: stage ?? this.stage,
          selectedAddress: selectedAddress ?? this.selectedAddress,
          hideBottom: hideBottom ?? this.hideBottom,
          selectedAddressStatus: selectedAddressStatus ?? this.selectedAddressStatus);

  @override
  List<Object?> get props => [
        selectedAddress,
        hideBottom,
        selectedAddressStatus,
        stage,
        selectedMaterial,
        selectedUnit,
        selectedTruck,
        tapIgnore
      ];
}




enum Truck {
  small('Small Truck', 'Havo-65801', 'assets/map/small_truck.png'),
  big('Big Truck', 'KamAZ-65801', 'assets/map/big_truck.png'),
  multiple('Multiple trucks', 'Havo', 'assets/map/multiple_trucks.png');

  final String name;
  final String model;
  final String imgLocalUrl;

  const Truck(this.name, this.model, this.imgLocalUrl);
}
