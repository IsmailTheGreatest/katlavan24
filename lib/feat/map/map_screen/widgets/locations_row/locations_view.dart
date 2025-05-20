import 'package:flutter/material.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';



import '../view_location/view_location.dart';
class LocationsRow extends StatelessWidget {
  final List<Merchant> merchants;
   const LocationsRow({
    super.key, required this.merchants,
  });

  @override
  Widget build(BuildContext context) {
    return  Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 149,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount:merchants.length,
            itemBuilder: (context,index)=>ViewLocation(
              merchant: merchants[index],
            ),
          ),
        )
        ),
    );

  }
}
