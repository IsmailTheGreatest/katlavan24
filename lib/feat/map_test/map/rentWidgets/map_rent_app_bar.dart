import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:katlavan24/core/enums/status_enum.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

class MapRentAppBar extends StatelessWidget {
  const MapRentAppBar({super.key, this.selectedAddress, required this.selectedAddressStatus});
final GeoObject? selectedAddress;
final Status selectedAddressStatus;
  @override
  Widget build(BuildContext context) {
      return Material(
        color: Colors.transparent,
        child: Ink(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white70,
                  Colors.white54,
                  Colors.white.withValues(alpha: 0.01),
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            child: Column(
              children: [
                SafeArea(top: true, bottom: false, child: SizedBox()),
                Text(
                  'Pinned location',
                  style: AppStyles.s14.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                selectedAddressStatus.isLoading?CupertinoActivityIndicator():Text(
                  selectedAddress?.name ?? 'None',
                  style: AppStyles.s14.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            )),
      );

  }
}
