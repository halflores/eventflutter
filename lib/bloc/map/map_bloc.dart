import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/map_direccion.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState()) {
    on<ResetMap>((event, emit) {
      try {
        emit(state.resetMap());
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<SetDireccion>((event, emit) {
      try {
        emit(_setDireccion(event.direccion));
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  _setDireccion(MapDireccion direccion) {
    return MapState(
        bitmap: direccion.bitmap,
        city: direccion.city!,
        country: direccion.country!,
        latLng: direccion.latLng,
        postcode: direccion.postcode!,
        state: direccion.state!,
        street: direccion.street!,
        url: direccion.url);
  }
}
