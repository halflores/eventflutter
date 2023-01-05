import 'package:cloud_firestore/cloud_firestore.dart';

class Anfitrion {
  String usuarioID;
  String anfitrionID;
  String presentacion = '';
  String? anverso = '';
  String? reverso = '';
  String? selfie = '';
  Timestamp? fecha = Timestamp.now();
  bool verificado = false;

  Anfitrion({
    required this.usuarioID,
    required this.anfitrionID,
    required this.anverso,
    required this.reverso,
    required this.selfie,
    this.fecha,
    this.verificado = false,
  });

  factory Anfitrion.fromJson(Map<String, dynamic> parsedJson) {
    return Anfitrion(
      usuarioID: parsedJson['usuarioID'] ?? '',
      anfitrionID: parsedJson['anfitrionID'] ?? '',
      anverso: parsedJson['anverso'] ?? '',
      reverso: parsedJson['reverso'] ?? '',
      selfie: parsedJson['selfie'] ?? '',
      fecha: parsedJson['fecha'],
      verificado: parsedJson['verificado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioID': usuarioID,
      'anfitrionID': anfitrionID,
      'anverso': anverso,
      'reverso': reverso,
      'selfie': selfie,
      'fecha': fecha,
      'verificado': verificado,
    };
  }
}
