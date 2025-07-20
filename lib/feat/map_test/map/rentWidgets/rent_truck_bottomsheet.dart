import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart' hide Animation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/stage.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/utils/extension_utils/bounding_box.dart';
import 'package:katlavan24/core/utils/extension_utils/widget_extension.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/client_home/presentation/client_home_page.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
import 'package:katlavan24/feat/map_test/map/map_rent_truck.dart';
import 'package:katlavan24/feat/map_test/map/widgets/back_button.dart';
import 'package:katlavan24/feat/map_test/map/widgets/show_address_picking_modal.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' show Animation, AnimationType;

class RentTruckBottomSheet extends StatefulWidget {
  const RentTruckBottomSheet({super.key, required this.button});

  final Widget button;

  @override
  State<RentTruckBottomSheet> createState() => _RentTruckBottomSheetState();
}

class _RentTruckBottomSheetState extends State<RentTruckBottomSheet> {
  final focusNode = FocusNode();
  Timer? timer;
  bool started = false;
  bool used = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapRentCubit, MapRentState>(builder: (context, state) {
      return Column(
        children: [
          Align(alignment: Alignment.topRight, child: widget.button).checkCond(state.stage == Stage.initial),
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
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedCrossFade(
                          firstChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              OverlayAppBarRentTruck(
                                stage: state.stage,
                                numOfTrucks: state.trucks.length,
                              ),
                              Padding(
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
                                            context.read<MapRentCubit>().selectPickupAddress(list[index],
                                                point: mapWindowRentTruck.map
                                                    .cameraPositionForGeometry(list[index].geometry.first)
                                                    .target);

                                            context.read<MapRentCubit>().enableIgnore();
                                            mapWindowRentTruck.map.moveWithAnimation(
                                                mapWindowRentTruck.map
                                                    .cameraPositionForGeometry(list[index].geometry.first),
                                                Animation(AnimationType.Smooth, duration: 1));
                                            Future.delayed(Duration(seconds: 1), () {
                                              context.mounted
                                                  ? context.read<MapRentCubit>().disableIgnore()
                                                  : log('context unmounted');
                                            });
                                          });
                                        }, // Add your search navigation logic
                                        borderRadius: BorderRadius.circular(12),
                                        child: AddressContainer(
                                          label: 'Pick-up location',
                                          selectedAddress: state.selectedPickUp?.name,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          showAddressPicking(context, (list, index) {
                                            context.read<MapRentCubit>().selectDropOffAddress(list[index],
                                                point: list[index].boundingBox!.point);

                                            context.read<MapRentCubit>().enableIgnore();
                                            mapWindowRentTruck.map.moveWithAnimation(
                                                mapWindowRentTruck.map
                                                    .cameraPositionForGeometry(list[index].geometry.last),
                                                Animation(AnimationType.Smooth, duration: 1));
                                            Future.delayed(Duration(seconds: 1), () {
                                              context.mounted
                                                  ? context.read<MapRentCubit>().disableIgnore()
                                                  : log('context unmounted');
                                            });
                                          });
                                        }, // Add your search navigation logic
                                        borderRadius: BorderRadius.circular(12),
                                        child: AddressContainer(
                                          label: 'Drop-off location',
                                          selectedAddress: state.selectedDropOff?.name,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          secondChild: SizedBox(),
                          crossFadeState: state.stage.isInitial ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: Duration(milliseconds: 500)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: SizedBox(
                                  width: 90,
                                  child: SecondaryButton(
                                    'Back',
                                    onTap: () {
                                      context.read<MapRentCubit>().lowerStage();
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: AppColors.mainColorLight,
                                    textColor: AppColors.mainColor,
                                  ),
                                )).checkCondAnimatedSizeHorizontal(state.stage.isThird),
                            Expanded(
                              flex: 8,
                              child: PrimaryButton(
                                  switch ((state.stage)) {
                                    Stage.initial => 'Enter more details',
                                    Stage.selectedLocation => 'Next',
                                    Stage.third => 'Confirm',
                                    Stage.fourth => ' throw UnimplementedError()',
                                    Stage.fifth => 'throw UnimplementedError()',
                                    _ => '',
                                  },
                                  isEnabled: state.buttonEnabled.isEnabled, onTap: () {
                                context.read<MapRentCubit>().increaseStage();
                              }),
                            ),
                          ],
                        ),
                      ),
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

class SearchTrucks extends StatefulWidget {
  const SearchTrucks({super.key, required this.state});

  final MapRentState state;

  @override
  State<SearchTrucks> createState() => _SearchTrucksState();
}

class _SearchTrucksState extends State<SearchTrucks> {
  late StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    _stopWatchTimer = StopWatchTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapRentCubit, MapRentState>(
      listener: (context, state) {
        if ((state.stage.isFourth || state.stage.isFifth) & (!_stopWatchTimer.isRunning)) {
          _stopWatchTimer.onStartTimer();
        }
        if (!(state.stage.isFourth || state.stage.isFifth) & _stopWatchTimer.isRunning) {
          _stopWatchTimer.onResetTimer();
          _stopWatchTimer.onStopTimer();
        }
      },
      listenWhen: (prev, cur) => prev.stage != cur.stage,
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OverlayAppBarRentTruck(
                  stage: widget.state.stage,
                  numOfTrucks: widget.state.trucks.length,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      builder: (context, snapshot) {
                        final displayTime =
                            StopWatchTimer.getDisplayTime(snapshot.data ?? 0, milliSecond: false, hours: false);
                        return Text(
                          displayTime,
                          style: AppStyles.s15w600.copyWith(height: 20 / 15),
                        );
                      }),
                ).checkCondAnimatedOpacity(widget.state.stage<Stage.sixth)
              ],
            ),
            Divider(
              height: 16,
              color: AppColors.grayLight4,
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: AnimatedCrossFade(
                firstChild: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: SecondaryButton(
                          'Cancel',
                          onTap: () => context.read<MapRentCubit>().lowerStage(),
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
                secondChild: Column(
                  children: [
                    OrderDetail(
                        vehicleNumber: 'AB458',
                        color: AppColors.grayLight3,
                        name: 'Kamaz 12',
                        timeLeft: Duration(minutes: 5)),

                    OrderDetail(
                        vehicleNumber: 'AB458',
                        color: AppColors.grayLight3,
                        name: 'Kamaz 12',
                        timeLeft: Duration(minutes: 5)),
                  ],
                ),
                duration: Duration(milliseconds: 500),
                crossFadeState:
                    widget.state.stage > Stage.fifth ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverlayAppBarRentTruck extends StatelessWidget {
  const OverlayAppBarRentTruck({
    super.key,
    required this.stage,
    required this.numOfTrucks,
  });

  final Stage stage;
  final int numOfTrucks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          KatlavanRentBackButton(
            stage: stage,
          ),
          SizedBox(width: 12),
          Column(
            children: [
              Text(
                switch (stage) {
                  Stage.initial => 'Truck',
                  Stage.fourth => 'Searching trucks',
                  Stage.fifth => '3 trucks near you',
                  Stage.sixth => '3 trucks near you',
                  _ => 'throw UnimplementedError()',
                },
                style: AppStyles.s24w700.copyWith(fontSize: 20, height: 26 / 20),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('Looking for $numOfTrucks trucks'),
              ).checkCond(stage>=Stage.fifth)
            ],
          ),
        ],
      ),
    );
  }
}

class AddressContainer extends StatelessWidget {
  const AddressContainer({
    this.selectedAddress,
    super.key,
    required this.label,
  });

  final String label;
  final String? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.pin_drop_outlined, color: selectedAddress != null ? AppColors.mainColor : Colors.grey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              selectedAddress ?? label,
              style: AppStyles.s14.copyWith(
                  fontWeight: selectedAddress != null ? FontWeight.w600 : FontWeight.w500,
                  color: selectedAddress != null ? AppColors.black : AppColors.grayColor),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black),
        ],
      ),
    );
  }
}
