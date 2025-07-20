import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/core/widgets/buttons.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/custom_top_app_bar.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/rent_truck_choice_chip.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/wrapper_column.dart';

class TruckSelectionOverlay extends StatelessWidget {
  final MapRentState state;

  const TruckSelectionOverlay({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTopAppBar(
              state.stage,
              selectedDropOff: state.selectedDropOff,
              selectedPickup: state.selectedPickUp,
              nextWidget: TruckContainerRentTruck(
                onRemove: () {},
                count: 0,
                truck: state.trucks.first,
                isFirst: true,
                //  width: MediaQuery.of(context).size.width - 32,
                onChanged: (truck) {
                  context.read<MapRentCubit>().replaceTruck(0, truck);
                },
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return TruckContainerRentTruck(
                    onRemove: () {
                      context.read<MapRentCubit>().removeTruck(index + 1);
                    },
                    count: index + 2,
                    truck: state.trucks[index + 1],
                    onChanged: (truck) {
                      context.read<MapRentCubit>().replaceTruck(index + 1, truck);
                    });
              },
              itemCount: state.trucks.length - 1,
              shrinkWrap: true,
            ),
            WrapperColumnContainer(children: [
              SecondaryButton(
                'Add truck',
                localImagePath: 'assets/map/plus.png',
                onTap: () {
                  context.read<MapRentCubit>().addTruck();
                },
              )
            ]),
            WrapperColumnContainer(children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                'Price',
                style: AppStyles.s16w700.copyWith(height: 21 / 16),
              ),
              SizedBox(
                height: 6,
              ),
              for (var truck in (state.trucks))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${truck.name.capitalizeFirst} truck | Round trip: ${context.read<MapRentCubit>().roundTripController.text} = 350,000 so\'m',
                    style: AppStyles.s14w500.copyWith(color: AppColors.grayColor, height: 18 / 14),
                  ),
                ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Total Price',
                style: AppStyles.s16w700.copyWith(height: 21 / 16),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                '${state.trucks.length * 350000} so\'m',
                style: AppStyles.s24w700.copyWith(height: 31 / 24),
              ),
              Divider(
                height: 24,
                color: AppColors.grayLight4,
              ),
              Text(
                'Card Information',
                style: AppStyles.s16w700.copyWith(height: 21 / 16),
              ),
              SizedBox(
                height: 12,
              ),
              ...Payment.values.map<Widget>((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ChoiceField(
                        isSelected: e == state.selectedPayment,
                        payment: e,
                        onTap: () {
                          context.read<MapRentCubit>().selectPayment(e);
                        }),
                  ))
            ]),
            SizedBox(
              height: 400,
            )
          ],
        ),
      ),
    );
  }
}

class ChoiceField extends StatelessWidget {
  const ChoiceField({super.key, required this.isSelected, required this.payment, required this.onTap});

  final Payment payment;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.grayLight6,
        splashFactory: InkSplash.splashFactory,
        hoverColor: Colors.white70,
        highlightColor: Colors.white70,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? AppColors.mainColor : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
            color: isSelected ? Colors.white : AppColors.grayLight3,
          ),
          child: Row(
            children: [
              SizedBox(width: 4),
              CustomRadioButton(
                isSelected: isSelected,
                innerPadding: EdgeInsets.all(3),
                size: 16,
                disabledColor: Color(0xffADAAAA),
              ),
              SizedBox(width: 12),
              Text(payment.name.capitalizeFirst, style: AppStyles.s14.copyWith(height: 24 / 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class TruckContainerRentTruck extends StatelessWidget {
  final TruckRent truck;
  final Function(TruckRent newTruck) onChanged;
  final bool isFirst;
  final int count;
  final VoidCallback onRemove;

  const TruckContainerRentTruck(
      {super.key,
      required this.truck,
      required this.onChanged,
      this.isFirst = false,
      required this.count,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return WrapperColumnContainer(children: [
      isFirst
          ? SizedBox()
          : Column(children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Truck $count',
                    style: AppStyles.s16w700,
                  )),
                  SizedBox(
                      width: 80,
                      height: 40,
                      child: SecondaryButton(
                        'Remove',
                        fontSize: 14,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        onTap: onRemove,
                      ))
                ],
              ),
              Divider(
                color: AppColors.grayLight4,
                height: 32,
              ),
            ]),
      Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${truck.name.capitalizeFirst} Truck: ${truck.modelName}',
                    style: AppStyles.s16w700.copyWith(height: 21 / 16)),
                SizedBox(
                  height: 4,
                ),
                Text('Capacity: ${truck.capacity}',
                    style: AppStyles.s14w500.copyWith(color: AppColors.grayColor, height: 18 / 14)),
              ],
            ),
          ),
          SizedBox(
              width: 103,
              height: 40,
              child: SecondaryButton(
                'Details',
                localImagePath: 'assets/map/info.png',
                onTap: () {},
                iconSize: 24,
                fontSize: 14,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              )),
        ],
      ),
      SizedBox(
        height: 16,
      ),
      SizedBox(
        child: Image.asset(
          truck.urlImage,
        ),
      ),
      SizedBox(
        height: 16,
      ),
      CustomSlidingSegmentedControl<TruckRent>(
          isStretch: true,
          customSegmentSettings: CustomSegmentSettings(
            radius: 12,
            borderRadius: BorderRadius.circular(12),
          ),
          initialValue: truck,
          thumbDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          innerPadding: EdgeInsets.all(4),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(12)),
          children: {
            TruckRent.small: Text(
              'Small',
              style: AppStyles.s14w700,
            ),
            TruckRent.big: Text(
              'Big',
              style: AppStyles.s14w700,
            ),
          },
          onValueChanged: (truck) {
            onChanged(truck);
          })
    ]);
  }
}

extension on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
