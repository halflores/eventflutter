import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/utils/helper.dart';
import 'package:eventflutter/view/account/account_page.dart';
import 'package:eventflutter/view/account/olvido_password.dart';
import 'package:eventflutter/view/account/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.origen}) : super(key: key);
  final String origen;
  @override
  State<SignIn> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _deley = Deley(milliseconds: 2000);

  AutovalidateMode _validate = AutovalidateMode.disabled;
  String email = '', password = '';
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*       appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ), */
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            if (widget.origen == 'register') {
              /*        Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AccountPage())); */

              //const AccountPage();
            } else if (widget.origen == 'menuGrupo') {
/*               Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MenuGrupo())); */
              //const MenuGrupo();
            }
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: color.primary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(color.inActiveColor),
                      backgroundColor: color.shadowColor));
            }
            if (state is UnAuthenticated) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    //reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Form(
                            key: _formKey,
                            autovalidateMode: _validate,
                            child: Column(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 32.0, right: 24.0, left: 16.0),
                                  child: Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                        color: color.mainColor,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: double.infinity),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32.0, right: 24.0, left: 24.0),
                                    child: TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        controller: _emailController,
                                        validator: (value) {
                                          return value != null &&
                                                  !EmailValidator.validate(
                                                      value)
                                              ? 'Ingrese un correo válido!'
                                              : null;
                                        },
                                        onSaved: (String? val) {
                                          email = val!;
                                        },
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                        style: const TextStyle(fontSize: 18.0),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor: color.mainColor,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16, right: 16),
                                            fillColor: color.appBgColor,
                                            hintText: 'Correo electrónico',
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: color.mainColor,
                                                    width: 2.0)),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ))),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: double.infinity),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32.0, right: 24.0, left: 24.0),
                                    child: TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: _passwordController,
                                        validator: (value) {
                                          return value != null &&
                                                  value.length < 6
                                              ? "La contraseña debe tener al menos 6 caracteres!"
                                              : null;
                                        },
                                        onSaved: (String? val) {
                                          password = val!;
                                        },
                                        onFieldSubmitted: (password) async {
                                          _authenticateWithEmailAndPassword(
                                              context);
                                        },
                                        obscureText: _obscureText,
                                        textInputAction: TextInputAction.done,
                                        style: const TextStyle(fontSize: 18.0),
                                        cursorColor: color.mainColor,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16, right: 16),
                                            fillColor: Colors.white,
                                            hintText: 'Contraseña',
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  _toggle();
                                                },
                                                child: Icon(
                                                  _obscureText
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: _obscureText
                                                      ? Colors.grey
                                                      : color.orangeDark,
                                                )),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: color.mainColor,
                                                    width: 2.0)),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ))),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 40.0, left: 40.0, top: 20),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minHeight: 48,
                                        minWidth: double.infinity),
                                    child: OutlinedButton.icon(
                                      icon: SvgPicture.asset(
                                        'assets/icons/signIn.svg',
                                        color: color.orangeDark,
                                        width: 30.0,
                                        height: 30.0,
                                      ),
                                      label: const Text(
                                        'Iniciar sesión',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: color.orangeDark),
                                      ),
                                      onPressed: () {
                                        _authenticateWithEmailAndPassword(
                                            context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 2.0, color: color.mainColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 40.0, left: 40.0, top: 20),
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minHeight: 48, minWidth: double.infinity),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.red, // foreground
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OlvidoPassword()));
                                },
                                child: const Text(
                                  'Olvidó su contraseña?',
                                  style: TextStyle(
                                      color: color.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "También puedes iniciar con ...",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color.orangeDark),
                        ),
                        IconButton(
                          onPressed: () {
                            _deley.run(() async {
                              _authenticateWithGoogle(context);
                            });
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/google.svg',
                            // color: color.orange,
                            width: 30.0,
                            height: 30.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 40.0, left: 40.0, top: 20),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                minHeight: 48, minWidth: double.infinity),
                            child: OutlinedButton.icon(
                              icon: SvgPicture.asset(
                                'assets/icons/registrar.svg',
                                color: color.orangeDark,
                                width: 30.0,
                                height: 30.0,
                              ),
                              label: const Text(
                                'Regístrate',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: color.orangeDark),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    width: 2.0, color: color.mainColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const AccountPage();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}
