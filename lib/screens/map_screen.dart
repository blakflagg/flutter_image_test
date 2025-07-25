import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_test/models/map_point.dart';
import 'package:flutter_image_test/widgets/map_canvas.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<MapPoint> points = [];
  List<Image> mapImages = [];

  double tX = 0;
  double tY = 0;
  double scale = 1.0;

  void addPoint(Offset position) {
    double x, y;
    x = position.dx / scale;
    y = position.dy / scale;

    MapPoint p = MapPoint(x - tX, y - tY);
    print(p.toString());
    setState(() {
      points.add(p);
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    double scaleDelta = 0.0;

    double scaleTemp = 1.0;
    scaleTemp = details.scale.clamp(-0.24, 2.5);

    if (scaleTemp != 1 && scaleTemp >= -0.24 && scaleTemp <= 2.5) {
      scaleDelta = scale - scaleTemp;
    } else {
      scaleDelta = 0;
    }

    setState(() {
      if (scaleDelta < 0) {
        zoomIn(scaleDelta);
      } else if (scaleDelta > 0) {
        zoomOut(scaleDelta);
      }

      tX += details.focalPointDelta.dx;
      tY += details.focalPointDelta.dy;
    });
    scaleTemp = 0;
  }

  void zoomIn(double scaleDelta) {
    if (scale > 2.5) {
      scale = 2.5;
    }

    if (scale < 2.5) {
      scale += 0.01; //scaleDelta.abs();
    }
  }

  void zoomOut(double scaleDelta) {
    if (scale <= 0.24) {
      scale = 0.24;
    }

    if (scale > -0.24) {
      scale -= 0.01;
    }
  }

  void _completeLongPress(LongPressStartDetails details) {
    addPoint(details.localPosition);
  }

  Future<ui.Image> loadImageResize() async {
    final bytesBuffer = await rootBundle.load('images/sitemap.jpg');

    ui.Codec codec = await ui.instantiateImageCodec(
        bytesBuffer.buffer.asUint8List(),
        targetHeight: 2200,
        targetWidth: 1700);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Mapping"),
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          return FittedBox(
            child: SizedBox(
              width: 400,
              height: 600,
              child: GestureDetector(
                onScaleUpdate: _handleScaleUpdate,
                onLongPressStart: _completeLongPress,
                // onScaleEnd: _handleScaleEnd,
                child: CustomPaint(
                  painter: MapCanvas(snapshot.data, points, tX, tY, scale),
                  child: Container(),
                ),
              ),
            ),
          );
        },
        future: loadImageResize(),
      ),
    );
  }
}
