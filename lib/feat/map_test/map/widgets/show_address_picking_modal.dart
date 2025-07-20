import 'dart:async';

import 'package:flutter/cupertino.dart' hide Animation;
import 'package:flutter/material.dart' hide Animation;
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/feat/map_test/map/map_buy_materials.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' show GeoObject, Geometry, Point;
import 'package:yandex_maps_mapkit/search.dart';

showAddressPicking(BuildContext context, Function(List<GeoObject> list, int index) onTap) {
  var list = <GeoObject>[];
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
          return StatefulBuilder(builder: (ctx, setState) {
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
                  _SearchBarWithActions(context, list, () {
                    setState(() {});
                  }),
                  const SizedBox(height: 12),
                  Expanded(
                    child: list.isEmpty
                        ? Align(
                            alignment: Alignment(0, -0.5),
                            child: Icon(
                              CupertinoIcons.search,
                              color: AppColors.grayLight4,
                              size: MediaQuery.of(context).size.width * 0.3,
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: list.length,
                            separatorBuilder: (_, __) => Divider(
                              indent: 56,
                              height: 8,
                              color: AppColors.grayLight4,
                            ),
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.only(left: 20, top: 0, bottom: 0),
                                leading: Image.asset(
                                  'assets/map/location.png',
                                  height: 24,
                                ),
                                title: Text(list[index].name ?? ''),
                                textColor: AppColors.black,
                                titleTextStyle: AppStyles.s15w600,
                                subtitle: Text(list[index].descriptionText ?? ''),
                                onTap: () {
                                  onTap(list, index);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          });
        },
      );
    },
  );
}

class _SearchBarWithActions extends StatefulWidget {
  final BuildContext prevContext;
  final List<GeoObject> list;
  final VoidCallback onChanged;

  const _SearchBarWithActions(this.prevContext, this.list, this.onChanged);

  @override
  State<_SearchBarWithActions> createState() => _SearchBarWithActionsState();
}

class _SearchBarWithActionsState extends State<_SearchBarWithActions> {
  Timer? timer;

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
          Expanded(
            child: TextField(
              focusNode: FocusNode()..requestFocus(),
              onChanged: (text) {
                timer?.cancel();
                timer = Timer(Duration(milliseconds: 400), () {
                  searchManager.submit(
                      Geometry.fromPoint(Point(latitude: 0, longitude: 0)),
                      SearchOptions(),
                      SearchSessionSearchListener(
                          onSearchResponse: (resp) {
                            widget.list.replaceRange(
                                0, widget.list.length, resp.collection.children.map((e) => e.asGeoObject()!));
                            widget.onChanged();
                          },
                          onSearchError: (err) {}),
                      text: text);
                });
              },
              decoration: const InputDecoration(
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
