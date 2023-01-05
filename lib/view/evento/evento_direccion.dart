import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart' as locator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:eventflutter/bloc/map/map_bloc.dart';
import 'package:eventflutter/modelo/map_direccion.dart';
import 'package:eventflutter/theme/color.dart' as color;

class EventoDireccion extends StatefulWidget {
  final MapDireccion direccionEvento;
  const EventoDireccion({Key? key, required this.direccionEvento})
      : super(key: key);

  @override
  EventoDireccionState createState() => EventoDireccionState();
}

class EventoDireccionState extends State<EventoDireccion> {
  late LatLng latlong;
  late LatLng _lastMapPosition;
  late CameraPosition _cameraPosition;
  late GoogleMapController _mapController;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  TextEditingController locationController = TextEditingController();
  bool _isInAsyncCall = false;
  @override
  void initState() {
    _cameraPosition = CameraPosition(
        target: LatLng(widget.direccionEvento.latLng.latitude,
            widget.direccionEvento.latLng.longitude),
        zoom: 15.0);

    //getCurrentLocation();
    _getLocationHandle(LatLng(widget.direccionEvento.latLng.latitude,
        widget.direccionEvento.latLng.longitude));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          progressIndicator: const Center(
              child: CircularProgressIndicator(
                  color: color.primary,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(color.inActiveColor),
                  backgroundColor: color.shadowColor)),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = (controller);
                  _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(_cameraPosition));
                  setState(() {
                    _isInAsyncCall = false;
                  });
                },
                markers: _markers,
                mapType: _currentMapType,
                // onCameraMove: _onCameraMove,
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: FloatingActionButton(
                  heroTag: Icons.ac_unit.codePoint,
                  onPressed: () {
                    setState(() {
                      _currentMapType = _currentMapType == MapType.normal
                          ? MapType.satellite
                          : MapType.normal;
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: color.appBgColor,
                  child: const Icon(Icons.ac_unit, color: color.mainColor),
                ),
              ),
              Positioned(
                top: 70.0,
                right: 10.0,
                child: FloatingActionButton(
                  heroTag: Icons.my_location_sharp.codePoint,
                  onPressed: () async {
                    getCurrentLocation();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: color.appBgColor,
                  child: const Icon(Icons.my_location_sharp,
                      color: color.mainColor),
                ),
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                child: FloatingActionButton(
                  heroTag: Icons.arrow_back.codePoint,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: color.appBgColor,
                  child: const Icon(Icons.arrow_back, color: color.mainColor),
                ),
              ),
/*               Positioned(
                top: 10.0,
                right: 10.0,
                //left: 100.0,
                child: TextButton(
                  child: const Text(
                    'Aceptar dirección',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color.mainColor),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: color.appBarColor,
                    //onPrimary: Colors.white,
                    side: const BorderSide(color: color.orangeDark, width: 2.0),
                  ),
                  onPressed: () {
                    debugPrint('Pressed');
                    setState(() {
                      _isInAsyncCall = true;
                    });
                    _onSaveMap();
                    Navigator.of(context).pop();
                  },
                ),
              ) */
            ],
          ),
        ),
      )),
    );
  }

  _getLocationHandle(LatLng point) async {
    setState(() {
      latlong = LatLng(point.latitude, point.longitude);
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId(latlong.toString()),
          draggable: true,
          position: latlong,
          //infoWindow: InfoWindow(title: _title, snippet: _detail),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onDragEnd: (_currentlatLng) async {
            latlong = _currentlatLng;
          }));
    });
  }

  Future getCurrentLocation() async {
    locator.LocationPermission permission =
        await locator.Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      locator.LocationPermission permission =
          await locator.Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) {
        getLocation();
      }
      return;
    }
    getLocation();
  }

  getLocation() async {
    /*   setState(() {
      _isInAsyncCall = true;
    }); */
    locator.Position posicion = await locator.Geolocator.getCurrentPosition(
        desiredAccuracy: locator.LocationAccuracy.high);
    latlong = LatLng(posicion.latitude, posicion.longitude);

    _cameraPosition = CameraPosition(target: latlong, zoom: 15.0);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(latlong.toString()),
          draggable: true,
          position: latlong,
          //infoWindow: InfoWindow(title: _title, snippet: _detail),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onDragEnd: (_currentlatLng) async {
            latlong = _currentlatLng;
          }));
    });
  }
}
