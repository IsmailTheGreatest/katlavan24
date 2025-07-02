part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState( {
    this.selectedUnit = Units.m3,
    this.selectedTruck=Truck.small,
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

  MapState copyWith({
    String? selectedAddress,
    Truck? selectedTruck,
    Materials? selectedMaterial,
    Units? selectedUnit,
    Status? selectedAddressStatus,
    bool? hideBottom,
    Stage? stage,
  }) =>
      MapState(
        selectedTruck: selectedTruck??this.selectedTruck,
          selectedMaterial: selectedMaterial ?? this.selectedMaterial,
          selectedUnit: selectedUnit ?? this.selectedUnit,
          stage: stage ?? this.stage,
          selectedAddress: selectedAddress ?? this.selectedAddress,
          hideBottom: hideBottom ?? this.hideBottom,
          selectedAddressStatus: selectedAddressStatus ?? this.selectedAddressStatus);

  @override
  List<Object?> get props =>
      [selectedAddress, hideBottom, selectedAddressStatus, stage, selectedMaterial, selectedUnit,selectedTruck];
}

//todo:move to different file
enum Stage { initial, selectedLocation, third }

extension StageX on Stage {
  bool get isInitial => this == Stage.initial;

  bool get isSelectedLocation => this == Stage.selectedLocation;

  bool get isThird => this == Stage.third;
}

enum Materials { qum, sement, shagal, ohak, gisht }

extension MaterialX on Materials {
  String get toPretty {
    switch (this) {
      case Materials.gisht:
        return "G'isht";
      case Materials.qum:
        return "Qum";
      case Materials.sement:
        return "Sement";
      case Materials.shagal:
        return "Shag'al";
      case Materials.ohak:
        return "Ohak";
    }
  }
}

enum Units { m3, m2, kg, dona }

extension UnitsX on Units {
  String get toPretty {
    switch (this) {
      case Units.m3:
        return 'm\u00B3';
      case Units.m2:
        return 'm\u00B2';

      case Units.kg:
        return 'kg';
      case Units.dona:
        return 'dona';
    }
  }
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
