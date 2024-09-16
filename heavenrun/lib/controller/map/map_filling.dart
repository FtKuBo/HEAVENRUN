import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heavenrun/controller/map/marker.dart';
import 'package:heavenrun/controller/location/running_route.dart';
import 'package:heavenrun/controller/location/user_positon.dart';

class MapFilling {
  static void markerFillings(
      Map<MarkerId, Marker> markers, Future<UserPosition> userposition) async {
    UserPosition position = await userposition;

    LatLng endingPoint = LatLng(position.getUserLatitude() + 0.025,
        position.getUserLongitude() + 0.025);

    MarkerAdder.addMarker(endingPoint, "destination",
        BitmapDescriptor.defaultMarkerWithHue(90), markers);
  }

  static Future<Map<PolylineId, Polyline>> routeFilling(
      UserPosition userposition) async {
    return await RunningRoute.createRoute(userposition);
  }
}
