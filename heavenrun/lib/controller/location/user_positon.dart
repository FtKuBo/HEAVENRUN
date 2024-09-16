import 'package:geolocator/geolocator.dart';

class UserPosition {
  late double userLatitude;
  late double userLongitude;

  UserPosition({this.userLatitude = 0, this.userLongitude = 0});

  UserPosition.init(Position position) {
    userLatitude = position.latitude;
    userLongitude = position.longitude;
  }

  bool isNullPosition() {
    return userLatitude == 0 && userLongitude == 0;
  }

  double getUserLatitude() {
    return userLatitude;
  }

  double getUserLongitude() {
    return userLongitude;
  }

  setUserLatitude(double userLatitude) {
    this.userLatitude = userLatitude;
  }

  setUserLongitude(double userLongitude) {
    this.userLongitude = userLongitude;
  }
}
