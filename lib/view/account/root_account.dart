import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventflutter/view/account/sign_in.dart';
import 'package:eventflutter/theme/color.dart' as color;

class RootAccount extends StatelessWidget {
  const RootAccount({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //AuthBloc auth = BlocProvider.of<AuthBloc>(context);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: color.appBgColor,
          resizeToAvoidBottomInset: false,
          //        bottomNavigationBar: getBottomBar(),
          body: SignIn(origen: 'menuGrupo')),
    );
  }
}
