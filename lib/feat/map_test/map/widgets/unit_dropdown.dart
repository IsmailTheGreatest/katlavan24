import 'package:flutter/material.dart';
import 'package:katlavan24/core/enums/units.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';



class UnitDropDown extends StatelessWidget {
  const UnitDropDown({
    super.key,
    required this.selectedUnit,
    required this.onChanged,
  });

  final Units selectedUnit;
  final Function(Units unit) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.grayLight4),
      child: DropdownButton<Units>(
          underline: SizedBox(),
          style: AppStyles.s14.copyWith(color: AppColors.grayColor),
          isExpanded: true,
          isDense: true,
          value: selectedUnit,
          padding: EdgeInsets.zero,
          icon: Image.asset('assets/map/down_arrow.png'),
          dropdownColor: Colors.white,
          focusColor: Colors.transparent,
          elevation: 0,
          borderRadius: BorderRadius.circular(16),
          items: Units.values
              .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e.toPretty,
              )))
              .toList(),
          onChanged: (unit) {
            if (unit == null) {
              return;
            }
            onChanged(unit);
          }),
    );
  }
}
