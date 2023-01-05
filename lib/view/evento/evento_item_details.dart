import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/evento_item.dart';
import 'package:eventflutter/services/comment_fireStore.dart';
import 'package:eventflutter/services/evento_fireStore.dart';
import 'package:eventflutter/services/usuario_fireStore.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/view/account/show_perfil.dart';
import 'package:eventflutter/view/comment/stream_comment_count.dart';
import 'package:eventflutter/view/evento/evento_direccion.dart';
import 'package:eventflutter/view/evento/video/preview.dart';
import 'package:eventflutter/widgets/custom_image.dart';
import 'package:eventflutter/widgets/favorite_box.dart';

class EventoItemDetails extends StatefulWidget {
  final EventoItem evento;
  const EventoItemDetails({Key? key, required this.evento}) : super(key: key);

  @override
  State<EventoItemDetails> createState() => _EventoItemDetailsState();
}

class _EventoItemDetailsState extends State<EventoItemDetails> {
  String firstHalf = '';
  String secondHalf = '';
  bool flag = true;
  late bool _isfavorite = false;
  late int cntfavorito = 0;
  String? _usuarioID;

  @override
  void initState() {
    cntfavorito = widget.evento.favorito;
    _verificarCurrentUser();
    if (widget.evento.descripcion!.trim().length > 50) {
      firstHalf = widget.evento.descripcion!.trim().substring(0, 50);
      secondHalf = widget.evento.descripcion!
          .trim()
          .substring(50, widget.evento.descripcion!.trim().length);
    } else {
      firstHalf = widget.evento.descripcion!.trim();
      secondHalf = "";
    }
    _isfavoriteItem();
    super.initState();
  }

  _verificarCurrentUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _usuarioID = _prefs.getString('usuarioID');
  }

  _isfavoriteItem() {
    UsuarioFireStore.firestore
        .collection(usuarios)
        .where('favorito', arrayContains: widget.evento.eventoID)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isfavorite = true;
        });
      }
    });
  }

  Future<void> _updateIsfavoriteItem() async {
    List<String> elementos = [widget.evento.eventoID];

    if (["", null, false, 0].contains(_usuarioID)) {
      //si es invitado
      // ir a pedir registrarse
    } else {
      if (_isfavorite) {
        //incrementar cantidad
        final DocumentReference docRef = EventoFireStore.firestore
            .collection(eventos)
            .doc(widget.evento.eventoID);
        docRef.update({"favorito": FieldValue.increment(1)});
        //agregar el item al usuario
        final DocumentReference docEvento =
            UsuarioFireStore.firestore.collection(usuarios).doc(_usuarioID);
        docEvento.update({"favorito": FieldValue.arrayUnion(elementos)});
        setState(() {
          cntfavorito++;
        });
      } else {
        final DocumentReference docRef = EventoFireStore.firestore
            .collection(eventos)
            .doc(widget.evento.eventoID);
        docRef.update({"favorito": FieldValue.increment(-1)});

        //quitar el item al usuario
        final DocumentReference docEvento =
            UsuarioFireStore.firestore.collection(usuarios).doc(_usuarioID);
        docEvento.update({"favorito": FieldValue.arrayRemove(elementos)});
        setState(() {
          cntfavorito--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: <Widget>[
            Hero(
                tag: widget.evento.urlPortada!,
                child: Preview(widget.evento.urlPortada!)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    /*    widthFactor: double.infinity,
                    heightFactor: double.infinity, */
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          /*                       GestureDetector(
                            onTap: () {
                              setState(() {
                                _isfavorite = !_isfavorite;
                              });
                              _updateIsfavoriteItem();
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                _isfavorite == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: color.actionColor,
                                size: 36,
                              ),
                            ),
                          ), */
                          FavoriteBox(
                              isFavorited: _isfavorite,
                              onTap: () {
                                setState(() {
                                  _isfavorite = !_isfavorite;
                                });
                                _updateIsfavoriteItem();
                              }),
                          Text(
                            cntfavorito.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: color.bottomBarColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 16.0, left: 8.0),
                        child: Container(
                          padding: const EdgeInsets.only(left: 0.0, right: 35),
                          child: secondHalf.isEmpty
                              ? Text(
                                  firstHalf,
                                  style: const TextStyle(
                                    color: color.bottomBarColor,
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    Text(
                                      flag
                                          ? ("$firstHalf...")
                                          : (firstHalf + secondHalf),
                                      style: const TextStyle(
                                        color: color.bottomBarColor,
                                      ),
                                    ),
                                    InkWell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            flag ? "Ver más" : "Ocultar",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          flag = !flag;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                        )),
                  ),

/*                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.evento.direccionEvento!.state!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
/*                       widget.place.images.length > 1
                          ? Row(
                              children: buildPageIndicator(),
                            )
                          : Container(), */
                    ],
                  ), */
                  const SizedBox(
                    height: 16,
                  ),
                  _showUser(),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      children: <Widget>[
                        _customButton(Icons.map_sharp, _showMap,
                            widget.evento.direccionEvento!.city),
                        const SizedBox(
                          height: 15,
                        ),
/*                         _customButton(
                            Icons.comment, _showComment, 'Comentarios'),
                        const SizedBox(
                          height: 150,
                        ) */
                        StreamProvider<int>.value(
                          value: CommentFireStore()
                              .getCountComment(widget.evento.eventoID),
                          initialData: 0,
                          child: StreamComment(vehicule: widget.evento),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _customButton(IconData icon, Function()? function, String? label) {
    return Column(
      children: <Widget>[
        FloatingActionButton(
          heroTag: icon.codePoint,
          onPressed: function,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Colors.transparent, // Colors.black.withOpacity(.5),
          child: Icon(
            icon,
            size: 30,
            color: color.appBarColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: color.bottomBarColor,
              fontSize: 15),
        )
      ],
    );
  }

  _showUser() {
    return GestureDetector(
      onTap: () {
        // Add what you want to do on tap
        debugPrint('${widget.evento.usuarioNombre}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShowPerfil(usuarioId: widget.evento.usuarioID)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ["", null, false, 0].contains(widget.evento.usuarioUrlImagen)
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: color.primary,
                              ),
                              shape: BoxShape.circle),
                          child: const CustomImage(
                            'assets/images/placeholder.png',
                            isNetwork: false,
                            width: 30,
                            height: 30,
                            bgColor: color.appBarColor,
                            //radius: 100,
                            /* 
                            borderColor: Colors.transparent,
                            trBackground: false, */
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: color.primary,
                              ),
                              shape: BoxShape.circle),
                          child: CustomImage(
                            widget.evento.usuarioUrlImagen,
                            isNetwork: true,
                            width: 30,
                            height: 30,
                            //radius: 100,
                          ),
                        ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.evento.usuarioNombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: color.bottomBarColor),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  _showMap() {
    debugPrint('mapa');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EventoDireccion(
                direccionEvento: widget.evento.direccionEvento!,
              )),
    );
  }

  _showComment() {
    debugPrint('comentarios');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EventoDireccion(
                direccionEvento: widget.evento.direccionEvento!,
              )),
    );
  }
}
