import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/usuario_fireStore.dart';
import 'package:eventflutter/utils/helper.dart';
import 'package:eventflutter/theme/color.dart' as color;

File? _image;

/* class EditarPerfil extends StatelessWidget {
  final String usuarioId;

  const EditarPerfil({
    Key? key,
    required this.usuarioId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditarPerfilPage(usuarioId: usuarioId);
  }
} */

class EditarPerfilPage extends StatefulWidget {
  final String usuarioId;

  const EditarPerfilPage({Key? key, required this.usuarioId}) : super(key: key);

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  late Usuario? _usuario;
  final ImagePicker? _imagePicker = ImagePicker();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState>? _key = GlobalKey();
  AutovalidateMode? _validate = AutovalidateMode.disabled;
  String? _nombre, _apellido, _correo, _celular, _firma;
  String? _descripcion;
  bool _loading = true;
  File? imageFile;
  bool _isInAsyncCall = false;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // initializing states
    fetchData();
    super.initState();
  }

  fetchData() async {
    await UsuarioFireStore().getCurrentUser(widget.usuarioId).then((value) {
      _usuario = value;
      setState(() {
        _loading = false;
      });
    });
    await urlToFile(_usuario!.urlImagen).then((value) {
      _image = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              //size: 40.0,
              color: color.darker,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: color.appBarColor,
          title: const Text(
            "Actualizar perfil",
            style: TextStyle(
              color: color.darker,
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          progressIndicator: const Center(
              child: CircularProgressIndicator(
                  color: color.primary,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(color.inActiveColor),
                  backgroundColor: color.shadowColor)),
          child: Theme(
              data: ThemeData(primaryColor: color.primary),
              child: SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                  child: Form(
                    key: _key,
                    autovalidateMode: _validate,
                    child: formUI(),
                  ),
                ),
              )),
        ),
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _imagePicker!.retrieveLostData();

    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
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

  Widget formUI() {
    return Column(
      children: <Widget>[
/*         new Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Actualizar cuenta',
              style: TextStyle(
                  color: Color(Constants.COLOR_ACCENT_TINTE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            )), */
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade400,
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
                    child: const Icon(Icons.camera_alt),
                    mini: true,
                    onPressed: _onCameraClick),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
/*         ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: const Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: Text(
              "Presentación:",
              style: TextStyle(
                fontSize: 16.0,
                color: color.primary,
              ),
            ),
          ),
        ), */
        TextFormField(
          //controller: textController,
/*           validator: (value) {
            if (value!.trim().isEmpty) {
              return 'Por favor, ingrese un texto';
            }
            return null;
          }, */
          initialValue: _usuario!.presentacion,
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          maxLength: 202,
          decoration: const InputDecoration(
              focusColor: color.mainColor,
              labelText: 'Presentación:',
              labelStyle: TextStyle(color: color.mainColor, fontSize: 18),
              hoverColor: color.mainColor,
              hintText: 'Presentese al público...',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.mainColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.mainColor),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: color.mainColor),
              )),
          onSaved: (String? val) {
            _descripcion = val;
          },

          cursorColor: color.actionColor,
          minLines: 3,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 10,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: const Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
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
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    initialValue: _usuario!.nombre,
                    validator: validateName,
                    onSaved: (String? val) {
                      _nombre = val;
                    },
                    maxLength: 15,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'Nombre',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: color.primary, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))))),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: const Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
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
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    initialValue: _usuario!.apellido,
                    validator: validateLastName,
                    onSaved: (String? val) {
                      _apellido = val;
                    },
                    maxLength: 15,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'Apellido',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: color.primary, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))))),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: const Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
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
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    initialValue: _usuario!.celular,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validateMobile,
                    onSaved: (String? val) {
                      _celular = val;
                    },
                    maxLength: 8,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'Número móvil',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: color.primary, width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))))),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minHeight: 48, minWidth: double.infinity),
            child: OutlinedButton.icon(
              icon: SvgPicture.asset(
                'assets/icons/aceptar.svg',
                color: color.orangeDark,
                width: 30.0,
                height: 30.0,
              ),
              label: const Text(
                'Actualizar',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color.orangeDark),
              ),
              onPressed: () {
                _sendToServer(context);
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
    );
  }

  Future<String?> _subirAFirebaseStorage(File image, String usuarioId) async {
    String? profilePicUrl;

    profilePicUrl = await UsuarioFireStore()
        .uploadUserImageToFireStorage(_image!, usuarioId);
    return profilePicUrl;
  }

  _sendToServer(BuildContext contextEditar) async {
    if (_key!.currentState!.validate()) {
      _key!.currentState!.save();
      setState(() {
        _isInAsyncCall = true;
      });
      var profilePicUrl;
      try {
        /* auth.UserCredential result = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _correo.trim(), password: _firma.trim()); */
        if (_image != null) {
          profilePicUrl = await Future.wait(
              [_subirAFirebaseStorage(_image!, _usuario!.usuarioID)]);
        }

        UsuarioFireStore.firestore
            .collection(usuarios)
            .doc(_usuario!.usuarioID)
            .update({
          'nombre': _nombre!.trim(),
          'apellido': _apellido!.trim(),
          'celular': _celular!.trim(),
          'presentacion': _descripcion!.trim(),
          'urlImagen': _image != null ? profilePicUrl[0] : _usuario!.urlImagen
        });

        // solo usa usuarioId, nombre e imagen
        Usuario usuario = Usuario(
            platform: Platform.operatingSystem,
            token: _usuario!.token,
            correo: _usuario!.correo,
            nombre: _nombre!.trim(),
            celular: _celular!.trim(),
            usuarioID: _usuario!.usuarioID,
            active: true,
            apellido: _apellido!.trim(),
            finUltimoInicio: Timestamp.now(),
            presentacion: _descripcion!.trim(),
            urlImagen: _image != null ? profilePicUrl[0] : _usuario!.urlImagen);

        await setPrefUsuario(usuario);

        final authBloc = BlocProvider.of<AuthBloc>(context);
        authBloc.add(UpdateRequested(usuario));

        setState(() {
          _isInAsyncCall = false;
        });

        Navigator.of(context).pop();
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

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }
}
