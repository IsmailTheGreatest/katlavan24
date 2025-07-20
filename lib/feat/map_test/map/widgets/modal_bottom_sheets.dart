import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart' hide Animation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/materials.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/extension_utils/num_extension.dart';
import 'package:katlavan24/core/utils/extension_utils/widget_extension.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/map_test/cubit/map_cubit.dart';
import 'package:katlavan24/feat/map_test/map/map_buy_materials.dart';
import 'package:katlavan24/feat/map_test/map/widgets/back_button.dart';
import 'package:katlavan24/feat/map_test/map/widgets/outlined_text_form_field.dart';
import 'package:katlavan24/feat/map_test/map/widgets/show_address_picking_modal.dart';
import 'package:katlavan24/feat/map_test/map/widgets/truck_cont.dart' show TruckCont;
import 'package:katlavan24/feat/map_test/map/widgets/unit_dropdown.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' show Animation, AnimationType;

class IntroBottomSheet extends StatefulWidget {
  const IntroBottomSheet({super.key, required this.button});

  final Widget button;

  @override
  State<IntroBottomSheet> createState() => _IntroBottomSheetState();
}

class _IntroBottomSheetState extends State<IntroBottomSheet> {
  final focusNode = FocusNode();
  late Stopwatch stopwatch;
  Timer? timer;
  bool started = false;
  bool used = false;

  @override
  void initState() {
    stopwatch = Stopwatch();
    super.initState();
  }

  @override
  void dispose() {
    stopwatch.reset();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      !state.stage.isFourth ? {timer?.cancel(), stopwatch.reset()} : null;
      return Column(
        children: [
          Align(alignment: Alignment.topRight, child: widget.button).checkCond(!state.stage.isFourth),
          AnimatedSize(
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 500),
            child: ConstrainedBox(
              constraints: state.hideBottom ? BoxConstraints(maxHeight: 0) : BoxConstraints(),
              child: GestureDetector(
                onTap: () => focusNode.unfocus(),
                child: Container(
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
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    top: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            KatlavanBackButton(
                              stage: state.stage,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    switch (state.stage) {
                                      Stage.initial => 'Choose where your materials will be delivered.',
                                      Stage.selectedLocation => 'Enter materials types',
                                      Stage.third => 'Select Trucks Tariff',
                                      Stage.fourth => 'Searching materials and truck',
                                      Stage.fifth => 'Found a factory',
                                    },
                                    style: AppStyles.s24w700.copyWith(fontSize: 20, height: 26 / 20),
                                  ),
                                  Text(
                                    'Looking for two trucks',
                                    style: AppStyles.s15w600.copyWith(color: AppColors.grayColor),
                                  ).checkCond(state.stage.isFifth),
                                ],
                              ),
                            ),
                            StatefulBuilder(builder: (context, setState) {
                              if (state.stage == Stage.fourth && !started) {
                                timer = Timer.periodic(Duration(seconds: 1), (_) {
                                  if (stopwatch.elapsed.inSeconds > 20 && !used) {
                                    context.read<MapCubit>().goFifth();
                                    used = true;
                                  }
                                  if (stopwatch.isRunning && mounted) {
                                    setState(() {});
                                  }
                                });
                                started = true;
                                !stopwatch.isRunning ? stopwatch.start() : null;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  '${stopwatch.elapsed.inMinutes.pad}:${stopwatch.elapsed.inSeconds.remainder(60).pad}',
                                  style: AppStyles.s15w600,
                                ),
                              ).checkCond(state.stage >= Stage.fourth);
                            })
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                          firstChild: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 24),
                                Material(
                                  child: InkWell(
                                    onTap: () {
                                      showAddressPicking(context, (list, index) {
                                        // handle location tap
                                        context.read<MapCubit>().selectAddress(list[index].name ?? 'None');
                                        context.read<MapCubit>().enableIgnore();
                                        mapWindowGlobal.map.moveWithAnimation(
                                            mapWindowGlobal.map.cameraPositionForGeometry(list[index].geometry.last),
                                            Animation(AnimationType.Smooth, duration: 1));
                                        Future.delayed(Duration(seconds: 1), () {
                                          context.mounted
                                              ? context.read<MapCubit>().disableIgnore()
                                              : log('context unmounted');
                                        });
                                      });
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
                                                  fontWeight:
                                                      state.selectedAddress != null ? FontWeight.w600 : FontWeight.w500,
                                                  color: state.selectedAddress != null
                                                      ? AppColors.black
                                                      : AppColors.grayColor),
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
                                  crossFadeState: state.stage == Stage.initial
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: PrimaryButton('Enter material details',
                                        isEnabled: state.selectedAddress != null, onTap: () {
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
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8), color: AppColors.grayLight4),
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
                                            child: UnitDropDown(
                                              selectedUnit: state.selectedUnit,
                                              onChanged: (unit) {
                                                context.read<MapCubit>().selectUnit(unit);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: OutlinedTextFormField(
                                              focusNode: focusNode,
                                              label: 'Volume',
                                              controller: context.read<MapCubit>().volumeController,
                                            ),
                                          )
                                        ],
                                      ),
                                      AnimatedContainer(
                                        curve: Curves.easeInOutCubic,
                                        duration: Duration(milliseconds: 600),
                                        height: state.stage.isThird ? null : 0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 24),
                                          child: SizedBox(
                                            height: (MediaQuery.of(context).size.width - 32) / Truck.values.length,
                                            child: Stack(
                                              children: [
                                                AnimatedPositioned(
                                                    bottom: 0,
                                                    top: 0,
                                                    curve: Curves.easeIn,
                                                    left: ((MediaQuery.of(context).size.width - 32) /
                                                            Truck.values.length) *
                                                        state.selectedTruck.index,
                                                    duration: Duration(milliseconds: 300),
                                                    child: Container(
                                                      decoration: ShapeDecoration(
                                                          color: AppColors.grayLight4,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          )),
                                                      width: (MediaQuery.of(context).size.width - 32) /
                                                          Truck.values.length,
                                                    )),
                                                Row(
                                                    children: Truck.values
                                                        .map((e) => Expanded(child: TruckCont(truck: e)))
                                                        .toList()),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      PrimaryButtonAlt(
                                        'Search',
                                        onTap: () {
                                          context.read<MapCubit>().goFourth();
                                        },
                                        isEnabled: state.stage.isThird,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          secondChild: Column(
                            children: [
                              Divider(
                                height: 16,
                                color: AppColors.grayLight4,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: SecondaryButton(
                                          'Cancel',
                                          onTap: () => context.read<MapCubit>().checkThirdStage(),
                                          localImagePath: 'assets/map/cancel.png',
                                        )),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                            child: SecondaryButton(
                                          'Details',
                                          localImagePath: 'assets/map/note.png',
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          crossFadeState: state.stage.isFourth || state.stage.isFifth
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
