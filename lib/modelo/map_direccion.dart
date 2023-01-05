import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapDireccion {
  String? street;
  String? city;
  String? state;
  String? country;
  String? postcode;
  GeoPoint latLng;
  String url;
  Uint8List? bitmap;

  MapDireccion(
      {this.street,
      this.city,
      this.state,
      this.country,
      this.postcode,
      required this.latLng,
      required this.url,
      this.bitmap});

  factory MapDireccion.fromJson(Map<String, dynamic> parsedJson) {
    return MapDireccion(
      street: parsedJson['street'] ?? '',
      city: parsedJson['city'] ?? '',
      state: parsedJson['state'] ?? '',
      country: parsedJson['country'] ?? '',
      postcode: parsedJson['postcode'] ?? '',
      latLng: parsedJson['latLng'],
      url: parsedJson['url'],
      bitmap: parsedJson['bitmap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'latLng': latLng,
      'url': url,
      'bitmap': bitmap,
    };
  }
}
