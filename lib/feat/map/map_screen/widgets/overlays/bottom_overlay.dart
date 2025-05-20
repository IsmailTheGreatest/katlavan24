import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';
import 'package:katlavan24/feat/map/map_screen/bloc/event.dart';
import 'package:katlavan24/feat/map/map_screen/bloc/map_bloc.dart';
import 'package:katlavan24/feat/map/map_screen/bloc/state.dart';
import 'package:url_launcher/url_launcher.dart';


 showBottomOverlay(BuildContext context, Merchant merchant) {

    void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {

      await launchUrl(Uri.parse(url));

    } else {
      throw 'Could not launch $url';
}}
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    sheetAnimationStyle: AnimationStyle(
      curve:Curves.fastEaseInToSlowEaseOut,
      duration: const Duration(milliseconds: 300),
      reverseCurve: Curves.fastEaseInToSlowEaseOut,
      reverseDuration: const Duration(milliseconds: 300),
    ),
    context: context,
    builder: (context) {
      return BlocBuilder<MapBloc, MapState>(
        builder: (context,state) {
          return Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: 330,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: merchant.logo.isEmpty,
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(
                                10,
                              ),
                              color: const Color(0xff4059E6).withValues(alpha: 0.1),


                            ),
                            child: const Icon(
                              Icons.store,
                              color: Color(0xff4059E6),
                              size: 40,
                            ),
                          ),
                        ),

                        Visibility(
                          visible: merchant.logo.isNotEmpty,
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(
                                10,
                              ),
                              color: const Color(0xff4059E6).withValues(alpha: 0.1),
                              image: DecorationImage(
                                image: NetworkImage(merchant.logo),
                                fit: BoxFit.contain,
                              ),
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
                                child: Text(
                                  merchant.name,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                child: Text(
                                  "Магазин электроники\n",
                                  style: TextStyle(
                                    overflow: TextOverflow.visible,
                                    fontSize: 13,
                                    color: Color(0xff74747b),
                                  ),
                                ),
                              ),
                              const Text("Другие филиалы",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff4059E6),
                                  )),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            context.read<MapBloc>().add(SelectMerchant(merchant));
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, right: 5),
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xfff4f4f5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xff4059E6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(
                      color: const Color(0xff040415).withValues(alpha: 0.1),
                      thickness: 1,
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffF4F4F5),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 58,
                            width: MediaQuery.of(context).size.width - 120,
                            child: InkWell(
                              onTap: () {
                                context.read<MapBloc>().add(SelectMerchant(merchant));
                                Navigator.pop(context);
                              },
                              child: Text(
                                merchant.address.address,
                                maxLines: 5,

                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(

                                  fontSize: 14,
                                  color: Color(0xff040405),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: InkWell(
                        onTap: () {

                          launchURL("tel:${merchant.phoneNumber}");

                        },
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF4F4F5),
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 120,
                              child: Text(
                               '+${merchant.phoneNumber}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff62c994),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffF4F4F5),
                            ),
                            child: const Icon(
                              Icons.access_time_filled_rounded,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: const Text(
                              "пн-пт 10:00-21:00, сб-вс 10:00-20:00",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff040405),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
        }
      );
        },


  );}
