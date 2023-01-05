import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/grupo.dart';
import 'package:eventflutter/services/grupo_fireStore.dart';
import 'package:eventflutter/constants.dart' as constants;
import 'package:eventflutter/theme/color.dart' as color;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:eventflutter/view/account/sign_in.dart';
import 'package:eventflutter/view/evento/registrar_evento.dart';
import 'package:eventflutter/widgets/custom_image.dart';

class MenuGrupo extends StatefulWidget {
  const MenuGrupo({Key? key}) : super(key: key);

  @override
  State<MenuGrupo> createState() {
    return _MenuGrupoState();
  }
}

class _MenuGrupoState extends State<MenuGrupo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.appBgColor,
      body: StreamBuilder<auth.User?>(
          stream: auth.FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SignIn(origen: 'register');
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: color.appBarColor,
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: getAppBar(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Seleccione el grupo...',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: color.orangeDark),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(child: getCollections()),
                        ],
                      ),
                    ),
                    childCount: 1,
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget getAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Registrar evento",
              style: TextStyle(
                  color: color.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
          ],
        )),

/*         IconBox(
            child: SvgPicture.asset("assets/icons/setting.svg",
                width: 20, height: 20),
            bgColor: color.appBgColor) */
      ],
    );
  }

  getCollections() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
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
                      scrollDirection: Axis.vertical,
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(color.inActiveColor),
                      backgroundColor: color.shadowColor,
                    ),
                  );
                }
              },
            ),
          )
        ]);
  }

  Widget _buildGrupoItem(DocumentSnapshot? document) {
    if (document != null) {
      final Grupo _data =
          Grupo.fromJson(document.data() as Map<String, dynamic>);
      return Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black12, width: 2.0),
              borderRadius: BorderRadius.circular(15.0)),
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrarEvento(grupo: _data)));
/*                 Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => RegistrarEvento(grupo: _data)),
                    (Route<dynamic> route) => false); */
              },
              child: IgnorePointer(
                  child: GridTile(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: color.orangeDark,
                                          ),
                                          shape: BoxShape.circle),
                                      child: CustomImage(
                                        _data.imagen,
                                        width: 65,
                                        height: 65,
                                      ),
                                    ),
                                    Text(
                                      '  ${_data.titulo}',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Roboto',
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                /*   Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                     Text(
                                      '${item.comentario!.length < 35 ? item.comentario : item.comentario!.substring(0, 35)}...',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ), */
                              ],
                            ),
                          )))),
            ),
          ));
    } else {
      return const SizedBox.shrink();
    }
  }
}
