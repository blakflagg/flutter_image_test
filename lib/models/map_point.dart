import 'package:image/image.dart';

class MapPoint extends Point {
  @override
  final double x, y;
  MapPoint(this.x, this.y);

  @override
  String toString() {
    return 'x:$x y:$y';
  }
}
