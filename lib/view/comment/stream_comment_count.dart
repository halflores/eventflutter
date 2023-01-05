import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflutter/modelo/comment.dart';
import 'package:eventflutter/modelo/evento_item.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/comment_fireStore.dart';
import 'package:eventflutter/view/comment/coment_comment.dart';
import 'package:eventflutter/view/comment/comment_page.dart';

class StreamComment extends StatelessWidget {
  EventoItem vehicule;
  StreamComment({Key? key, required this.vehicule}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    String count = "";
    if (comment_lenght != null) {
      count = comment_lenght > 1
          ? "$comment_lenght commentaires"
          : "$comment_lenght commentaire";
    }
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.message,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                      value: CommentFireStore().gecomment(vehicule.eventoID),
                      initialData: const [],
                      child: CommentWidget(
                        vehicule: vehicule,
                      ),
                    )));
          },
        ),
        Text(count,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ))
      ],
    );
  }
}

class StreamCommentComment extends StatelessWidget {
  Comment comment;
  Usuario user;
  StreamCommentComment({Key? key, required this.comment, required this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    int count = 0;
    if (comment_lenght != null) {
      count = comment_lenght;
    }
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.message,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                      value: CommentFireStore().gecommentComment(comment.id),
                      initialData: const [],
                      child: CommentCommentWidget(comment: comment, user: user),
                    )));
          },
        ),
        Text("$count",
            style: const TextStyle(fontSize: 17, color: Colors.white))
      ],
    );
  }
}
