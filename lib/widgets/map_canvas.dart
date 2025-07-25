import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../models/map_point.dart';

class MapCanvas extends CustomPainter {
  final ui.Image? siteMapImage;
  final List<MapPoint> points;
  final scale;
  final double tX, tY;

  MapCanvas(this.siteMapImage, this.points, this.tX, this.tY, this.scale);

  void drawPoint(Canvas canvas, MapPoint coords, double size, Paint paint,
      int pointIndex) {
    //NOTE: This re-renders for every movement / change to the screen

    paint.color = const ui.Color.fromRGBO(244, 236, 7, 0.56);

    Offset center = Offset(coords.x, coords.y);
    canvas.drawCircle(center, size, paint);
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (siteMapImage != null) {
      canvas.scale(scale);
      canvas.translate(tX, tY);
      canvas.drawImage(siteMapImage!, Offset.zero, Paint());
      for (var i = 0; i < points.length; i++) {
        drawPoint(canvas, points[i], 10, Paint(), i);
      }
    }
  }

  @override
  bool shouldRepaint(MapCanvas oldDelegate) {
    return (siteMapImage != oldDelegate.siteMapImage ||
        points.length != oldDelegate.points.length ||
        tX != oldDelegate.tX ||
        tY != oldDelegate.tY);
  }
}
