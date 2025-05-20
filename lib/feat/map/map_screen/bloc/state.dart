
import 'package:equatable/equatable.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';



class MapState extends Equatable {
  final List<PlacemarkMapObject> placemarks;


  const MapState( {required this.placemarks,});

  @override
  List<Object> get props => [placemarks];
}
