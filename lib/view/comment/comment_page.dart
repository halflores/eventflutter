import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/modelo/comment.dart';
import 'package:eventflutter/modelo/evento_item.dart';
import 'package:eventflutter/services/comment_fireStore.dart';
import 'package:eventflutter/view/comment/comment_component.dart';

class CommentWidget extends StatelessWidget {
  EventoItem vehicule;
  CommentWidget({Key? key, required this.vehicule}) : super(key: key);
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des commentaires"),
        backgroundColor: Colors.green,
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
                  : comments.isEmpty
                      ? const Center(
                          child: Text("Aucune voitures"),
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
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      String? usuarioID = _prefs.getString('usuarioID');

                      bool commentOk = await CommentFireStore().add_comment(
                          Comment(
                              id_comment_pub: vehicule.eventoID,
                              id_user: usuarioID!,
                              date_comment: Timestamp.now(),
                              dislike: [],
                              like: [],
                              id_comment: '',
                              id: '',
                              msg: commentController.text));
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
