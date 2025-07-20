import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/widgets/buttons.dart';

class LocationRow extends StatelessWidget {
  const LocationRow({
    super.key,
    this.isFrom = false,
    required this.name,
  });

  final String? name;
  final bool isFrom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/map/location.png',
            width: 24,
            height: 24,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFrom ? 'From' : 'To',
                  style:
                  AppStyles.s12.copyWith(height: 18 / 12, fontWeight: FontWeight.w500, color: AppColors.grayColor),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  name??'',
                  style: AppStyles.s15w600.copyWith(color: AppColors.black, height: 18 / 15),
                )
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 40,
            child: SecondaryButton(
              'Details',
              localImagePath: 'assets/map/info.png',
              iconSize: 20,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
