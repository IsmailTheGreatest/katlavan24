import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/stage.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/extension_utils/is_null.dart';
import 'package:katlavan24/core/utils/extension_utils/widget_extension.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

class CustomTopAppBar extends StatelessWidget {
  final Stage stage;
  final GeoObject? selectedDropOff;
  final GeoObject? selectedPickup;
  final Widget nextWidget;
  final String? customLabel;

  const CustomTopAppBar(this.stage,
      {super.key, required this.nextWidget, required this.selectedDropOff, required this.selectedPickup, this.customLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              .copyWith(top: MediaQuery.of(context).viewPadding.top + 12),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(offset: Offset(0, 4), blurRadius: 12, color: Colors.black.withValues(alpha: 0.08))],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
          child: Row(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.grayLight3,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      stage.index.toString(),
                      style: AppStyles.s20w700.copyWith(color: AppColors.black),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                ],
              ).checkCond(customLabel.isNull),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       customLabel?? switch (stage) {
                          Stage.initial => '',
                          Stage.selectedLocation => 'Material & Supplier',
                          Stage.third => 'Truck',
                          Stage.fourth => 'throw UnimplementedError()',
                          Stage.fifth => 'throw UnimplementedError()',
                          _ => '',
                        },
                        style: AppStyles.s20w700.copyWith(height: 26 / 20, color: AppColors.black)),
                    SizedBox(
                      height: 2,
                    ),
                    customLabel.isNotNull?SizedBox():Text(
                       switch (stage) {
                          Stage.initial => '',
                          Stage.selectedLocation => 'Enter details of materials & supplier',
                          Stage.third => '${selectedPickup?.name} \u2192 ${selectedPickup?.name}',
                          Stage.fourth => 'hrow UnimplementedError()',
                          Stage.fifth => 'throw UnimplementedError()',
                          _ => ''
                        },
                        style: AppStyles.s14.copyWith(fontWeight: FontWeight.w500, color: AppColors.grayColor)),
                  ],
                ),
              ),
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                  customLabel.isNull?  context.read<MapRentCubit>().lowerStage():Navigator.pop(context);
                  },
                  icon: Container(
                      padding: EdgeInsets.all(7),
                      decoration: ShapeDecoration(shape: CircleBorder(), color: AppColors.grayColor),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 12,
                      )))
            ],
          ),
        ),
        Stack(
          children: [
            nextWidget,
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        stops: [0, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.08), Colors.transparent])),
              ),
            )
          ],
        )
      ],
    );
  }
}
