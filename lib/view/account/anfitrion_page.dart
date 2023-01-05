import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/anfitrion.dart';
import 'package:eventflutter/modelo/image_upload.dart';
import 'package:eventflutter/services/anfitrion_fireStore.dart';
import 'package:eventflutter/utils/helper.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/view/account/camera_overlay.dart';

File? _selfie;

class AnfitrionPage extends StatefulWidget {
  const AnfitrionPage({Key? key, required this.usuarioId}) : super(key: key);
  final String usuarioId;
  @override
  State<AnfitrionPage> createState() {
    return _AnfitrionPageState();
  }
}

class _AnfitrionPageState extends State<AnfitrionPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode? _validate = AutovalidateMode.disabled;

  List<Object> images = ["Add Image", "Add Image", "Add Image"];

  bool _isInAsyncCall = false;
  @override
  void initState() {
    _selfie = null;
    super.initState();
  }

  @override
  void dispose() {
    _selfie = null;

    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.appBgColor,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: const Center(
            child: CircularProgressIndicator(
                color: color.primary,
                valueColor: AlwaysStoppedAnimation<Color>(color.inActiveColor),
                backgroundColor: color.shadowColor)),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: color.appBarColor,
              pinned: true,
              snap: true,
              floating: true,
              title: getAppBar(),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: color.darker,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 16),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _validate,
                      child: formPerfilAnfitrion(context),
                    ),
                  ),
                ),
                childCount: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [],
        )),
        const SizedBox(
          width: 20.0,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
            child: TextButton(
              child: const Text(
                'Publicar perfil',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.mainColor),
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: color.appBarColor,
                //onPrimary: Colors.white,
                side: const BorderSide(color: color.orangeDark, width: 2.0),
              ),
              onPressed: () {
                debugPrint('Pressed');
                setState(() {
                  _isInAsyncCall = true;
                });
                _sendToServer(context);
              },
            ))
      ],
    );
  }

  Widget formPerfilAnfitrion(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: const Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: Text(
              "Los documentos de identidad son registrados y vistos solo por la persona del perfil, no serán vistos publicamente:",
              style: TextStyle(
                fontSize: 16.0,
                color: color.primary,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          width: _width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ],
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            height: _width,
            child: buildGridView(
                _width, 0, 'Anverso: firma, fotografia e impresión '),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          width: _width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ],
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            height: _width,
            child: buildGridView(
                _width, 1, 'Reverso: datos del titular del C.I. '),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          width: _width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ],
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            height: _width,
            child: buildGridView(_width, 2,
                'Selfie: tu foto sosteniendo tu carnet de identidad de frente (sin gorras, ni lentes)'),
          ),
        ),
      ],
    );
  }

  Widget buildGridView(double _width, int index, String descripcion) {
    if (images[index] is ImageUpload) {
      ImageUpload? uploadModel = images[index] as ImageUpload?;
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            Image.file(
              uploadModel!.imageTipoFile!,
              width: _width,
              height: _width,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: const Icon(
                  Icons.remove_circle,
                  size: 30,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    images.replaceRange(index, index + 1, ['Add Image']);
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.fromSize(
        size: const Size(56, 56),
        child: Material(
          color: color.appBgColor,
          child: InkWell(
            splashColor: Colors.green,
            onTap: () {
              if (index == 2) {
                _onSelfieClick();
              } else {
                _onCameraClick(index);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/imagen.svg",
                  fit: BoxFit.cover,
                  height: 90,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, right: 12.0, left: 12.0),
                    child: Text(
                      descripcion,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: color.primary,
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
  }

  userImage(File? _image, int _index) {
    if (_image != null) {
      setState(() {
        ImageUpload imageUpload = ImageUpload();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        //imageUpload.imageFile = _image;
        imageUpload.imageTipoFile = _image;
        imageUpload.imageUrl = '';
        images.replaceRange(_index, _index + 1, [imageUpload]);
      });
    }
  }

  _onCameraClick(int index) async {
    File? result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const TakeCameraOverlay()));

    if (result != null) {
      userImage(result, index);
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        //_selfie = File(pickedFile!.path);
        userImage(File(pickedFile!.path), 2);
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
        //_selfie = File(pickedFile!.path);
        userImage(File(pickedFile!.path), 2);
      });
    }
    onBackPress();
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  _onSelfieClick() {
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

  Future<String?> _subirAFirebaseStorage(File image, String nombre) async {
    String? profilePicUrl;

    profilePicUrl = await AnfitrionFireStore()
        .uploadAnfitrionImageToFireStorage(image, nombre);
    return profilePicUrl;
  }

  _sendToServer(BuildContext context) async {
    File? selfie;
    File? fileAnverso;
    File? fileReverso;
    /*
      ANVERSO
    */
    if (images[0] is ImageUpload) {
      ImageUpload? uploadModel = images[0] as ImageUpload?;

      if (uploadModel!.imageTipoFile == null) {
        setState(() {
          _isInAsyncCall = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Vuelva a subir la imagen de anverso!!!')));
        return;
      } else {
        fileAnverso = uploadModel.imageTipoFile!;
      }
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe subir la imagen de anverso!!!')));
      return;
    }
    /*
      REVERSO
    */
    if (images[1] is ImageUpload) {
      ImageUpload? uploadModel = images[1] as ImageUpload?;

      if (uploadModel!.imageTipoFile == null) {
        setState(() {
          _isInAsyncCall = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Vuelva a subir la imagen de reverso!!!')));
        return;
      } else {
        fileReverso = uploadModel.imageTipoFile!;
      }
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe subir la imagen de reverso!!!')));
      return;
    }

    /*
      SELFIE
    */
    if (images[2] is ImageUpload) {
      ImageUpload? uploadModel = images[2] as ImageUpload?;

      if (uploadModel!.imageTipoFile == null) {
        setState(() {
          _isInAsyncCall = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vuelva a subir tu selfie!!')));
        return;
      } else {
        selfie = uploadModel.imageTipoFile!;
      }
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe subir tu imagen selfie!!!')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // la descripción tiene un texto, entonces, crear el event
      String anfitrionId = AnfitrionFireStore.firestore
          .collection(anfitrion)
          .doc()
          .id
          .toString();

      var imgAnverso = await Future.wait(
          [_subirAFirebaseStorage(fileAnverso, 'anverso_' + anfitrionId)]);

      var imgReverso = await Future.wait(
          [_subirAFirebaseStorage(fileReverso, 'reverso_' + anfitrionId)]);

      var imgSelfie = await Future.wait(
          [_subirAFirebaseStorage(selfie, 'selfie_' + anfitrionId)]);

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String? usuarioID = _prefs.getString('usuarioID');
      String? usuarioNombre = _prefs.getString('usuarioNombre');
      String? usuarioUrlImagen = _prefs.getString('usuarioUrlImagen');

      Anfitrion modelo = Anfitrion(
          usuarioID: usuarioID!,
          anfitrionID: anfitrionId,
          fecha: Timestamp.now(),
          anverso: imgAnverso[0],
          reverso: imgReverso[0],
          selfie: imgSelfie[0],
          verificado: false);

      await AnfitrionFireStore.firestore
          .collection(anfitrion)
          .doc(anfitrionId)
          .set(modelo.toJson());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Registro exitoso!. Nos comunicaremos contigo luego de revisar la infomación.')));
      setState(() {
        _isInAsyncCall = false;
      });
      Navigator.of(context).pop();
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
