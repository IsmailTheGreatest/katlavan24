import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/map_test/cubit/map_cubit.dart';
import 'package:katlavan24/feat/map_test/map/widgets/back_button.dart';

class IntroBottomSheet extends StatelessWidget {
  const IntroBottomSheet({super.key, required this.button});
final Widget button;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return state.hideBottom
          ? SizedBox.shrink()
          : Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: button),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: Colors.black12,
                            offset: Offset(0, -4),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              16,
                            ),
                            topRight: Radius.circular(16))),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      top: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            KatlavanBackButton(),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                switch (state.stage) {
                                  Stage.initial => 'Choose where your materials will be delivered.',
                                  Stage.selectedLocation => 'Enter materials types',
                                  Stage.third => 'Select Trucks Tariff',
                                },
                                style: AppStyles.s24w700.copyWith(fontSize: 20, height: 26 / 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Material(
                          child: InkWell(
                            onTap: () {
                              showAddressPicking(context);
                            }, // Add your search navigation logic
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.pin_drop_outlined,
                                      color: state.selectedAddress != null ? AppColors.mainColor : Colors.grey),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      state.selectedAddress ?? 'Search a location',
                                      style: AppStyles.s14.copyWith(
                                          fontWeight: state.selectedAddress != null ? FontWeight.w600 : FontWeight.w500,
                                          color: state.selectedAddress != null ? AppColors.black : AppColors.grayColor),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedCrossFade(
                          crossFadeState:
                              state.stage == Stage.initial ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          firstChild: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: PrimaryButton('Enter material details', isEnabled: state.selectedAddress != null,
                                onTap: () {
                              context.read<MapCubit>().goToTheSelectedLocation();
                            }),
                          ),
                          duration: Duration(milliseconds: 500),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Material information',
                                style: AppStyles.s16.copyWith(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.grayLight4),
                                child: DropdownButton<Materials>(
                                    underline: SizedBox(),
                                    style: AppStyles.s14.copyWith(color: AppColors.grayColor),
                                    hint: Text('Material type'),
                                    value: state.selectedMaterial,
                                    isExpanded: true,
                                    isDense: true,
                                    padding: EdgeInsets.zero,
                                    icon: Image.asset('assets/map/down_arrow.png'),
                                    dropdownColor: Colors.white,
                                    focusColor: Colors.transparent,
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(16),
                                    items: Materials.values
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e.toPretty,
                                            )))
                                        .toList(),
                                    onChanged: (material) {
                                      if (material == null) return;
                                      context.read<MapCubit>().selectMaterial(material);
                                    }),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8), color: AppColors.grayLight4),
                                      child: DropdownButton<Units>(
                                          underline: SizedBox(),
                                          style: AppStyles.s14.copyWith(color: AppColors.grayColor),
                                          isExpanded: true,
                                          isDense: true,
                                          value: state.selectedUnit,
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
                                            context.read<MapCubit>().selectUnit(unit);
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      controller: context.read<MapCubit>().volumeController,
                                      style: AppStyles.s14.copyWith(height: 24 / 14, color: AppColors.grayColor),
                                      decoration: InputDecoration(
                                        hintText: 'Volume',
                                        isDense: true,
                                        hintStyle: AppStyles.s14.copyWith(height: 24 / 14, color: AppColors.grayColor),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: AppColors.grayLight4)),
                                        contentPadding: EdgeInsets.all(12),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              AnimatedCrossFade(
                                firstCurve: Curves.easeInOutCubic,
                                  firstChild: SizedBox(),
                                  secondChild: Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: SizedBox(
                                      height: (MediaQuery.of(context).size.width - 32) / Truck.values.length,
                                      child: Stack(
                                        children: [
                                          AnimatedPositioned(
                                              bottom: 0,
                                              top: 0,
                                              curve: Curves.easeIn,
                                              left: ((MediaQuery.of(context).size.width - 32) / Truck.values.length) *
                                                  state.selectedTruck.index,
                                              duration: Duration(milliseconds: 300),
                                              child: Container(
                                                decoration: ShapeDecoration(
                                                    color: AppColors.grayLight4,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),
                                                    )),
                                                width: (MediaQuery.of(context).size.width - 32) / Truck.values.length,
                                              )),
                                          Row(
                                              children:
                                                  Truck.values.map((e) => Expanded(child: TruckCont(truck: e))).toList()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  crossFadeState:
                                      state.stage.isThird ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 600)),
                              SizedBox(
                                height: 24,
                              ),
                              PrimaryButtonAlt(
                                'Search',
                                isEnabled: state.stage.isThird,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}

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

showAddressPicking(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                _SearchBarWithActions(context),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: 10,
                    separatorBuilder: (_, __) => Divider(
                      indent: 56,
                      height: 8,
                      color: AppColors.grayLight4,
                    ),
                    itemBuilder: (ctx, index) {
                      index++;
                      return ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.only(left: 20, top: 0, bottom: 0),
                        leading: Image.asset(
                          'assets/map/location.png',
                          height: 24,
                        ),
                        title: const Text("B&B"),
                        textColor: AppColors.black,
                        titleTextStyle: AppStyles.s15w600,
                        subtitle: Text("St. Nukus $index"),
                        onTap: () {
                          // handle location tap
                          context.read<MapCubit>().selectAddress('St. Nukus $index');
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _SearchBarWithActions extends StatelessWidget {
  final BuildContext prevContext;

  const _SearchBarWithActions(this.prevContext);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.grayLight3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  Navigator.pop(ctx);
                  // clear input logic
                },
              ),
              Container(
                color: AppColors.grayLight6,
                width: 1.5,
                height: 24,
              ),
              TextButton(
                onPressed: () {
                  // show map logic
                  prevContext.read<MapCubit>().hideBottom();
                  Navigator.pop(ctx);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.black,
                ),
                child: Text(
                  "Map",
                  style: AppStyles.s15w600,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
