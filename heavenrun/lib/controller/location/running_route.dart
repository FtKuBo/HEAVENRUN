import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heavenrun/controller/location/user_positon.dart';
import 'package:heavenrun/controller/shared/constants.dart';

class RunningRoute {
  static Future<Map<PolylineId, Polyline>> createRoute(
      UserPosition userposition) async {
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    // to change when implementing the spring API
    LatLng endingPoint = LatLng(userposition.getUserLatitude() + 0.025,
        userposition.getUserLongitude() + 0.025);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(
            userposition.getUserLatitude(), userposition.getUserLongitude()),
        destination: PointLatLng(endingPoint.latitude, endingPoint.longitude),
        mode: TravelMode.walking,
      ),
    );

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
      return Future.error('Error in charging the route!');
    }

    addPolyLine(polylines, polylineCoordinates);
    return polylines;
  }

  static void addPolyLine(
      Map<PolylineId, Polyline> polylines, List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
  }
}
