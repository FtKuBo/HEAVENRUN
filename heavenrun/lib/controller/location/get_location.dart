import 'dart:async';
import 'package:geolocator/geolocator.dart';

class ActualPostion {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // check if location services are available in the user's device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled in this device!');
    }
    // check if user gave permissions to the app to access its location
    permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied!');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied forever!');
    }

    print(permission);
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );
    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
    ;
  }
}


    // // print the location of the user each time he moves of 10 m
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position? position) {
    //   print(position == null
    //       ? 'Unknown'
    //       : '${position.latitude.toString()}, ${position.longitude.toString()}');
    // });

    // // print the status of the permission to access location each time it changes
    // StreamSubscription<ServiceStatus> serviceStatusStream =
    //     Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    //   print(status);
    // });