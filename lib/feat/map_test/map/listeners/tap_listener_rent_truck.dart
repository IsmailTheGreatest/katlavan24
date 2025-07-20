
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

class TapListener<T extends BlocBase<S>, S> extends MapInputListener {
  final void Function(Map map, Point point, S state) onObjectTapp;
  final BuildContext context;

  TapListener(this.context, this.onObjectTapp);

  @override
  void onMapLongTap(Map map, Point point) {
    return;
  }

  @override
  void onMapTap(Map map, Point point) {
    onObjectTapp.call(map, point, context.read<T>().state);
  }
}
