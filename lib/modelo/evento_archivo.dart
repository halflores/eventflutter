import 'package:cloud_firestore/cloud_firestore.dart';

class EventoArchivo {
  String? eventoArchivoID = '';
  String? eventoID = '';
  String? nombre = '';
  Timestamp? fecha = Timestamp.now();
  String? urlArchivo = '';

  EventoArchivo(
      {this.eventoArchivoID,
      this.eventoID,
      this.nombre,
      this.fecha,
      this.urlArchivo});

  factory EventoArchivo.fromJson(Map<String, dynamic> parsedJson) {
    return EventoArchivo(
        eventoArchivoID: parsedJson['eventoArchivoID'] ?? '',
        eventoID: parsedJson['eventoID'] ?? '',
        nombre: parsedJson['nombre'] ?? '',
        fecha: parsedJson['fecha'] ?? '',
        urlArchivo: parsedJson['urlArchivo'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'eventoArchivoID': eventoArchivoID,
      'eventoID': eventoID,
      'nombre': nombre,
      'fecha': fecha,
      'urlArchivo': urlArchivo
    };
  }
}
