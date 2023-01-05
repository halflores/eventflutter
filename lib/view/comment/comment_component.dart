import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflutter/modelo/comment.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/comment_fireStore.dart';
import 'package:eventflutter/services/usuario_fireStore.dart';
import 'package:eventflutter/view/comment/stream_comment_count.dart';
import 'package:eventflutter/theme/color.dart' as color;

class CommentComponent extends StatefulWidget {
  final Comment comment;
  CommentComponent({Key? key, required this.comment}) : super(key: key);

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  late Usuario userPost;
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    final u = await UsuarioFireStore().getCurrentUser(widget.comment.id_user);
    if (u != null) {
      userPost = u;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (_loading) {
      return const Scaffold(
        //backgroundColor: Color(Constants.COLOR_PRIMARY),
        body: Center(
          child: CircularProgressIndicator(
              color: color.primary,
              valueColor: AlwaysStoppedAnimation<Color>(color.inActiveColor),
              backgroundColor: color.shadowColor),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userPost != null)
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: userPost.urlImagen != null
                    ? NetworkImage(userPost.urlImagen!)
                    : null,
                child: userPost.urlImagen != null
                    ? Container()
                    : const Icon(Icons.person, color: Colors.black),
              ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (userPost != null)
                    Text(
                      userPost.nombre,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent),
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    color: Colors.black.withOpacity(.3),
                    height: 1,
                    width: width / 1.5,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: width / 1.5,
                    child: Text(
                      widget.comment.msg,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {},
                      ),
                      const Text("0",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                      IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {},
                      ),
                      const Text("0",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                      StreamProvider<int>.value(
                        value: CommentFireStore()
                            .getCountCommentComment(widget.comment.id),
                        initialData: 0,
                        child: StreamCommentComment(
                          comment: widget.comment,
                          user: userPost,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
