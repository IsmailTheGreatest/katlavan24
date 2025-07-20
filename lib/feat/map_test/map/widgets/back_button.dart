import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/stage.dart';
import 'package:katlavan24/feat/map_test/cubit/map_cubit.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
class KatlavanBackButton extends StatelessWidget {
  const KatlavanBackButton({super.key, required this.stage});
  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.all(4),
        visualDensity: VisualDensity.compact,
        onPressed: (){
          stage.isInitial?
          Navigator.pop(context):context.read<MapCubit>().lowerStage();}, icon: Image.asset('assets/map/back.png',height: 24,width: 24,));
  }
}

class KatlavanRentBackButton extends StatelessWidget {
  const KatlavanRentBackButton({super.key, required this.stage});
  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.all(4),
        visualDensity: VisualDensity.compact,
        onPressed: (){
          stage.isInitial?
          Navigator.pop(context):context.read<MapRentCubit>().lowerStage();}, icon: Image.asset('assets/map/back.png',height: 24,width: 24,));
  }
}
