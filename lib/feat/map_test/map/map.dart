import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/feat/flutter_map_widget.dart';
import 'package:katlavan24/feat/map_test/cubit/map_cubit.dart';
import 'package:katlavan24/feat/map_test/map/camera/camera_manager.dart';
import 'package:katlavan24/feat/map_test/map/dialogs/dialogs_factory.dart';
import 'package:katlavan24/feat/map_test/map/permissions/permission_manager.dart'
    show PermissionManager, PermissionType;
import 'package:katlavan24/feat/map_test/map/widgets/map_app_bar.dart';
import 'package:katlavan24/feat/map_test/map/widgets/map_control_button.dart';
import 'package:katlavan24/feat/map_test/map/widgets/modal_bottom_sheets.dart';

import 'package:yandex_maps_mapkit/image.dart' as image_provider;
import 'package:yandex_maps_mapkit/mapkit.dart' hide Image;
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/search.dart';

class MapkitFlutterApp extends StatefulWidget {
  const MapkitFlutterApp({super.key});

  @override
  State<MapkitFlutterApp> createState() => _MapkitFlutterAppState();
}

class _MapkitFlutterAppState extends State<MapkitFlutterApp> implements UserLocationObjectListener {
  late final _dialogsFactory = DialogsFactory(_showDialog);
  late final _searchManager = SearchFactory.instance.createSearchManager(SearchManagerType.Combined);
  late final _permissionManager = PermissionManager(_dialogsFactory);
  late final _locationManager = mapkit.createLocationManager();
  MapObject? selectedObject;
  Timer? _debounce;
  late final CameraManager _cameraManager;
  late final UserLocationLayer _userLocationLayer;
  late final AppLifecycleListener _lifecycleListener;
  late final MapWindow _mapWindow;

  late final arrowIconImageProvider =
      image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/map/location.png"));
  late final iconImageProvider = image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/map/Pin.png"));
  final pinIconImageProvider = image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/map/Pin.png"));

  @override
  void initState() {
    super.initState();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        _requestPermissionsIfNeeded();
      },
    );

    _requestPermissionsIfNeeded();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<MapCubit>();
        return SafeArea(
          top: false,
          child: Scaffold(
            body: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FlutterMapWidget(
                    onMapCreated: (mapWindow) {
                      _mapWindow = mapWindow;
                      _cameraManager = CameraManager(_mapWindow, _locationManager);

                      _cameraManager.cameraPosition.listen((event) {
                        // Cancel previous timer if still active
                        cubit.setInit();
                        _debounce?.cancel();

                        // Start a new debounce timer
                        _debounce = Timer(const Duration(milliseconds: 250), () {
                          context.mounted ? cubit.setLoading() : null;
                          _searchManager.submitPoint(
                            event.target,
                            zoom: event.zoom.toInt(),
                            SearchOptions(resultPageSize: 1, userPosition: event.target, searchTypes: SearchType.Geo),
                            SearchSessionSearchListener(
                              onSearchResponse: (SearchResponse response) {
                                cubit.selectAddress(response.collection.children.firstOrNull?.asGeoObject()?.name ?? 'None');
                                cubit.setInit();
                              },
                              onSearchError: (_) {cubit.setInit();},
                            ),
                          );
                        });
                      });
                      _cameraManager.start();
                    },
                    onMapDispose: () {
                      _cameraManager.dispose();
                    },
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Center(
                          child: Image.asset(
                        'assets/map/Pin.png',
                        width: 48,
                        height: 48,
                      ))),

                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: MapAppBar(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0.0,
                    left: 0,
                    child: SafeArea(
                      bottom: false,
                      child: IntroBottomSheet(button: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MapControlButton(
                          icon: Icons.my_location_outlined,
                          backgroundColor: AppColors.mainColor,
                          onPressed: () {
                            _cameraManager.moveCameraToUserLocation();
                          },
                        ),
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void onObjectAdded(UserLocationView userLocationView) {
    _userLocationLayer.setAnchor(
      math.Point(_mapWindow.width() * 0.5, _mapWindow.height() * 0.5),
      math.Point(_mapWindow.width() * 0.5, _mapWindow.height() * 0.5),
    );

    userLocationView.arrow.setIcon(iconImageProvider);

    userLocationView.accuracyCircle.fillColor = Colors.blue.withAlpha(100);
  }

  @override
  void onObjectRemoved(UserLocationView view) {}

  @override
  void onObjectUpdated(UserLocationView view, ObjectEvent event) {}

  void _showDialog(
    String descriptionText,
    ButtonTextsWithActions buttonTextsWithActions,
  ) {
    final actionButtons = buttonTextsWithActions.map((button) {
      return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          button.$2();
        },
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.secondary,
          textStyle: Theme.of(context).textTheme.labelMedium,
        ),
        child: Text(button.$1),
      );
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(descriptionText),
          contentTextStyle: Theme.of(context).textTheme.labelLarge,
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: actionButtons,
        );
      },
    );
  }

  void _requestPermissionsIfNeeded() {
    final permissions = [PermissionType.accessLocation];
    _permissionManager.tryToRequest(permissions);
    _permissionManager.showRequestDialog(permissions);
  }
}
