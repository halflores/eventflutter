import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String correo = '';
  String nombre = '';
  String apellido = '';
  String celular = '';
  bool active = false;
  Timestamp? finUltimoInicio = Timestamp.now();
  String usuarioID;
  String? urlImagen = '';
  String token = '';
  String platform = '';
  String? presentacion = '';
  bool verificado = false;
  List<String>? visto;
  List<String>? favorito;

  Usuario(
      {required this.correo,
      required this.nombre,
      required this.celular,
      required this.apellido,
      required this.active,
      this.finUltimoInicio,
      required this.usuarioID,
      this.urlImagen,
      required this.token,
      required this.platform,
      this.presentacion,
      this.verificado = false,
      this.visto,
      this.favorito});

  String fullName() {
    return '$nombre $apellido';
  }

  factory Usuario.fromJson(Map<String, dynamic> parsedJson) {
    return Usuario(
        correo: parsedJson['correo'] ?? '',
        nombre: parsedJson['nombre'] ?? '',
        apellido: parsedJson['apellido'] ?? '',
        active: parsedJson['active'] ?? false,
        finUltimoInicio: parsedJson['finUltimoInicio'],
        celular: parsedJson['celular'] ?? '',
        usuarioID: parsedJson['usuarioID'] ?? 0,
        urlImagen: parsedJson['urlImagen'] ?? '',
        token: parsedJson['token'] ?? '',
        platform: parsedJson['platform'] ?? '',
        presentacion: parsedJson['presentacion'] ?? '',
        verificado: parsedJson['verificado'],
        visto: List.from(['visto']),
        favorito: List.from(['favorito']));
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'nombre': nombre,
      'apellido': apellido,
      'celular': celular,
      'usuarioID': usuarioID,
      'active': active,
      'finUltimoInicio': finUltimoInicio,
      'urlImagen': urlImagen,
      'token': token,
      'platform': platform,
      'presentacion': presentacion,
      'verificado': verificado,
      'visto': jsonEncode(visto),
      'favorito': jsonEncode(favorito),
    };
  }
}
