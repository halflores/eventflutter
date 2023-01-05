part of 'map_bloc.dart';

class MapState {
  final String street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  GeoPoint? latLng;
  final String url;
  Uint8List? bitmap;

  MapState(
      {this.street = '',
      this.city = '',
      this.state = '',
      this.country = '',
      this.postcode = '',
      this.latLng,
      this.url = '',
      this.bitmap});

  MapState copyMap(
          {String? street,
          String? city,
          String? state,
          String? country,
          String? postcode,
          required GeoPoint latLng,
          String? url,
          required Uint8List? bitmap}) =>
      MapState(
          street: street ?? this.street,
          bitmap: bitmap,
          city: city ?? this.city,
          country: country ?? this.country,
          latLng: latLng,
          postcode: postcode ?? this.postcode,
          state: state ?? this.state,
          url: url ?? this.url);

  MapState resetMap() {
    return MapState(
        street: '',
        bitmap: null,
        city: '',
        country: '',
        latLng: null,
        postcode: '',
        state: '',
        url: '');
  }
}
