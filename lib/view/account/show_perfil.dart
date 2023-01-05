import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/usuario_fireStore.dart';
import 'package:eventflutter/theme/color.dart' as color;

class ShowPerfil extends StatefulWidget {
  final String usuarioId;
  const ShowPerfil({Key? key, required this.usuarioId}) : super(key: key);

  @override
  _ShowPerfilState createState() => _ShowPerfilState();
}

class _ShowPerfilState extends State<ShowPerfil> {
  late Usuario? _usuario;
  bool _loading = false;

  @override
  void initState() {
    _loading = true;
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    await UsuarioFireStore().getCurrentUser(widget.usuarioId).then((value) {
      _usuario = value;
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              color: color.darker,
            ),
          ),
          title: const Text(
            "Perfil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/images/background2.jpg",
                fit: BoxFit.cover,
                width: size.width,
                height: size.height,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 480,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 32,
                        bottom: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    AssetImage("assets/images/background2.jpg"),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _usuario!.fullName(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  /* Text(
                                    "Flutter Developer",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ), */
                                ],
                              )
                            ],
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE4395F),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 24,
                            ),
                            child: const Center(
                              child: Text(
                                "Follow",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "FRIENDS",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "2307",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "FOLLOWING",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "364",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "FOLLOWER",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "175",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                    ),
                    const Text(
                      "Friends",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 9,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 56,
                                width: 56,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/friends_" +
                                              index.toString() +
                                              ".jpg"),
                                    )));
                          }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Photos",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 12,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 160,
                                width: 110,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/images/photo_" +
                                          index.toString() +
                                          ".jpg"),
                                    )));
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
