import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerAdder {
  static addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      Map<MarkerId, Marker> markers) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}
