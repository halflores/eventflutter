import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GrupoFireStore {
/*   static FirebaseApp secondaryApp = Firebase.app('eventflutter');

  static FirebaseFirestore firestore =
      FirebaseFirestore.instanceFor(app: secondaryApp); */

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();

/*   Future<void> agregarEvento(EventoItem evento) async {
    firestore
        .collection(constants.eventos)
        .add(evento.toJson())
        .then((doc) => debugPrint("Evento ingresado"))
        .catchError(
            (onError) => debugPrint("Falló al agregar evento: $onError"));
  } */

/*   Stream<QuerySnapshot<Map<String, dynamic>>> getChat(String usuarioID) {
    return firestore
        .collectionGroup('miembros')
        .where('usuarioID', isEqualTo: usuarioID)
        .snapshots();
  } */
/* 
  Future<String?> existeChat(List<String> miembrosUsuarioID) async {
    String? chatId;
    Chat chat;
    QuerySnapshot querySnapshot = await FireStoreChat.firestore
        .collection(CHAT)
        .where('miembrosUsuarioID', arrayContains: miembrosUsuarioID[0])
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      chat =
          Chat.fromJson(querySnapshot.docs[i].data() as Map<String, dynamic>);
      if (chat.miembrosUsuarioID.contains(miembrosUsuarioID[1])) {
        chatId = chat.chatID;
        break;
      }
    }

    return chatId;
  } */
}
