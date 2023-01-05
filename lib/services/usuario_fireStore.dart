import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/usuario.dart';

class UsuarioFireStore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();

  Future<Usuario?> getCurrentUser(String? uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(usuarios).doc(uid).get();
    if (userDocument.exists) {
      return Usuario.fromJson(userDocument.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<Usuario>> getCurrentUserByCelular(String celular) async {
    return await firestore
        .collection(usuarios)
        .where('celular', isEqualTo: celular)
        //.orderBy('descripcion')
        .get()
        .then((value) =>
            value.docs.map((e) => Usuario.fromJson(e.data())).toList());
  }

  static Future<Usuario> updateCurrentUser(Usuario user) async {
    return await firestore
        .collection(usuarios)
        .doc(user.usuarioID)
        .set(user.toJson())
        .then((document) {
      return user;
    });
  }

  Future<String> uploadUserImageToFireStorage(
      File image, String usuarioID) async {
    Reference upload = storage.child("imagenes/usuario/$usuarioID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
