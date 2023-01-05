import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventflutter/modelo/map_direccion.dart';

class EventoItem {
  String eventoID = '';
  String tipoEvento = ''; //single, campeonato

  bool active = false;
  Timestamp? fecha = Timestamp.now();
  String grupo = '';
  MapDireccion? direccionEvento;

  String usuarioID = '';
  String usuarioNombre = '';
  String usuarioUrlImagen = '';

  String? descripcion = '';
  int cantLikes = 0;
  String? motivo; // el motivo por el cual esta activo en true or false
  String? urlPortada;
  String? urlThumbnail;

  String fechaInicial;
  String? fechaFinal;
  String horaInicial;
  String? horaFinal;
  int visto = 0;
  int favorito = 0;

  EventoItem(
      {required this.eventoID,
      required this.tipoEvento,
      required this.active,
      this.fecha,
      required this.grupo,
      required this.direccionEvento,
      required this.usuarioID,
      required this.usuarioNombre,
      required this.usuarioUrlImagen,
      this.descripcion,
      required this.cantLikes,
      this.motivo,
      this.urlPortada,
      this.urlThumbnail,
      required this.fechaInicial,
      this.fechaFinal,
      required this.horaInicial,
      this.horaFinal,
      this.visto = 0,
      this.favorito = 0});

  factory EventoItem.fromJson(Map<String, dynamic> parsedJson) {
    return EventoItem(
        eventoID: parsedJson['eventoID'] ?? '',
        tipoEvento: parsedJson['tipoEvento'] ?? '',
        active: parsedJson['active'] ?? false,
        fecha: parsedJson['fecha'] ?? Timestamp.now(),
        grupo: parsedJson['grupo'] ?? '',
        direccionEvento: parsedJson["direccionEvento"] == null
            ? null
            : MapDireccion.fromJson(parsedJson["direccionEvento"]),
        usuarioID: parsedJson['usuarioID'] ?? '',
        usuarioNombre: parsedJson['usuarioNombre'] ?? '',
        usuarioUrlImagen: parsedJson['usuarioUrlImagen'] ?? '',
        descripcion: parsedJson['descripcion'] ?? '',
        cantLikes: parsedJson['cantLikes'] ?? 0,
        motivo: parsedJson['motivo'] ?? '',
        urlPortada: parsedJson['urlPortada'] ?? '',
        urlThumbnail: parsedJson['urlThumbnail'] ?? '',
        fechaInicial: parsedJson['fechaInicial'] ?? '',
        fechaFinal: parsedJson['fechaFinal'] ?? '',
        horaInicial: parsedJson['horaInicial'] ?? '',
        horaFinal: parsedJson['horaFinal'] ?? '',
        visto: parsedJson['visto'] ?? 0,
        favorito: parsedJson['favorito'] ?? 0);
  }

  factory EventoItem.algoliaJson(Map<String, dynamic> parsedJson) {
    return EventoItem(
        eventoID: parsedJson['eventoID'] ?? '',
        tipoEvento: parsedJson['tipoEvento'] ?? '',
        active: parsedJson['active'] ?? false,
        fecha: Timestamp.fromMillisecondsSinceEpoch(parsedJson['fecha']),
        grupo: parsedJson['grupo'] ?? '',
        direccionEvento: parsedJson['direccionEvento'] ?? '',
        usuarioID: parsedJson['usuarioID'] ?? '',
        usuarioNombre: parsedJson['usuarioNombre'] ?? '',
        usuarioUrlImagen: parsedJson['usuarioUrlImagen'] ?? '',
        descripcion: parsedJson['descripcion'] ?? '',
        cantLikes: parsedJson['cantLikes'] ?? 0,
        motivo: parsedJson['motivo'] ?? '',
        urlPortada: parsedJson['urlPortada'] ?? '',
        urlThumbnail: parsedJson['urlThumbnail'] ?? '',
        fechaInicial: parsedJson['fechaInicial'] ?? '',
        fechaFinal: parsedJson['fechaFinal'] ?? '',
        horaInicial: parsedJson['horaInicial'] ?? '',
        horaFinal: parsedJson['horaFinal'] ?? '',
        visto: parsedJson['visto'] ?? 0,
        favorito: parsedJson['favorito'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'eventoID': eventoID,
      'tipoEvento': tipoEvento,
      'active': active,
      'fecha': fecha,
      'grupo': grupo,
      'direccionEvento': direccionEvento!.toJson(),
      'usuarioID': usuarioID,
      'usuarioNombre': usuarioNombre,
      'usuarioUrlImagen': usuarioUrlImagen,
      'descripcion': descripcion,
      'cantLikes': cantLikes,
      'motivo': motivo,
      'urlPortada': urlPortada,
      'urlThumbnail': urlThumbnail,
      'fechaInicial': fechaInicial,
      'fechaFinal': fechaFinal,
      'horaInicial': horaInicial,
      'horaFinal': horaFinal,
      'visto': visto,
      'favorito': favorito,
    };
  }
}
