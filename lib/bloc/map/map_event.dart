part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class ResetMap extends MapEvent {}

class SetDireccion extends MapEvent {
  final MapDireccion direccion;
  SetDireccion(this.direccion);
}
