import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/feat/map_test/cubit/map_cubit.dart';

class TruckCont extends StatelessWidget {
  const TruckCont({super.key, required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<MapCubit>().selectTruck(truck),
      child: Ink(
        height: double.infinity,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      truck.imgLocalUrl,
                      scale: 0.5,
                    ))),
            Text(
              truck.name,
              style: AppStyles.s14.copyWith(fontWeight: FontWeight.w700, color: AppColors.black),
            ),
            SizedBox(height: 4),
            Text(truck.model, style: AppStyles.s14.copyWith(fontWeight: FontWeight.w500, color: AppColors.grayColor)),
          ],
        ),
      ),
    );
  }
}
