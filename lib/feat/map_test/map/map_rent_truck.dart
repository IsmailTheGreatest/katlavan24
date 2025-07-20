import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katlavan24/core/enums/stage.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/utils/extension_utils/bounding_box.dart';
import 'package:katlavan24/core/utils/extension_utils/is_null.dart';
import 'package:katlavan24/core/utils/extension_utils/widget_extension.dart';
import 'package:katlavan24/feat/flutter_map_widget.dart';
import 'package:katlavan24/feat/map_test/cubit/map_rent_cubit.dart';
import 'package:katlavan24/feat/map_test/map/camera/camera_manager.dart';
import 'package:katlavan24/feat/map_test/map/dialogs/dialogs_factory.dart';
import 'package:katlavan24/feat/map_test/map/listeners/tap_listener_rent_truck.dart';
import 'package:katlavan24/feat/map_test/map/permissions/permission_manager.dart'
    show PermissionManager, PermissionType;
import 'package:katlavan24/feat/map_test/map/rentWidgets/map_rent_app_bar.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/material_and_supplier_widget.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/rent_truck_bottomsheet.dart';
import 'package:katlavan24/feat/map_test/map/rentWidgets/truck_selection_overlay.dart';
import 'package:katlavan24/feat/map_test/map/widgets/map_control_button.dart';
import 'package:yandex_maps_mapkit/image.dart' as image_provider;
import 'package:yandex_maps_mapkit/mapkit.dart' hide Image, Rect;
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/search.dart' hide Size;

final searchManager = SearchFactory.instance.createSearchManager(SearchManagerType.Combined);
late CameraManager cameraManager;
late MapWindow mapWindowRentTruck;

class MapRentTruck extends StatefulWidget {
  const MapRentTruck({super.key});

  @override
  State<MapRentTruck> createState() => _MapRentTruckState();
}

class _MapRentTruckState extends State<MapRentTruck> {
  late final _dialogsFactory = DialogsFactory(_showDialog);
  late final _permissionManager = PermissionManager(_dialogsFactory);
  late final _locationManager = mapkit.createLocationManager();
  MapObject? selectedObject;
  Timer? _debounce;
  PlacemarkMapObject? selectedPickUpPlacemark;
  PlacemarkMapObject? selectedDropOffPlacemark;
  SearchSession? _searchSession;
  late final AppLifecycleListener _lifecycleListener;
  late final MapInputListener _tapListener;
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
      create: (_) => MapRentCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<MapRentCubit>();
        return BlocConsumer<MapRentCubit, MapRentState>(
            listener: (context, state) {
              if (state.selectedPickUpPoint.isNotNull) {
                if (selectedPickUpPlacemark.isNotNull) {
                  mapWindowRentTruck.map.mapObjects.remove(selectedPickUpPlacemark!);
                }
                selectedPickUpPlacemark =
                    selectedPickUpPlacemark.putPlacemark(state.selectedPickUpPoint!, 'assets/map/Pin.png');
              }
              if (state.selectedDropOffPoint.isNotNull) {
                if (selectedDropOffPlacemark.isNotNull) {
                  mapWindowRentTruck.map.mapObjects.remove(selectedDropOffPlacemark!);
                }
                selectedDropOffPlacemark =
                    selectedDropOffPlacemark.putPlacemark(state.selectedDropOffPoint!, 'assets/map/Pin.png');
              }
            },
            listenWhen: (prev, cur) =>
                ((prev.selectedDropOff != cur.selectedDropOff) || (prev.selectedPickUp != cur.selectedPickUp)) &&
                (!cur.isTappingOnMap),
            builder: (context, state) {

              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (popped, res) {
                  if (popped) {
                    return;
                  }
                  if (state.stage.isInitial) {
                    Navigator.pop(context);
                    return;
                  }
                  context.read<MapRentCubit>().lowerStage();
                },
                child: SafeArea(
                  top: false,
                  child: Scaffold(
                    body: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FlutterMapWidget(
                            onMapCreated: (mapWindow) {
                              mapWindowRentTruck = mapWindow;
                              cameraManager = CameraManager(mapWindowRentTruck, _locationManager);
                              _tapListener = TapListener<MapRentCubit, MapRentState>(context, (map, point, state) {
                                cubit.setLoading();
                                if (state.selectedPickUp.isNull) {
                                  selectedPickUpPlacemark.isNotNull
                                      ? map.mapObjects.remove(selectedPickUpPlacemark!)
                                      : null;

                                  selectedPickUpPlacemark =
                                      selectedPickUpPlacemark.putPlacemark(point, 'assets/map/Pin.png');
                                } else {
                                  selectedDropOffPlacemark.isNotNull
                                      ? map.mapObjects.remove(selectedDropOffPlacemark!)
                                      : null;
                                  selectedDropOffPlacemark =
                                      selectedDropOffPlacemark.putPlacemark(point, 'assets/map/Pin.png');
                                }
                                _searchSession?.cancel();
                                _searchSession = searchManager.submitPoint(
                                    point,
                                    SearchOptions(resultPageSize: 1),
                                    SearchSessionSearchListener(onSearchResponse: (SearchResponse response) {
                                      final ff = response.collection.children.first.asGeoObject();
                                      final point = ff!.geometry.first.asPoint() ?? ff.boundingBox!.point;
                                      if (state.selectedPickUp.isNotNull) {
                                        ff.isNotNull
                                            ? cubit.selectDropOffAddress(ff, isTapping: true, point: point)
                                            : log('null');
                                      } else {
                                        cubit.selectPickupAddress(ff, isTapping: true, point: point);
                                      }
                                      cubit.setInit();
                                    }, onSearchError: (error) {
                                      cubit.setInit();
                                      throw Error.throwWithStackTrace(error, StackTrace.current);
                                    }));
                              });
                              mapWindowRentTruck.map.addInputListener(_tapListener);
                              cameraManager.cameraPosition.listen((event) {
                                // Cancel previous timer if still active
                                _debounce?.cancel();
                                !state.hideBottom && context.mounted ? cubit.hideBottom() : null;
                                // Start a new debounce timer
                                _debounce = Timer(const Duration(milliseconds: 100), () {
                                  cubit.showBottom();
                                });
                              });
                              cameraManager.start();
                            },
                            onMapDispose: () {
                              cameraManager.dispose();
                            },
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            left: 0.0,
                            child: MapRentAppBar(
                              selectedAddressStatus: state.selectedAddressStatus,
                              selectedAddress: state.selectedPickUp,
                            ).checkCond(!state.stage.isFourth),
                          ),
                          IgnorePointer(
                            ignoring: !(state.stage > Stage.initial || state.tapIgnore),
                            child: Container(
                              color: Colors.black45,
                            ),
                          ).checkCondAnimatedOpacity(state.stage > Stage.initial),
                          MaterialAndSupplierWidget(state: state).checkCondAnimatedSlideThree(
                              state.stage.index, Stage.selectedLocation.index,
                              customExitOffset: Offset(-1.5, 0)),
                          TruckSelectionOverlay(state: state).checkCondAnimatedSlideThree(
                              state.stage.index, Stage.third.index,
                              customOffset: Offset(1.5, 0), customExitOffset: Offset(-1.5, 0)),
                          SafeArea(
                            bottom: false,
                            child: RentTruckBottomSheet(
                              button: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MapControlButton(
                                  icon: Icons.my_location_outlined,
                                  backgroundColor: AppColors.mainColor,
                                  onPressed: () {
                                    cameraManager.moveCameraToUserLocation();
                                  },
                                ),
                              ),
                            ),
                          ).checkCondAnimatedPositionedLeft(
                              state.stage <= Stage.third, MediaQuery.of(context).size.width),
                          SafeArea(
                            bottom: false,
                            child:SearchTrucks(state: state)
                            ,
                          ).checkCondAnimatedPositionedBottom(
                              state.stage > Stage.third, MediaQuery.of(context).size.height/2),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

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

extension on PlacemarkMapObject? {
  PlacemarkMapObject putPlacemark(Point point, String imgUrl) {
    return mapWindowRentTruck.map.mapObjects.addPlacemark()
      ..geometry = point
      ..setIcon(image_provider.ImageProvider.fromImageProvider(const AssetImage('assets/map/Pin.png')))
      ..setIconStyle(IconStyle(scale: 1, anchor: math.Point<double>(0.5, 1)));
  }
}
