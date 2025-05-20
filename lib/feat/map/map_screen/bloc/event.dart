import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectMerchant extends MapEvent {
  final Merchant merchant;

  SelectMerchant(this.merchant);

  @override
  List<Object> get props => [merchant];
}

class GoToUserLocation extends MapEvent {}

class InitializeMap extends MapEvent {
  final YandexMapController controller;
  final BuildContext context;

  InitializeMap(this.context, this.controller);

  @override
  List<Object> get props => [context];
}
