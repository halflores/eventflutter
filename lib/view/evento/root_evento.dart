import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventflutter/view/account/sign_in.dart';
import 'package:eventflutter/view/evento/menu_grupo.dart';

class RootEvento extends StatelessWidget {
  const RootEvento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
            if (snapshot.hasData) {
              return const MenuGrupo();
            }
            // Otherwise, they're not signed in. Show the sign in page.
            return const SignIn(origen: 'menuGrupo');
          }),
    );
  }
}
