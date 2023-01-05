import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/anfitrion.dart';

class AnfitrionFireStore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();

  Future<Anfitrion?> getCurrentAnfitrion(String anfitrionId) async {
    DocumentSnapshot userDocument =
        await firestore.collection(anfitrion).doc(anfitrionId).get();
    if (userDocument.exists) {
      return Anfitrion.fromJson(userDocument.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<String> uploadAnfitrionImageToFireStorage(
      File image, String nombre) async {
    Reference upload = storage.child("imagenes/anfitrion/$nombre.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
