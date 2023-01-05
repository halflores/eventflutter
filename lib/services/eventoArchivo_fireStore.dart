import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eventflutter/modelo/evento_archivo.dart';
import '../constants.dart' as constants;

class FireStoreAnuncioArchivo {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();

  Future<EventoArchivo?> getPortadaEventoArchivo(String eventoId) async {
    EventoArchivo? archivo;

    await firestore
        .collection(constants.eventoArchivo)
        .where('eventoID', isEqualTo: eventoId)
        .where('portada', isEqualTo: true)
        .get()
        .then((value) {
      archivo = EventoArchivo.fromJson(value.docs.first.data());
    });
    return archivo!;
  }

  Future<List<EventoArchivo>> getEventoArchivo(String eventoId) async {
    List<EventoArchivo> archivos = [];

    await firestore
        .collection(constants.eventoArchivo)
        .where('eventoID', isEqualTo: eventoId)
        .orderBy('portada')
        .get()
        .then((value) {
      for (var item in value.docs) {
        archivos.add(EventoArchivo.fromJson(item.data()));
      }
    });
    return archivos;
  }

  Future<String> uploadAnuncioArchivoToFireStorage(
      File image, String eventoArchivoID) async {
    Reference upload = storage.child("imagenes/eventos/$eventoArchivoID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
