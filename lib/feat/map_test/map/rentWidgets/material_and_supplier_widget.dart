import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:katlavan24/core/enums/materials.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/custom_top_app_bar.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/location_row.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/rent_truck_choice_chip.dart' show RentTruckChoiceChip;
import 'package:katlavan24/feat/map_test/map/rentWidgets/wrapper_column.dart';
import 'package:katlavan24/feat/map_test/map/widgets/outlined_text_form_field.dart';
import 'package:katlavan24/feat/map_test/map/widgets/unit_dropdown.dart';
class MaterialAndSupplierWidget extends StatelessWidget {
  final MapRentState state;

  const MaterialAndSupplierWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTopAppBar(
          state.stage,
          selectedDropOff: state.selectedDropOff,
          selectedPickup: state.selectedPickUp,
          nextWidget: WrapperColumnContainer(
            children: [
              LocationRow(
                name: state.selectedPickUp?.name!,
                isFrom: true,
              ),
              LocationRow(
                name: state.selectedDropOff?.name!,
                isFrom: false,
              ),
            ],
          ),
        ),
        WrapperColumnContainer(children: [
          SizedBox(
            width: double.infinity,
          ),
          Text(
            'Material information',
            style: AppStyles.s16.copyWith(fontWeight: FontWeight.w700, height: 21 / 16),
          ),
          SizedBox(height: 12),
          Text(
            'Material type',
            style: AppStyles.s14.copyWith(color: AppColors.grayColor, height: 22 / 14),
          ),
          SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: Materials.values
                .map((e) => RentTruckChoiceChip(
              material: e,
              isSelected: e == state.selectedMaterial,
            ))
                .toList(),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: UnitDropDown(
                      selectedUnit: state.selectedUnit,
                      onChanged: (unit) {
                        context.read<MapRentCubit>().selectUnit(unit);
                      })),
              SizedBox(
                width: 12,
              ),
              Expanded(flex: 5, child: OutlinedTextFormField(controller: context.read<MapRentCubit>().volumeController, label: 'Volume')),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          OutlinedTextFormField(
            controller:  context.read<MapRentCubit>().descriptionController,
            label: 'Description',
            inputFormatters: [],
            textInputType: TextInputType.text,
          ),
        ]),
        WrapperColumnContainer(children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Round trip',
                  style: AppStyles.s16.copyWith(fontWeight: FontWeight.w700, color: AppColors.black, height: 21 / 16),
                ),
              ),
              FlutterSwitch(
                  padding: 2,
                  width: 28,
                  toggleSize: 12,
                  inactiveColor: AppColors.grayLight6,
                  height: 16,
                  activeColor: AppColors.mainColor,
                  value: state.roundTripEnabled,
                  onToggle: (val) {context.read<MapRentCubit>().changeRoundTrip(val);}),

            ],
          ),
          SizedBox(
            height: 12,
          ),
          OutlinedTextFormField(controller:  context.read<MapRentCubit>().roundTripController, label: 'How many round trips?'),
        ])
      ],
    );
  }
}
