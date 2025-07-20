import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/materials.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
import 'package:smooth_corner/smooth_corner.dart';

class RentTruckChoiceChip extends StatelessWidget {
  const RentTruckChoiceChip({super.key, required this.material, required this.isSelected});

  final bool isSelected;
  final Materials material;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: SmoothRectangleBorder(smoothness: 1, borderRadius: BorderRadius.circular(8)),
        onTap: () {
          context.read<MapRentCubit>().selectMaterial(material);
        },
        child: Ink(
          //  smoothness: 1,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              smoothness: 1,
              borderRadius: BorderRadius.circular(8),
            ),
            color: AppColors.grayLight3,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomRadioButton(isSelected: isSelected),
              SizedBox(
                width: 12,
              ),
              Text(
                material.toPretty,
                style: AppStyles.s14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.isSelected,
    this.innerPadding,
    this.size,
    this.disabledColor,
  });

  final EdgeInsets? innerPadding;
  final bool isSelected;
  final double? size;
  final Color? disabledColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 18,
      height: size ?? 18,
      padding: innerPadding ?? EdgeInsets.all(1.5),
      decoration: ShapeDecoration(
          shape: CircleBorder(
              side: BorderSide(color: isSelected ? AppColors.mainColor : disabledColor ?? Color(0xff595D62)))),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            ShapeDecoration(shape: CircleBorder(), color: isSelected ? AppColors.mainColor : Colors.transparent),
      ),
    );
  }
}
