part of 'map_rent_cubit.dart';

class MapRentState extends Equatable {
  const MapRentState({
    this.selectedPayment,
    this.selectedMaterial,
    this.isTappingOnMap = false,
    this.tapIgnore = false,
    this.hideBottom = false,
    this.selectedPickUp,
    this.selectedPickUpPoint,
    this.selectedDropOffPoint,
    this.selectedDropOff,
    this.selectedAddressStatus = Status.init,
    this.stage = Stage.initial,
    this.selectedUnit = Units.m3,
    this.roundTripEnabled = false,
    this.buttonEnabled = ToggleState.disabled,
    this.trucks = const [TruckRent.small],
  });

  final GeoObject? selectedPickUp;
  final Point? selectedPickUpPoint;
  final GeoObject? selectedDropOff;
  final Materials? selectedMaterial;
  final Units selectedUnit;
  final bool roundTripEnabled;
  final Point? selectedDropOffPoint;
  final Status selectedAddressStatus;
  final bool hideBottom;
  final bool isTappingOnMap;
  final Stage stage;
  final bool tapIgnore;
  final ToggleState buttonEnabled;
  final List<TruckRent> trucks;
  final Payment? selectedPayment;

  MapRentState copyWith({
    GeoObject? selectedPickUp,
    GeoObject? selectedDropOff,
    Point? selectedPickUpPoint,
    Point? selectedDropOffPoint,
    Status? selectedAddressStatus,
    bool? hideBottom,
    Stage? stage,
    bool? tapIgnore,
    Materials? selectedMaterial,
    bool? isTappingOnMap,
    Units? selectedUnit,
    bool? roundTripEnabled,
    ToggleState? buttonEnabled,
    bool? buttonEnabledUpdated,
    List<TruckRent>? trucks,
    Payment? selectedPayment,
  }) =>
      MapRentState(
          roundTripEnabled: roundTripEnabled ?? this.roundTripEnabled,
          selectedUnit: selectedUnit ?? this.selectedUnit,
          selectedPayment: selectedPayment ?? this.selectedPayment,
          selectedMaterial: selectedMaterial ?? this.selectedMaterial,
          selectedDropOffPoint: selectedDropOffPoint ?? this.selectedDropOffPoint,
          selectedPickUpPoint: selectedPickUpPoint ?? this.selectedPickUpPoint,
          tapIgnore: tapIgnore ?? this.tapIgnore,
          selectedDropOff: selectedDropOff ?? this.selectedDropOff,
          stage: stage ?? this.stage,
          selectedPickUp: selectedPickUp ?? this.selectedPickUp,
          hideBottom: hideBottom ?? this.hideBottom,
          selectedAddressStatus: selectedAddressStatus ?? this.selectedAddressStatus,
          isTappingOnMap: isTappingOnMap ?? false,
          buttonEnabled: buttonEnabled ?? this.buttonEnabled,
          trucks: trucks ?? this.trucks);

  @override
  List<Object?> get props => [
        selectedPickUp,
        hideBottom,
        selectedAddressStatus,
        stage,
        tapIgnore,
        selectedDropOff,
        isTappingOnMap,
        selectedPickUpPoint,
        selectedDropOffPoint,
        selectedMaterial,
        selectedUnit,
        roundTripEnabled,
        buttonEnabled,
        trucks,
        selectedPayment
      ];
}

enum Payment { cash, payme, click, card }

enum TruckRent {
  small('KamAZ-65115', '10–15 m³ (~14 tons)', 'assets/map/small_truck_dimension.png', Capacity(2, 5, 1.2, 4)),
  big('KamAZ-65801', '20–25 m³ (~32–41 tons)', 'assets/map/big_truck_dimension.png', Capacity(3, 12, 2, 9));

  final String capacity;
  final String urlImage;
  final String modelName;
  final Capacity size;

  const TruckRent(this.modelName, this.capacity, this.urlImage, this.size);
}

class Capacity {
  final num height, length, insideHeight, insideLength;

  List<(String, num)> get values => [
  ('Height', height),
  ('Length', length),
  ('Inside Height', insideHeight),
  ('Inside Length', insideLength)
      ];

  const Capacity(this.height, this.length, this.insideHeight, this.insideLength);
}

enum ToggleState {
  enabled,
  disabled;

  bool get isEnabled => this == ToggleState.enabled;

  bool get isDisabled => this == ToggleState.disabled;
}
