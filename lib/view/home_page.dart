import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/modelo/evento_item.dart';
import 'package:eventflutter/modelo/grupo.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/evento_fireStore.dart';
import 'package:eventflutter/services/grupo_fireStore.dart';
import 'package:eventflutter/theme/color.dart';
import 'package:eventflutter/view/evento/evento_item_details.dart';
import 'package:eventflutter/widgets/collection_box.dart';
import 'package:eventflutter/widgets/custom_image.dart';
import 'package:eventflutter/widgets/new_item.dart';
import 'package:eventflutter/widgets/notification_box.dart';
import 'package:eventflutter/widgets/popular_item.dart';
import '../constants.dart' as constants;
import 'package:eventflutter/theme/color.dart' as color;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _limit = 10;
  final int _limitIncrement = 10;
  final ScrollController listScrollController = ScrollController();
  //auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBgColor,
        body: StreamBuilder<auth.User?>(
            stream: auth.FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: color.appBarColor,
                    pinned: true,
                    snap: true,
                    floating: true,
                    title: getAppBar(snapshot.data),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => buildBody(),
                      childCount: 1,
                    ),
                  )
                ],
              );
            }));
  }

  Widget getAppBar(auth.User? firebaseUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            firebaseUser == null
                ? Row(children: const [
                    CustomImage(
                      'assets/images/placeholder.png',
                      isNetwork: false,
                      width: 30,
                      height: 30,
                      radius: 100,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Invitado',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 13,
                      ),
                    )
                  ])
                : BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    if (state is Authenticated) {
                      return Row(children: [
                        ["", null, false, 0].contains(state.usuario!.urlImagen)
                            ? const CustomImage(
                                'assets/images/placeholder.png',
                                isNetwork: false,
                                width: 30,
                                height: 30,
                                radius: 100,
                              )
                            : CustomImage(
                                state.usuario!.urlImagen!,
                                isNetwork: true,
                                width: 30,
                                height: 30,
                                radius: 100,
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          state.usuario!.fullName(),
                          style: const TextStyle(
                            color: labelColor,
                            fontSize: 13,
                          ),
                        )
                      ]);
                    } else {
                      return Row(children: const [
                        CustomImage(
                          'assets/images/placeholder.png',
                          isNetwork: false,
                          width: 30,
                          height: 30,
                          radius: 100,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Invitado',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 13,
                          ),
                        )
                      ]);
                    }
                  }),
          ],
        )),
        NotificationBox(
          notifiedNumber: 1,
          onTap: () {},
        )
      ],
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 20,
          ),
          getCollections(),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
            child: Text("Popular",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                )),
          ),
          getPopulars(),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Nuevos eventos",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                Text(
                  "Ver más",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          // getNewItems(),
        ]),
      ),
    );
  }

/*   getCollections() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              collections.length,
              (index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CollectionBox(data: collections[index])))),
    );
  } */

  getCollections() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 120,
              child: StreamBuilder<QuerySnapshot>(
                stream: GrupoFireStore.firestore
                    .collection(constants.grupos)
                    .orderBy('titulo')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            'Sin grupos!!!',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: color.textColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //padding: const EdgeInsets.only(right: 10),
                        scrollDirection: Axis.horizontal,
                        //restorationId: 'listGrupo',
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildGrupoItem(snapshot.data?.docs[index])),
                        itemCount: snapshot.data?.docs.length,
                        // reverse: true,
                        //controller: listScrollController,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('Problemas al presentar los grupos'),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: color.primary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              color.inActiveColor),
                          backgroundColor: color.shadowColor),
                    );
                  }
                },
              ),
            )
          ]),
    );
  }

  Widget _buildGrupoItem(DocumentSnapshot? document) {
    if (document != null) {
      final Grupo _data =
          Grupo.fromJson(document.data() as Map<String, dynamic>);
      return CollectionBox(data: _data);
    } else {
      return const SizedBox.shrink();
    }
  }

/*   getPopulars() {
    return CarouselSlider(
        options: CarouselOptions(
          height: 370,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .75,
        ),
        items: List.generate(
          populars.length,
          (index) => PopularItem(
            data: populars[index],
            onTap: () {},
          ),
        ));
  } */

  getPopulars() {
    return StreamBuilder<QuerySnapshot>(
      stream: EventoFireStore.firestore
          .collection(constants.eventos)
          .orderBy('fecha', descending: true)
          .limit(15)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  'Sin eventos!!!',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: color.textColor,
                  ),
                ),
              ),
            );
          } else {
            return CarouselSlider.builder(
              options: CarouselOptions(
                height: 370,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: .75,
              ),
              itemBuilder: (context, index, _) =>
                  _buildPopularEventoItem(snapshot.data?.docs[index], index),
              itemCount: snapshot.data?.docs.length,
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text('Problemas al presentar los eventos'),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
                color: color.primary,
                valueColor: AlwaysStoppedAnimation<Color>(color.inActiveColor),
                backgroundColor: color.shadowColor),
          );
        }
      },
    );
  }

  Widget _buildPopularEventoItem(DocumentSnapshot? document, int index) {
    if (document != null) {
      final EventoItem _data =
          EventoItem.fromJson(document.data() as Map<String, dynamic>);
      return PopularItem(
        data: _data,
        index: index,
        onTap: () {
          _registrarVisto(_data.eventoID);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventoItemDetails(evento: _data)),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _registrarVisto(String eventoId) async {
    final DocumentReference docRef =
        EventoFireStore.firestore.collection(constants.eventos).doc(eventoId);
    docRef.update({"visto": FieldValue.increment(1)});
  }
/*   getNewItems() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              news.length,
              (index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: NewItem(
                    data: news[index],
                    onTap: () {},
                  )))),
    );
  } */

  getNewItems() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: EventoFireStore.firestore
                    .collection(constants.eventos)
                    .orderBy('fecha', descending: true)
                    .limit(15)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            'Sin eventos!!!',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: color.textColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //padding: const EdgeInsets.only(right: 10),
                        scrollDirection: Axis.horizontal,
                        //restorationId: 'listGrupo',
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child:
                                _buildEventoItem(snapshot.data?.docs[index])),
                        itemCount: snapshot.data?.docs.length,
                        // reverse: true,
                        //controller: listScrollController,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('Problemas al presentar los eventos'),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: color.primary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              color.inActiveColor),
                          backgroundColor: color.shadowColor),
                    );
                  }
                },
              ),
            )
          ]),
    );
  }

  Widget _buildEventoItem(DocumentSnapshot? document) {
    if (document != null) {
      final EventoItem _data =
          EventoItem.fromJson(document.data() as Map<String, dynamic>);
      return NewItem(data: _data);
    } else {
      return const SizedBox.shrink();
    }
  }
}
