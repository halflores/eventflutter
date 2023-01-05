import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/theme/color.dart';
import 'package:eventflutter/view/account/anfitrion_page.dart';
import 'package:eventflutter/view/account/editar_perfil.dart';
import 'package:eventflutter/view/account/sign_in.dart';
import 'package:eventflutter/widgets/custom_image.dart';
import 'package:eventflutter/widgets/icon_box.dart';
import 'package:eventflutter/widgets/setting_item.dart';
import 'package:eventflutter/theme/color.dart' as color;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? usuarioID;
  String? usuarioNombre;
  String? usuarioUrlImagen;
  // bool _loading = false;

  @override
  void initState() {
    debugPrint('inicializando: ');
    //_loading = true;
    //_getUsuario();
    if (usuarioID == null) {
      debugPrint('es null: ');
    } else {
      debugPrint('inicializado: ' + usuarioID!);
    }
    super.initState();
  }

/*   _getUsuario() async {
    await SharedPreferences.getInstance().then((value) {
      setState(() {
        usuarioID = value.getString('usuarioID');
        usuarioNombre = value.getString('usuarioNombre');
        usuarioUrlImagen = value.getString('usuarioUrlImagen');
        _loading = false;
      });
    });
  }
 */
  @override
  Widget build(BuildContext context) {
    //final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
        backgroundColor: appBgColor,
        resizeToAvoidBottomInset: false,
        body: buildBody());
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
              "Perfil",
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        )),
        IconBox(
            child: SvgPicture.asset("assets/icons/setting.svg",
                width: 20, height: 20),
            bgColor: appBgColor)
      ],
    );
  }

  Widget buildBody() {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            /*          Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AccountPage())); */

            //const AccountPage();
          } else if (state is UnAuthenticated) {
/*             Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignIn(origen: 'register'))); */
            //const SignIn(origen: 'register');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: appBarColor,
              pinned: true,
              snap: true,
              floating: true,
              title: getAppBar(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: color.primary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  color.inActiveColor),
                              backgroundColor: color.shadowColor));
                    } else if (state is Authenticated) {
                      if (state.usuario == null) {
                        debugPrint('sin usuario');
                        return const Text('sin usuario');
                      } else {
                        return _body(state.usuario!);
                      }
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                      debugPrint('nada');
                      return const SignIn(origen: 'register');
                    } else {
                      debugPrint('nada 2');
                      return const SignIn(origen: 'register');
                    }
                  },
                ),
                childCount: 1,
              ),
            )
          ],
        ));
  }

  _body(Usuario user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          ["", null, false, 0].contains(user.urlImagen)
              ? const CustomImage(
                  'assets/images/placeholder.png',
                  width: 80,
                  height: 80,
                  radius: 100,
                  isNetwork: false,
                )
              : CustomImage(
                  user.urlImagen!,
                  width: 80,
                  height: 80,
                  radius: 100,
                ),
          const SizedBox(
            height: 12,
          ),
          Text(
            user.fullName(),
            style: const TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            user.correo,
            style: const TextStyle(
              color: labelColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          SettingItem(
              title: "Mi perfil",
              leadingIcon: Icons.person_outline,
              leadingIconColor: blue,
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditarPerfilPage(usuarioId: user.usuarioID)));
              }),
          const SizedBox(height: 10),
          SettingItem(
              title: "Mi perfil anfitrion",
              leadingIcon: Icons.account_circle,
              leadingIconColor: red,
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AnfitrionPage(usuarioId: user.usuarioID)));
              }),
          const SizedBox(height: 10),
          SettingItem(
              title: "Appearance",
              leadingIcon: Icons.dark_mode_outlined,
              leadingIconColor: purple,
              onTap: () {}),
          const SizedBox(height: 10),
          SettingItem(
              title: "Notification",
              leadingIcon: Icons.notifications_outlined,
              leadingIconColor: orange,
              onTap: () {}),
          const SizedBox(height: 10),
          SettingItem(
              title: "Privacy",
              leadingIcon: Icons.privacy_tip_outlined,
              leadingIconColor: green,
              onTap: () {}),
          const SizedBox(height: 10),
          SettingItem(
            title: "Cerrar sesión",
            leadingIcon: Icons.logout_outlined,
            leadingIconColor: Colors.grey.shade400,
            onTap: () {
              final authBloc = BlocProvider.of<AuthBloc>(context);

              showConfirmLogout(authBloc);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  showConfirmLogout(AuthBloc bloc) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
            message: const Text("Desea cerrar sesión?"),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  bloc.add(SignOutRequested());
                  /*          BlocProvider.of<AuthBloc>(context).add(
                    SignOutRequested(),
                  ); */
                  /* Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SignIn(origen: 'register'))); */
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cerrar sesión",
                  style: TextStyle(color: actionColor),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )));
  }
}
