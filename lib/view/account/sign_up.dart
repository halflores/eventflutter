import 'dart:async';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/utils/helper.dart';
import 'package:eventflutter/view/account/account_page.dart';
import 'package:eventflutter/view/account/sign_in.dart';
import 'package:image_picker/image_picker.dart';

File? _image;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ImagePicker? _imagePicker = ImagePicker();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? _nombre, _apellido, _correo, _celular, _firma;
  bool _obscureText = true;
  late Usuario user;
  bool _isInAsyncCall = false;
  final _deley = Deley(milliseconds: 2000);
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _nombre = '';
    _image = null;
    _apellido = '';
    _correo = '';
    _celular = '';
    _firma = '';

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext contextBuild) {
    return Scaffold(
/*       appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ), */
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
/*           if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AccountPage()));

            const AccountPage();
          } */
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
              return ModalProgressHUD(
                  inAsyncCall: _isInAsyncCall,
                  opacity: 0.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
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
                                        'Registro de usuario',
                                        style: TextStyle(
                                            color: color.mainColor,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          top: 32,
                                          right: 8,
                                          bottom: 8),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 65,
                                            backgroundColor:
                                                Colors.grey.shade400,
                                            child: ClipOval(
                                              child: SizedBox(
                                                width: 170,
                                                height: 170,
                                                child: _image == null
                                                    ? Image.asset(
                                                        'assets/images/placeholder.png',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        _image!,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 80,
                                            right: 0,
                                            child: FloatingActionButton(
                                                backgroundColor: color.primary,
                                                child: const Icon(
                                                    Icons.camera_alt),
                                                mini: true,
                                                onPressed: _onCameraClick),
                                          )
                                        ],
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.0, right: 8.0, left: 8.0),
                                        child: Text(
                                          "Nombre:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: color.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: double.infinity),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0,
                                                right: 8.0,
                                                left: 8.0),
                                            child: TextFormField(
                                                initialValue: _nombre,
                                                validator: validateName,
                                                onSaved: (String? val) {
                                                  _nombre = val;
                                                },
                                                maxLength: 15,
                                                textInputAction: TextInputAction
                                                    .next,
                                                onFieldSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .nextFocus(),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 8,
                                                            horizontal: 16),
                                                    fillColor: Colors.white,
                                                    hintText: 'Nombre',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: color
                                                                        .primary,
                                                                    width:
                                                                        2.0)),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ))))),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.0, right: 8.0, left: 8.0),
                                        child: Text(
                                          "Apellido:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: color.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: double.infinity),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0,
                                                right: 8.0,
                                                left: 8.0),
                                            child: TextFormField(
                                                //initialValue: _usuario!.apellido,
                                                validator: validateLastName,
                                                onSaved: (String? val) {
                                                  _apellido = val;
                                                },
                                                maxLength: 15,
                                                textInputAction: TextInputAction
                                                    .next,
                                                onFieldSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .nextFocus(),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 8,
                                                            horizontal: 16),
                                                    fillColor: Colors.white,
                                                    hintText: 'Apellido',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: color
                                                                        .primary,
                                                                    width:
                                                                        2.0)),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ))))),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.0, right: 8.0, left: 8.0),
                                        child: Text(
                                          "Correo:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: color.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 8.0, left: 8.0),
                                        child: TextFormField(
                                            textAlignVertical: TextAlignVertical
                                                .center,
                                            textInputAction: TextInputAction
                                                .next,
                                            controller: _emailController,
                                            validator: (value) {
                                              return value != null &&
                                                      !EmailValidator.validate(
                                                          value)
                                                  ? 'Ingrese un correo válido!'
                                                  : null;
                                            },
                                            onSaved: (String? val) {
                                              _correo = val!;
                                            },
                                            onFieldSubmitted: (_) => FocusScope
                                                    .of(context)
                                                .nextFocus(),
                                            style: const TextStyle(
                                                fontSize: 18.0),
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            cursorColor: color.mainColor,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 16, right: 16),
                                                fillColor: color.appBgColor,
                                                hintText: 'Correo electrónico',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: color
                                                                    .mainColor,
                                                                width: 2.0)),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ))),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.0, right: 8.0, left: 8.0),
                                        child: Text(
                                          "Celular:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: color.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: double.infinity),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0,
                                                right: 8.0,
                                                left: 8.0),
                                            child: TextFormField(
                                                //initialValue: _usuario!.celular,
                                                keyboardType: TextInputType
                                                    .phone,
                                                textInputAction: TextInputAction
                                                    .next,
                                                onFieldSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .nextFocus(),
                                                validator: validateMobile,
                                                onSaved: (String? val) {
                                                  _celular = val;
                                                },
                                                maxLength: 8,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 8,
                                                            horizontal: 16),
                                                    fillColor: Colors.white,
                                                    hintText: 'Número móvil',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: color
                                                                        .primary,
                                                                    width:
                                                                        2.0)),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ))))),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: double.infinity),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 8.0, left: 8.0),
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
                                              _firma = val!;
                                            },
                                            onFieldSubmitted: (password) async {
                                              _deley.run(() async {
                                                _createAccountWithEmailAndPassword(
                                                    contextBuild);
                                              });

                                              /*     Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignIn(
                                                            origen: 'register',
                                                          ))); */
                                              //Navigator.of(contextBuild).pop();
                                            },
                                            obscureText: _obscureText,
                                            textInputAction:
                                                TextInputAction.done,
                                            style:
                                                const TextStyle(fontSize: 18.0),
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
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                color.mainColor,
                                                            width: 2.0)),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
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
                                            'assets/icons/aceptar.svg',
                                            color: color.orangeDark,
                                            width: 30.0,
                                            height: 30.0,
                                          ),
                                          label: const Text(
                                            'Crear cuenta',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: color.orangeDark),
                                          ),
                                          onPressed: () {
                                            _createAccountWithEmailAndPassword(
                                                context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            side: const BorderSide(
                                                width: 2.0,
                                                color: color.mainColor),
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
                                _authenticateWithGoogle(context);
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/google.svg',
                                // color: color.orange,
                                width: 30.0,
                                height: 30.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 40.0, left: 40.0, top: 20),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 48, minWidth: double.infinity),
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
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SignIn(
                                                origen: 'register')));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 2.0, color: color.mainColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
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
                  ));
            }
            return const AccountPage();
          },
        ),
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //Para la imagen aqui se debe de convertir a tipo File y
      //temporalmente poner en usuario
      setState(() {
        _isInAsyncCall = true;
      });
      try {
        user = Usuario(
            correo: _emailController.text,
            nombre: _nombre!,
            celular: _celular!,
            apellido: _apellido!,
            active: true,
            usuarioID: '',
            token: '',
            platform: '');

        BlocProvider.of<AuthBloc>(context).add(
          SignUpRequested(
              _emailController.text, _passwordController.text, user, _image),
        );
        setState(() {
          _isInAsyncCall = false;
        });
        // Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isInAsyncCall = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No pudo actualizar usuario')));
      }
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

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });
    }
    onBackPress();
  }

  Future getCamara() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });
    }
    onBackPress();
  }

  Future<bool> onBackPress() {
/*     FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': null}); */
    Navigator.pop(context);

    return Future.value(false);
  }

  _onCameraClick() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3.5,
            color: const Color(0xff737373),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: getImage,
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: menuItems[0].color!.shade50,
                      ),
                      height: 50,
                      width: 50,
                      child: Icon(
                        menuItems[0].icons,
                        size: 20,
                        color: menuItems[0].color!.shade400,
                      ),
                    ),
                    title: Text(menuItems[0].text!),
                  ),
                  ListTile(
                    onTap: getCamara,
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: menuItems[1].color!.shade50,
                      ),
                      height: 50,
                      width: 50,
                      child: Icon(
                        menuItems[1].icons,
                        size: 20,
                        color: menuItems[1].color!.shade400,
                      ),
                    ),
                    title: Text(menuItems[1].text!),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () => dismissDialog(),
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: menuItems[4].color!.shade50,
                      ),
                      height: 50,
                      width: 50,
                      child: Icon(
                        menuItems[4].icons,
                        size: 20,
                        color: menuItems[4].color!.shade400,
                      ),
                    ),
                    title: Text(menuItems[4].text!),
                  ),
                ],
              ),
            ),
          );
        });
  }

  startTime() async {
    var _duration = const Duration(milliseconds: 200);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    startTime();
  }
}
