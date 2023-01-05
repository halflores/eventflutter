import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflutter/modelo/comment.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/comment_fireStore.dart';
import 'package:eventflutter/view/comment/comment_component.dart';

class CommentCommentWidget extends StatelessWidget {
  Comment comment;
  Usuario user;
  CommentCommentWidget({Key? key, required this.comment, required this.user})
      : super(key: key);
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Commentaire de ${user.nombre}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: comments == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  : comments.length == 0
                      ? const Center(
                          child: Text("Aucun commentaire"),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (ctx, i) {
                            final comment = comments[i];
                            return CommentComponent(comment: comment);
                          },
                        )),
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      bool commentOk = await CommentFireStore().add_comment(
                          Comment(
                              date_comment: Timestamp.now(),
                              dislike: [],
                              like: [],
                              id_comment_pub: '',
                              id_user: user.usuarioID,
                              id_comment: comment.id,
                              msg: commentController.text,
                              id: ''));
                      if (commentOk) commentController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
