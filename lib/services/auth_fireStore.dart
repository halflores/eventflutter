import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:eventflutter/services/usuario_fireStore.dart';
import 'package:eventflutter/utils/helper.dart';

class AuthFireStore {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  late Usuario usuario;
  late auth.UserCredential result;
  late String? profilePicUrl;

  Future<String?> _subirAFirebaseStorage(File image, String usuarioId) async {
    String? profilePicUrl;

    profilePicUrl =
        await UsuarioFireStore().uploadUserImageToFireStorage(image, usuarioId);
    return profilePicUrl;
  }

  Future<Usuario?> signUp(
      {required String email,
      required String password,
      required Usuario user,
      File? imagen}) async {
    var imgAvatar;
    try {
      result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (imagen != null) {
        imgAvatar = await Future.wait(
            [_subirAFirebaseStorage(imagen, result.user!.uid)]);
      }

      // obtener token para recibir puch notificaciones
/*       FirebaseMessaging? messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();
 */
      usuario = Usuario(
          finUltimoInicio: Timestamp.now(),
          verificado: true,
          platform: Platform.operatingSystem,
          correo: email,
          nombre: user.nombre,
          celular: user.celular,
          usuarioID: result.user!.uid,
          active: true,
          apellido: user.apellido,
          urlImagen: imagen != null ? imgAvatar[0] : '',
          token: '');
      await setPrefUsuario(usuario);

      await UsuarioFireStore.firestore
          .collection(usuarios)
          .doc(result.user!.uid)
          .set(usuario.toJson());

      return usuario;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('La contraseña es débil');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('El correo ya está en uso');
      } else if (e.code == 'invalid-email') {
        throw Exception('Correo no válido');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Correo/Contraseña no están habilitados');
      } else if (e.code == 'too-many-requests') {
        throw Exception(
            'Hay muchas solicitudes. Por favor, vuelva a intentar.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<Usuario?> signIn(
      {required String email, required String password}) async {
    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot? documentSnapshot = await UsuarioFireStore.firestore
          .collection(usuarios)
          .doc(result.user!.uid)
          .get();

      if (documentSnapshot.exists) {
        usuario =
            Usuario.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        usuario.active = true;

        // actualizar el campo active
        await UsuarioFireStore.firestore
            .collection(usuarios)
            .doc(result.user!.uid)
            .update({
          'active': true,
        });

        return usuario;
      } else {
        return null;
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('Correo electrónico incorrecto.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta.');
      } else if (e.code == 'user-not-found') {
        throw Exception(
            'El usuario no corresponde a este correo.  Por favor, intente otra vez');
      } else if (e.code == 'user-disabled') {
        throw Exception('Usuario deshabilitado.');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Hay muchas demandas. Por favor, intente mas tarde.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<Usuario?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      await _firebaseAuth.signInWithCredential(credential).then((value) {
        // registrar usuario en firebase
        // obtener token para recibir puch notificaciones

        /*     FirebaseMessaging? messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken(); */

        usuario = Usuario(
            finUltimoInicio: Timestamp.now(),
            verificado: true,
            platform: Platform.operatingSystem,
            correo: value.user!.email!,
            nombre: value.user!.displayName ?? '',
            celular: value.user!.phoneNumber ?? '',
            usuarioID: value.user!.uid,
            active: true,
            apellido: '',
            urlImagen: value.user!.photoURL,
            token: '');
        setPrefUsuario(usuario);
        UsuarioFireStore.firestore
            .collection(usuarios)
            .doc(value.user!.uid)
            .set(usuario.toJson());
      }).whenComplete(() => {});
      return usuario;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
