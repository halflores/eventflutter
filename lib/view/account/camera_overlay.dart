import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:eventflutter/theme/color.dart' as color;

class TakeCameraOverlay extends StatefulWidget {
  const TakeCameraOverlay({Key? key}) : super(key: key);

  @override
  _TakeCameraOverlayState createState() => _TakeCameraOverlayState();
}

class _TakeCameraOverlayState extends State<TakeCameraOverlay> {
  OverlayFormat format = OverlayFormat.cardID3;
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //backgroundColor: color.actionColor,
          appBar: AppBar(
            backgroundColor: color.bottomBarColor,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: color.primary,
              ),
            ),
          ),
          body: FutureBuilder<List<CameraDescription>?>(
            future: availableCameras(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No encontró camara alguna!!!',
                        style: TextStyle(color: Colors.black),
                      ));
                }
                return CameraOverlay(
                    snapshot.data!.first,
                    CardOverlay.byFormat(format),
                    (XFile file) =>
                        Navigator.pop(this.context, File(file.path)),
                    info:
                        'Posicionar el carnet de identidad dentro del rectángulo y asegúrate que la imagen es perfectamente legible.',
                    label: 'Scanear C.I.');
              } else {
                return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Obteniendo camaras',
                      style: TextStyle(color: Colors.black),
                    ));
              }
            },
          ),
        ));
  }
}
