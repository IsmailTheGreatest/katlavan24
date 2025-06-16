import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/constants/app_assets.dart';
import 'package:katlavan24/core/localization/cubit/localization_cubit.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/format_uzbek_time.dart';
import 'package:katlavan24/gen_l10n/app_localizations.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeButton(
              title: AppLocalizations.of(context)!.buyMaterials,
              iconStr: AppAssetsPng.shoppingCart,
              imageStr: AppAssetsPng.truck,
              onTap: () {
                context.read<LocalizationCubit>().changeLocale('uz', 'Latn');
              },
            ),
            SizedBox(height: 12),
            HomeButton(
              title: AppLocalizations.of(context)!.findTruck,
              iconStr: AppAssetsPng.search,
              imageStr: AppAssetsPng.bulk,
              onTap: () {
                context.read<LocalizationCubit>().changeLocale('uz', 'Cyrl');

              },
            ),
            SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.orders, style: AppStyles.s24w700),
            SizedBox(height: 12),
            DefaultTabController(
              length: 2,

              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        tabs: [
                          Tab(text: AppLocalizations.of(context)!.all),
                          Tab(text: AppLocalizations.of(context)!.active),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 12),
                              OrderDetail(
                                name: 'Kamaz',
                                vehicleNumber: 'AB123B',

                                timeLeft: Duration(minutes: 5, hours: 2),
                              ),
                              GroupOrderTile(
                                title: '2 trucks are arriving total in 5 minutes',
                                orderDetails: [
                                  OrderDetail(
                                    name: 'Kamaz',
                                    vehicleNumber: 'AB123B',

                                    timeLeft: Duration(minutes: 5, hours: 2),
                                  ),
                                  OrderDetail(
                                    name: 'Kamaz',
                                    vehicleNumber: 'AB123B',

                                    timeLeft: Duration(minutes: 5, hours: 2),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(children: [NoOrdersWidget()]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //NoOrdersWidget(),
          ],
        ),
      ),
    );
  }
}

class GroupOrderTile extends StatelessWidget {
  const GroupOrderTile({super.key, required this.orderDetails, this.title});

  final List<OrderDetail> orderDetails;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title != null
            ? Container(
              margin: EdgeInsets.only(top: 12),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Text(title!,style: AppStyles.s32w700.copyWith(fontSize: 16),),
            )
            : SizedBox(),
        Container(height: 1,
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffF0F0F0),
borderRadius: BorderRadius.circular(12)
        ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => orderDetails[index],
          itemCount: orderDetails.length,
        ),
      ],
    );
  }
}

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key, required this.vehicleNumber, required this.name, required this.timeLeft});

  final String vehicleNumber;
  final String name;
  final Duration timeLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.asset(AppAssetsPng.truckBlue, height: 36),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppStyles.s12.copyWith(fontWeight: FontWeight.w500, height: 18 / 12)),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Color(0xffeeeeee), borderRadius: BorderRadius.circular(4)),
                child: Text(vehicleNumber, style: AppStyles.s16.copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppLocalizations.of(context)!.remainingTime, style: AppStyles.s15w600),
              Text('~${formatUzbekTime(timeLeft, AppLocalizations.of(context)!.localeName)}', style: AppStyles.s15w600),
            ],
          ),

          SizedBox(width: 16),
          // Text(AppLocalizations.of(context).),
        ],
      ),
    );
  }
}

class NoOrdersWidget extends StatelessWidget {
  const NoOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment(0, -0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssetsPng.noOrders, width: 105),
            SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noOrders,
              style: AppStyles.s16.copyWith(fontWeight: FontWeight.w700, color: Color(0xff737373)),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AppBar(
          flexibleSpace: Column(
            children: [
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(AppAssetsPng.menu, height: 24),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppAssetsPng.katlavanHome, height: 14, width: 77),
                      Row(
                        children: [
                          Image.asset(AppAssetsPng.locationHome, height: 24),
                          SizedBox(width: 12),
                          SizedBox(
                            width: 140,

                            child: Text(
                              'St. Movarounnaxr 1, 24',
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.s14.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.expand_more_rounded, color: Color(0xff737373), size: 24),
                        ],
                      ),
                    ],
                  ),
                  Image.asset(AppAssetsPng.bell, height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.0);
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.imageStr,
    required this.iconStr,
    required this.title,
    required this.onTap,
  });

  final String imageStr;
  final String title;
  final VoidCallback onTap;
  final String iconStr;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Row(
          children: [
            SizedBox(width: 4),
            Image.asset(iconStr, fit: BoxFit.fitWidth, height: 24),
            SizedBox(width: 12),
            Text(title, style: AppStyles.s16.copyWith(fontWeight: FontWeight.w700)),
            Spacer(),
            Image.asset(imageStr, height: 60),
          ],
        ),
      ),
    );
  }
}
