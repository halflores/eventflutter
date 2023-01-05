import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/view/account/sign_in.dart';

class OlvidoPassword extends StatefulWidget {
  const OlvidoPassword({Key? key}) : super(key: key);

  @override
  State<OlvidoPassword> createState() {
    return _OlvidoPasswordState();
  }
}

class _OlvidoPasswordState extends State<OlvidoPassword> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String email = '', password = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            //size: 40.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignIn(origen: 'register')));
          },
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Text(
                'Envíenos su correo electrónico!!!',
                style: TextStyle(
                    color: color.mainColor,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Text(
                'Luego revise su correo. Le enviaremos un enlace para que pueda ingresar una nueva contraseña.',
                style: TextStyle(
                    color: color.mainColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return value != null && !EmailValidator.validate(value)
                          ? 'Ingrese un correo válido!'
                          : null;
                    },
                    onSaved: (String? val) {
                      email = val!;
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: const TextStyle(fontSize: 18.0),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: color.mainColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 16, right: 16),
                        fillColor: color.appBgColor,
                        hintText: 'Correo electrónico',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: color.mainColor, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: 48, minWidth: double.infinity),
                child: OutlinedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/icons/correo.svg',
                    color: color.orangeDark,
                    width: 30.0,
                    height: 30.0,
                  ),
                  label: const Text(
                    'Enviar correo',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color.orangeDark),
                  ),
                  onPressed: () async {
                    await sendEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 2.0, color: color.mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await sendEmailToChangePassword();
      Future.delayed(const Duration(seconds: 2));

      if (isLoading == false) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SignIn(origen: 'register')));
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  sendEmailToChangePassword() async {
    try {
      _auth.sendPasswordResetEmail(email: email).then((onVal) {
        Future.delayed(const Duration(seconds: 3));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SignIn(origen: 'register')));

        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      }).catchError((onError) {
        if (onError.toString().contains("ERROR_USER_NOT_FOUND")) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuario no hallado!')));
        } else if (onError
            .toString()
            .contains("An internal error has occurred")) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tenemos un problema!')));
        }

        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No pudo enviar el enlace a su correo')));
      debugPrint(e.toString());
    }
  }
}
