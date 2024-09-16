import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heavenrun/controller/location/get_location.dart';
import 'package:heavenrun/controller/location/user_positon.dart';
import 'package:heavenrun/controller/map/map_filling.dart';
import 'package:heavenrun/main.dart';

class MapPageManager {
  MapPageManager();

  Future<UserPosition> getUserPosition() async {
    return UserPosition.init(await ActualPostion.determinePosition());
  }

  void updateRouteStream() async {
    if (MapScreen.targetDistance <= 0) {
      MapScreen.updateDistance.add(new Map<PolylineId, Polyline>());
    } else {
      MapScreen.updateDistance
          .add(await MapFilling.routeFilling(MapScreen.userposition));
    }
  }

  StreamController<Map<PolylineId, Polyline>> FillRouteStream() {
    late StreamController<Map<PolylineId, Polyline>> controller;
    Map<PolylineId, Polyline> polyline = {};

    void generateRoute() async {
      if (MapScreen.targetDistance <= 0) {
        polyline = {};
      } else {
        polyline = await MapFilling.routeFilling(MapScreen.userposition);
      }
      controller.add(polyline);
    }

    void removeRoute() {
      polyline = {};
      controller.add(polyline);
    }

    controller = StreamController<Map<PolylineId, Polyline>>(
        onListen: generateRoute, onCancel: removeRoute);

    return controller;
  }

  void fillMarkers(
      Map<MarkerId, Marker> markers, Future<UserPosition> userposition) {
    MapFilling.markerFillings(markers, userposition);
  }

  LatLng toLatLng(UserPosition userposition) {
    return LatLng(
        userposition.getUserLatitude(), userposition.getUserLongitude());
  }

  Map<PolylineId, Polyline> getPolylinesFromSnap(AsyncSnapshot snapshot) {
    try {
      return Map<PolylineId, Polyline>.from(snapshot.data);
    } on Error catch (e) {
      print("This error occured : $e");
      return {};
    }
  }

  Placeholder handleRunningRouteError(AsyncSnapshot snapshot) {
    print("----------------------");
    print("Error in generating the running route");
    print(snapshot.error);
    print("----------------------");
    return Placeholder();
  }
}
