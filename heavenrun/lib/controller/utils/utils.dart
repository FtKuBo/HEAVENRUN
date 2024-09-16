class Util {
  static bool isDistance(int? distance) {
    // if (distance == Null or distance == 0) {
    //   return false;
    // }
    return distance.runtimeType == int;
  }
}
