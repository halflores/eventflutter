import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart' as locator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:eventflutter/bloc/map/map_bloc.dart';
import 'package:eventflutter/modelo/map_direccion.dart';
import 'package:eventflutter/theme/color.dart' as color;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
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
    super.initState();

/*     _cameraPosition = const CameraPosition(
        target: LatLng(-17.3305558, -66.0581964), zoom: 10.0); */
    setState(() {
      //_isInAsyncCall = false;
      getCurrentLocation();
    });
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
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                  target: LatLng(-17.3305558, -66.0581964), zoom: 10.0),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
              mapType: _currentMapType,
              onCameraMove: _onCameraMove,
            ),
            Positioned(
              top: 60.0,
              right: 10.0,
              child: FloatingActionButton(
                heroTag: Icons.my_location_sharp.codePoint,
                onPressed: () async {
                  getLocation();
                },
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: color.appBgColor,
                child:
                    const Icon(Icons.my_location_sharp, color: color.mainColor),
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
            Positioned(
              top: 10.0,
              right: 10.0,
              //left: 100.0,
              child: TextButton(
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
                child: const Text(
                  'Aceptar dirección',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color.mainColor),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  _onSaveMap() async {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    Uint8List? imageBytes;

    await _mapController.takeSnapshot().then((value) {
      imageBytes = value;
    });
    MapDireccion direccion = MapDireccion(
      latLng: GeoPoint(latlong.latitude, latlong.longitude),
      url: '',
      bitmap: imageBytes,
      city: '', // results.locality,
      country: '', // results.country,
      postcode: '', // results.postalCode,
      state: '', // results.subLocality,
      street: '', // results.street
    );
    mapBloc.add(SetDireccion(direccion));
    setState(() {
      _isInAsyncCall = false;
    });

/* 
// de ete bloque comentado es para la prueba de obtener la direccion, en realidad no se usa aqui porque sale el error que ya cambio de widget
        GeoCode geoCode = GeoCode();
    try {
      var results = await geoCode.reverseGeocoding(
          latitude: latlong.latitude, longitude: latlong.longitude);

      MapDireccion direccion = MapDireccion(
          latLng: GeoPoint(latlong.latitude, latlong.longitude),
          url: '',
          bitmap: mapBloc.state.bitmap,
          city: results.city,
          country: results.countryName,
          postcode: results.postal,
          state: results.region,
          street: results.streetAddress);
      mapBloc.add(SetDireccion(direccion));
      setState(() {
        _isInAsyncCall = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('reverseGeocoding $e')));
      debugPrint("reverseGeocoding $e");
      return;
    } */

/*     try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latlong.latitude, latlong.longitude);
      final placemark = placemarks.first;
      MapDireccion direccion = MapDireccion(
          latLng: GeoPoint(latlong.latitude, latlong.longitude),
          url: '',
          bitmap: mapBloc.state.bitmap,
          city: placemark.subLocality,
          country: placemark.country,
          postcode: placemark.postalCode,
          state: placemark.locality,
          street: placemark.street);
      mapBloc.add(SetDireccion(direccion));
      setState(() {
        _isInAsyncCall = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('reverseGeocoding $e')));
      debugPrint("reverseGeocoding $e");
      return;
    } */
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

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    _getLocationHandle(_lastMapPosition);
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
    setState(() {
      _isInAsyncCall = true;
    });
    locator.Position posicion = await locator.Geolocator.getCurrentPosition(
        desiredAccuracy: locator.LocationAccuracy.high);
    latlong = LatLng(posicion.latitude, posicion.longitude);

    _cameraPosition = CameraPosition(target: latlong, zoom: 17.0);
/*     setState(() {
      //latlong = LatLng(point.latitude, point.longitude);
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(latlong.toString()),
        draggable: true,
        position: latlong,
        //infoWindow: InfoWindow(title: _title, snippet: _detail),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        /*  onDragEnd: (_currentlatLng) async {
            latlong = _currentlatLng;
          } */
      ));
    }); */
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
