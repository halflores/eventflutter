import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eventflutter/modelo/comment.dart';
import '../constants.dart' as constants;

class CommentFireStore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();

  final CollectionReference commentColl =
      firestore.collection(constants.comentario);

  Future<bool> add_comment(Comment comment) async {
    try {
      await commentColl.doc().set(
          comment.toMap()..update("date_comment", (value) => Timestamp.now()));
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<int> getCountComment(String id) {
    return commentColl
        .where("id_comment_pub", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList()
          .length;
    });
  }

  Stream<List<Comment>> gecomment(String id) {
    return commentColl
        .where("id_comment_pub", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
    });
  }

  Stream<List<Comment>> gecommentComment(String id) {
    return commentColl
        .where("id_comment", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
    });
  }

  Stream<int> getCountCommentComment(String id) {
    return commentColl
        .where("id_comment", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList()
          .length;
    });
  }
}
