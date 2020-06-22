// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_example/main.dart';

import 'page.dart';

class PlaceFillPage extends ExamplePage {
  PlaceFillPage() : super(const Icon(Icons.check_circle), 'Place fill');

  @override
  Widget build(BuildContext context) {
    return const PlaceFillBody();
  }
}

class PlaceFillBody extends StatefulWidget {
  const PlaceFillBody();

  @override
  State<StatefulWidget> createState() => PlaceFillBodyState();
}

class PlaceFillBodyState extends State<PlaceFillBody> {
  PlaceFillBodyState();

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  MapboxMapController controller;
  int _fillCount = 0;
  Fill _selectedFill;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onFillTapped.add(_onFillTapped);
  }

  @override
  void dispose() {
    controller?.onFillTapped?.remove(_onFillTapped);
    super.dispose();
  }

  void _onFillTapped(Fill fill) {
    // if (_selectedFill != null) {
    //   _updateSelectedFill(
    //     const FillOptions(fillRadius: 60),
    //   );
    // }
    print("Fill: ${fill.id}");
    setState(() {
      _selectedFill = fill;
    });
    // _updateSelectedFill(
    //   FillOptions(
    //     fillRadius: 30,
    //   ),
    // );
  }

  void _updateSelectedFill(FillOptions changes) {
    controller.updateFill(_selectedFill, changes);
  }

  void _add() {
    controller.addFill(
      FillOptions(
          geometry: [
            LatLng(-32.86711, 152.1947171),
            LatLng(-33.86711, 151.1947171),
            LatLng(-32.86711, 151.1947171),
            LatLng(-33.86711, 152.1947171),
          ],
          fillColor: "#FF0000",
          fillOutlineColor: "#FF0000"),
    );
    setState(() {
      _fillCount += 1;
    });
  }

  void _remove() {
    controller.removeFill(_selectedFill);
    setState(() {
      _selectedFill = null;
      _fillCount -= 1;
    });
  }

  void _changePosition() {
    // final LatLng current = _selectedFill.options.geometry;
    // final Offset offset = Offset(
    //   center.latitude - current.latitude,
    //   center.longitude - current.longitude,
    // );
    // _updateSelectedFill(
    //   FillOptions(
    //     geometry: LatLng(
    //       center.latitude + offset.dy,
    //       center.longitude + offset.dx,
    //     ),
    //   ),
    // );
  }

  void _changeDraggable() {
    bool draggable = _selectedFill.options.draggable;
    if (draggable == null) {
      // default value
      draggable = false;
    }
    _updateSelectedFill(
      FillOptions(
        draggable: !draggable,
      ),
    );
  }

  Future<void> _changeFillOpacity() async {
    double current = _selectedFill.options.fillOpacity;
    if (current == null) {
      // default value
      current = 1.0;
    }

    _updateSelectedFill(
      FillOptions(fillOpacity: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _changeFillColor() async {
    String current = _selectedFill.options.fillColor;
    if (current == null) {
      // default value
      current = "#FF0000";
    }

    _updateSelectedFill(
      FillOptions(
        fillColor: "#FFFF00"),
    );
  }

  Future<void> _changeFillOutlineColor() async {
    String current = _selectedFill.options.fillOutlineColor;
    if (current == null) {
      // default value
      current = "#FF0000";
    }

    _updateSelectedFill(
      FillOptions(
        fillOutlineColor: "#FFFF00"),
    );
  }

  void _notImplemented(item) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('$item not yet implemented')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: MapboxMap(
              accessToken: MapsDemo.ACCESS_TOKEN,
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-33.852, 151.211),
                zoom: 7.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: (_fillCount == 12) ? null : _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed: (_selectedFill == null) ? null : _remove,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change fill-opacity'),
                          onPressed:
                              (_selectedFill == null) ? null : _changeFillOpacity,
                        ),
                        FlatButton(
                          child: const Text('change fill-color'),
                          onPressed:
                          (_selectedFill == null) ? null : _changeFillColor,
                        ),
                        FlatButton(
                          child: const Text('change fill-outline-color'),
                          onPressed:
                          (_selectedFill == null) ? null : _changeFillOutlineColor,
                        ),
                        FlatButton(
                          child: const Text('change fill-pattern'),
                          onPressed: 
                              (_selectedFill == null) ? null : () => _notImplemented('fill-pattern'),
                        ),
                        FlatButton(
                          child: const Text('change position'),
                          onPressed: (_selectedFill == null)
                              ? null
                              : _changePosition,
                        ),
                        FlatButton(
                          child: const Text('toggle draggable'),
                          onPressed: (_selectedFill == null)
                              ? null
                              : _changeDraggable,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}