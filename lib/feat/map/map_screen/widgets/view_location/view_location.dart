import 'package:flutter/material.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/overlays/bottom_overlay.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/small_container/small_container.dart';




class ViewLocation extends StatelessWidget {
  final Merchant merchant;


  const ViewLocation(
      {super.key,
       required this.merchant});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(15),
      width: width - 50,
      height: 149,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: merchant.logo.isNotEmpty,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(

                    borderRadius:  BorderRadius.circular(10),
                    color: const Color(0xff4059E6).withValues(alpha: 0.1),
                    image: DecorationImage(
                      image: NetworkImage(merchant.logo),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: merchant.logo.isEmpty,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(

                    borderRadius:  BorderRadius.circular(10),
                    color: const Color(0xff4059E6).withValues(alpha: 0.1),

                  ),
                  child: const Icon(
                    Icons.store,
                    color: Color(0xff4059E6),
                    size: 40,
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width - 172,
                      child: Text(
                        merchant.name,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width - 173,
                      height: 38,
                      child: Text(
                        merchant.address.address,
                        style: const TextStyle(
                          overflow: TextOverflow.fade,
                          fontSize: 13,
                          color: Color(0xff74747b),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SmallContainer(
                isKm: true,
                  text: (merchant.address.distance).toStringAsFixed(1), icon: Icons.location_on, onTap: () {}),
              SmallContainer(
                  isKm: false,
                  text: (merchant.address.distance*10).toStringAsFixed(1),
                  icon: Icons.directions_walk,
                  onTap: () {}),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showBottomOverlay(context, merchant);
                  // Open details screen
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xff4059E6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Подробнее',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}