import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/usuario_fireStore.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/view/account/root_account.dart';
import 'package:eventflutter/view/evento/menu_grupo.dart';
import 'package:eventflutter/view/home_page.dart';
import 'package:eventflutter/widgets/bottombar_item.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;
  List barItems = [
    {
      "icon": "assets/icons/home.svg",
      "active_icon": "assets/icons/home.svg",
      "page": const HomePage(),
      "title": ""
    },
    {
      "icon": "assets/icons/search.svg",
      "active_icon": "assets/icons/search.svg",
      "page": Container(),
      "title": ""
    },
    {
      "icon": "assets/icons/add.svg",
      "active_icon": "assets/icons/add.svg",
      "page": const MenuGrupo(),
    },
    {
      "icon": "assets/icons/chat.svg",
      "active_icon": "assets/icons/chat.svg",
      "page": Container(),
    },
    {
      "icon": "assets/icons/profile.svg",
      "active_icon": "assets/icons/profile.svg",
      "page": const RootAccount(),
      "title": ""
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color.appBgColor,
        bottomNavigationBar: getBottomBar(),
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UsuarioFireStore()
                    .getCurrentUser(snapshot.data!.uid)
                    .then((usuario) {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(UpdateRequested(usuario!));
                });
              }
              return getBarPage();
            }));
  }

  void onPageChanged(int index) {
    setState(() {
      activeTab = index;
    });
  }

  Widget getBottomBar() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
          color: color.bottomBarColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: color.shadowColor.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(1, 1))
          ]),
      child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 15,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  barItems.length,
                  (index) => BottomBarItem(
                        activeTab == index
                            ? barItems[index]["active_icon"]
                            : barItems[index]["icon"],
                        "",
                        isActive: activeTab == index,
                        activeColor: color.orangeDark,
                        onTap: () {
                          onPageChanged(index);
                        },
                      )))),
    );
  }

  Widget getBarPage() {
    return IndexedStack(
        index: activeTab,
        children: List.generate(
            barItems.length, (index) => (barItems[index]["page"])));
  }
}
