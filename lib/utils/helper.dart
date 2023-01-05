import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<File?> bitmapToFile(Uint8List? _image) async {
  if (_image!.isEmpty) return null;
  // generate random number.
  var rng = Random();
  // get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
  // get temporary path from temporary directory.
  String tempPath = tempDir.path;

  // create a new file in temporary path with random file name.
  final file =
      await File(tempPath + (rng.nextInt(100)).toString() + '.png').create();
  file.writeAsBytesSync(_image);

  return file;
}

Future<void> setPrefUsuario(Usuario user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('usuarioID', user.usuarioID);
  prefs.setString('usuarioNombre', user.fullName());
  prefs.setString('usuarioToken', user.token);
  prefs.setString('usuarioUrlImagen', user.urlImagen!);
}

Widget displayImage(String? picUrl, double size, hasBorder) => picUrl == null
    ? _getPlaceholderOrErrorImage(size, false)
    : CachedNetworkImage(
        imageBuilder: (context, imageProvider) =>
            _getImageProvider(imageProvider, size, hasBorder),
        imageUrl: picUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                color: color.primary,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(color.inActiveColor),
                backgroundColor: color.shadowColor,
                value: downloadProgress.totalSize != null &&
                        downloadProgress.downloaded != 0
                    ? downloadProgress.downloaded / downloadProgress.totalSize!
                    : null,
              ),
            ),

/*         placeholder: (context, url) =>
            _getPlaceholderOrErrorImage(size, hasBorder), */
        errorWidget: (context, url, error) =>
            _getPlaceholderOrErrorImage(size, hasBorder));

Widget _getPlaceholderOrErrorImage(double size, hasBorder) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        //borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
        border: Border.all(
          color: Colors.white,
          width: hasBorder ? 2.0 : 0.0,
        ),
      ),
      child: ClipOval(
          child: Image.asset(
        'assets/images/placeholder.jpg',
        fit: BoxFit.cover,
        height: size,
        width: size,
      )),
    );

Widget _getImageProvider(ImageProvider provider, double size, bool hasBorder) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        //orderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
        border: Border.all(
          color: Colors.white,
          style: hasBorder ? BorderStyle.solid : BorderStyle.none,
          width: 1.0,
        ),
        image: DecorationImage(
          image: provider,
          fit: BoxFit.cover,
        )),
  );
}

Future<File?> urlToFile(String? imageUrl) async {
  if (imageUrl!.isEmpty) return null;
  // generate random number.
  var rng = Random();
  // get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
  // get temporary path from temporary directory.
  String tempPath = tempDir.path;
  // create a new file in temporary path with random file name.
  File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');
  // call http.get method and pass imageUrl into it to get response.
  var url = Uri.parse(imageUrl);
  http.Response response = await http.get(url);
  // write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
  // now return the file which is created with random name in
  // temporary directory and image bytes from response is written to // that file.
  return file;
}

List<SendMenuItems> menuItems = [
  SendMenuItems(
      text: "Elegir de galeria", icons: Icons.image, color: Colors.amber),
  SendMenuItems(
      text: "Tomar una foto", icons: Icons.camera_enhance, color: Colors.green),
  SendMenuItems(
      text: "Documentos", icons: Icons.insert_drive_file, color: Colors.blue),
  SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
  SendMenuItems(text: "Cancelar", icons: Icons.cancel, color: Colors.red),
];

class SendMenuItems {
  String? text;
  IconData? icons;
  MaterialColor? color;
  SendMenuItems(
      {@required this.text, @required this.icons, @required this.color});
}

Future cropImage(PickedFile image) async {
  debugPrint('antes de entrar a copper');
  // CON LAS SIGUIENTES INSTRUCCIONES APARECE
  // UNA VENTANA QUE TE PERMITE HACER RECORTE DE LA IMAGEN
  // PERO SE DEBE DE DESCOMENTAR LO SIGUIENTE EN EL ARCHIVO ANDROIDMANIFEST.XML
  /* <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/> */

/*     File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    print('despues de entrar a copper'); */
  File? croppedFile = File(image.path);

  //_listener!.userImage(croppedFile, _index!);
}

String? validateName(String? value) {
  //String pattern = r'(^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$)';
  String pattern = r"(^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$)";
  RegExp regExp = RegExp(pattern);
  //if (value!.isEmpty) {
  if (["", null, false, 0].contains(value!.trim())) {
    return "Por favor, ingrese nombre";
  } else if (!regExp.hasMatch(value)) {
    return "Por favor, solo caracteres a-z o A-Z";
  }
  return null;
}

String? validateLastName(String? value) {
  String pattern = r"(^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$)";
  RegExp regExp = RegExp(pattern);
  if (["", null, false, 0].contains(value!.trim())) {
    return null; // "Por favor, ingrese apellido";
  } else if (!regExp.hasMatch(value)) {
    return "Por favor, solo caracteres a-z o A-Z";
  }
  return null;
}

String? validateMobile(String? value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (["", null, false, 0].contains(value!.trim())) {
    return "Por favor, ingrese número de móvil";
  } else if (!regExp.hasMatch(value)) {
    return "El número móvil debe contener solo dígitos";
  }
  return null;
}

String doubleToString(String val) {
  final esFormat =
      NumberFormat.currency(locale: 'es', decimalDigits: 2, symbol: 'Bs.');

  return esFormat.format(double.parse(val));
}

double stringToDouble(String? val) {
  final esFormat = NumberFormat.decimalPattern(
    'es',
  );
  double d = esFormat.parse(val!).toDouble();
  return d;
}

String? validateMoney(String? value) {
  double money = stringToDouble(value);
  if (money == 0) {
    return "Por favor, ingrese un monto";
  } else {
    return null;
  }
}

class Deley {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Deley({this.milliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(microseconds: milliseconds ?? 400), action);
  }
}
