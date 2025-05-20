// lib/screens/map_screen.dart
import 'package:flutter/material.dart'hide BackButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/services/map_service.dart';
import 'package:katlavan24/feat/map/data/models/merchant.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/buttons/back_button.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/buttons/current_location_button.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/buttons/tune_button.dart';
import 'package:katlavan24/feat/map/map_screen/widgets/locations_row/locations_view.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';
import 'bloc/event.dart';
import 'bloc/map_bloc.dart';
import 'bloc/state.dart';
import 'flutter_map_widget.dart';

class MapScreen extends StatelessWidget {


  const MapScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(MapService(), []),
      child: MapView(merchants: []),
    );
  }
}

class MapView extends StatelessWidget {
  final List<Merchant> merchants;

  const MapView({super.key, required this.merchants});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                BlocBuilder<MapBloc, MapState>(
                  builder: (context,state) {
                    return FlutterMapWidget(

                      onMapCreated: (controller) async {


                      },
                    );
                  }
                ),
                BackButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const TuneButton(),
                const CurrentLocationButton(),
                LocationsRow(merchants: merchants),
              ],
            ),
          ),
        );
      },
    );
  }
}
