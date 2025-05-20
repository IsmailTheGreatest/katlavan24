import 'package:flutter/material.dart';
import 'package:katlavan24/feat/map/map_screen/flutter_map_widget.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';


class MapkitFlutterApp extends StatefulWidget {


  const MapkitFlutterApp({super.key,});

  @override
  State<MapkitFlutterApp> createState() => _MapkitFlutterAppState();
}

class _MapkitFlutterAppState extends State<MapkitFlutterApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FlutterMapWidget(onMapCreated: (ff){}),
          ],
        ),
      ),
    );
  }

  void _setupMap() {
    // you can create your own style here https://yandex.com/maps-api/map-style-editor
   // mapWindow.map.setMapStyle(widget.mapStyleJson);
  }
}
