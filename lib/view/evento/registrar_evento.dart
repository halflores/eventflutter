import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/bloc/date_time/date_time_bloc.dart';
import 'package:eventflutter/bloc/map/map_bloc.dart';
import 'package:eventflutter/bloc/video/video_bloc.dart';
import 'package:eventflutter/constants.dart';
import 'package:eventflutter/modelo/evento_item.dart';
import 'package:eventflutter/modelo/grupo.dart';
import 'package:eventflutter/modelo/image_upload.dart';
import 'package:eventflutter/modelo/map_direccion.dart';
import 'package:eventflutter/services/evento_fireStore.dart';
import 'package:eventflutter/utils/helper.dart';
import 'package:eventflutter/view/evento/date_time_picker.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/view/evento/map_view.dart';
import 'package:intl/intl.dart';
import 'package:eventflutter/view/evento/video/preview.dart';
import 'package:eventflutter/view/evento/video/trimmer_view.dart';
import 'package:eventflutter/view/root_app.dart';
import 'package:eventflutter/widgets/custom_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class RegistrarEvento extends StatefulWidget {
  const RegistrarEvento({Key? key, required this.grupo}) : super(key: key);
  final Grupo grupo;
  @override
  State<RegistrarEvento> createState() {
    return _RegistrarEventoState();
  }
}

class _RegistrarEventoState extends State<RegistrarEvento>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode? _validate = AutovalidateMode.disabled;
  String? _descripcion;
  List<Object> images = ["Add Image"];

  AnimationController? _controller;
  bool _isInAsyncCall = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
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
      //resizeToAvoidBottomInset: false,
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
                      child: formEvento(context),
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
              child: const Text(
                'Publicar evento',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.mainColor),
              ),
            ))
      ],
    );
  }

  Widget formEvento(BuildContext context) {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final dateTimeBloc = BlocProvider.of<DateTimeBloc>(context);

    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        grupoSeleccionado(widget.grupo),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<VideoBloc, VideoState>(builder: (context, state) {
          return Container(
              height: 200.0,
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
                  height: 180,
                  child: state.path != null
                      ? Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: <Widget>[
                            // en vez de Image poner el preview video
                            Preview(state.path),
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
                                  videoBloc.add(ResetVideo());
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.fromSize(
                          size: const Size(56, 56),
                          child: Material(
                            color: color.appBgColor,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.video,
                                  allowCompression: false,
                                );
                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  navigator.push(
                                    MaterialPageRoute(builder: (context) {
                                      return TrimmerView(file);
                                    }),
                                  );
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/video-upload.svg",
                                    fit: BoxFit.cover,
                                    height: 156,
                                  ),
                                  const Text("Elegir vídeo invitación",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: color.mainColor,
                                      )), // <-- Text
                                ],
                              ),
                            ),
                          ),
                        )));
        }),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<MapBloc, MapState>(builder: (context, state) {
          return Container(
              height: 200.0,
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
                  height: 180,
                  child: state.bitmap != null
                      ? Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.memory(
                              state.bitmap!,
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
                                  mapBloc.add(ResetMap());
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.fromSize(
                          size: const Size(56, 56),
                          child: Material(
                            color: color.appBgColor,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MapView()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/google-map.svg",
                                    fit: BoxFit.cover,
                                    height: 156,
                                  ),
                                  const Text("Elegir ubicación",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: color.mainColor,
                                      )), // <-- Text
                                ],
                              ),
                            ),
                          ),
                        )));
        }),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<DateTimeBloc, DateTimeState>(builder: (context, state) {
          return Container(
              height: 90.0,
              width: _width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
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
                  height: 90,
                  child: state.fechaInicial != null
                      ? Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: <Widget>[
                            /** aqui poner el objeto imagen que muestre las fechas */
                            _showDateTimePicker(state),
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
                                  dateTimeBloc.add(ResetDateTime());
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.fromSize(
                          size: const Size(45, 45),
                          child: Material(
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DateTimePicker()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/icons/calendar.svg",
                                    fit: BoxFit.cover,
                                    height: 65,
                                  ),
                                  const Text("Fecha de evento",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: color.mainColor,
                                      )), // <-- Text
                                ],
                              ),
                            ),
                          ),
                        )));
        }),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          //controller: textController,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'Por favor, ingrese un texto';
            }
            return null;
          },

          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          maxLength: 202,
          decoration: const InputDecoration(
              focusColor: color.mainColor,
              labelText: 'Descripción:',
              labelStyle: TextStyle(color: color.mainColor, fontSize: 18),
              hoverColor: color.mainColor,
              hintText: 'Describa el evento ...',
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
      ],
    );
  }

  Widget grupoSeleccionado(Grupo grupo) {
    return Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black12, width: 1.0),
            borderRadius: BorderRadius.circular(5.0)),
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: InkWell(
            onTap: () {},
            child: IgnorePointer(
                child: GridTile(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(0.0),
                        child: TextButton(
                          onPressed: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: color.orangeDark,
                                        ),
                                        shape: BoxShape.circle),
                                    child: CustomImage(
                                      grupo.imagen,
                                      width: 35,
                                      height: 35,
                                    ),
                                  ),
                                  Text(
                                    '  ${grupo.titulo}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )))),
          ),
        ));
  }

  Widget buildGridView(double _width) {
    if (images[0] is ImageUpload) {
      ImageUpload? uploadModel = images[0] as ImageUpload?;
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
                    images.replaceRange(0, 0 + 1, ['Add Image']);
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
            onTap: () => _onCameraClick(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/imagen.svg",
                  fit: BoxFit.cover,
                  height: 90,
                ),
                const Text("Elegir imagen",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: color.mainColor,
                    )), // <-- Text
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

  Future<void> getImage(int index) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      userImage(File(pickedFile.path), index);
    }
    onBackPress();
  }

  Future<void> getCamara(int index) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (pickedFile != null) {
      userImage(File(pickedFile.path), index);
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

  _onCameraClick(int index) {
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
                    onTap: () => getImage(index),
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
                    onTap: () => getCamara(index),
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

  _showDateTimePicker(DateTimeState fechas) {
    var outputFormatDate = DateFormat('dd/MM/yyyy');
    String _fechaInicial = outputFormatDate.format(fechas.fechaInicial!);
    String _fechaFinal =
        outputFormatDate.format(fechas.fechaFinal ?? DateTime.now());

    String _horaInicial = fechas.horaIni;
    String _horaFinal = fechas.horaFin;

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: Text('Inicia el',
                    style: TextStyle(
                      color: color.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.5, 10, 15, 5),
                child: Icon(
                  Icons.date_range,
                  size: 23,
                  color: color.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.5, 10, 15, 5),
                child: Text(_fechaInicial,
                    style: const TextStyle(
                      color: color.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 15, 5),
                child: Icon(
                  Icons.access_time,
                  size: 23,
                  color: color.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.5, 10, 15, 5),
                child: Text(_horaInicial,
                    style: const TextStyle(
                      color: color.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
              ),
            ],
          ),
          fechas.fechaFinal == null
              ? Container()
              : Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0.5, 15, 5),
                      child: Text('finaliza ',
                          style: TextStyle(
                            color: color.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.5, 0.5, 15, 5),
                      child: Icon(
                        Icons.date_range,
                        size: 23,
                        color: color.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 15, 5),
                      child: Text(_fechaFinal,
                          style: const TextStyle(
                            color: color.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0.5, 15, 5),
                      child: Icon(
                        Icons.access_time,
                        size: 23,
                        color: color.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 15, 5),
                      child: Text(_horaFinal,
                          style: const TextStyle(
                            color: color.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future<File?> generarThumbnail(String pathVideo) async {
    //WidgetsFlutterBinding.ensureInitialized();
    Uint8List? bytes;

    bytes = await VideoThumbnail.thumbnailData(
        video: pathVideo,
        imageFormat: ImageFormat.PNG,
        maxHeight: 128,
        //maxWidth: 300,
        //timeMs: 0,
        quality: 25);

    File? imgThumbnail = await bitmapToFile(bytes);
    return imgThumbnail!;
  }

  _sendToServer(BuildContext context) async {
    // verificar si hay imagen, ubicación, fecha y texto
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final dateTimeBloc = BlocProvider.of<DateTimeBloc>(context);
    MapDireccion? direccion;
    File fileVideo;
    var fileThumbnail;

    String _fechaInicial;
    String _fechaFinal;
    String _horaInicial;
    String _horaFinal;

    //bloc del vídeo invitación
    if (videoBloc.state.path == null) {
      setState(() {
        _isInAsyncCall = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe subir un vídeo invitación!!!')));
      return;
    } else {
      fileVideo = File(videoBloc.state.path!);
      fileThumbnail =
          await Future.wait([generarThumbnail(videoBloc.state.path!)]);
    }
    //bloc del mapa
    if (mapBloc.state.latLng == null) {
      setState(() {
        _isInAsyncCall = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe elegir dirección!!!')));
      return;
    } else {
      //obtener la direccion de localizacion, region, ciudad
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            mapBloc.state.latLng!.latitude, mapBloc.state.latLng!.longitude);
        final placemark = placemarks.first;

        direccion = MapDireccion(
            latLng: mapBloc.state.latLng!,
            url: mapBloc.state.url,
            bitmap: mapBloc.state.bitmap,
            city: placemark.subLocality,
            country: placemark.country,
            postcode: placemark.postalCode,
            state: placemark.locality,
            street: placemark.street);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('reverseGeocoding $e')));
        debugPrint("reverseGeocoding $e");
        return;
      }
    }
    if (dateTimeBloc.state.fechaInicial == null) {
      setState(() {
        _isInAsyncCall = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe ingresar fecha!!!')));
      return;
    } else {
      //registrar fecha y hora
      var outputFormatDate = DateFormat('dd/MM/yyyy');
      _fechaInicial = outputFormatDate.format(dateTimeBloc.state.fechaInicial!);
      _fechaFinal = dateTimeBloc.state.fechaFinal == null
          ? ''
          : outputFormatDate.format(dateTimeBloc.state.fechaFinal!);

      _horaInicial = dateTimeBloc.state.horaIni;
      _horaFinal = dateTimeBloc.state.fechaFinal == null
          ? ''
          : dateTimeBloc.state.horaFin;
    }

/*     ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('paso'))); */
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        // la descripción tiene un texto, entonces, crear el event
        String eventoId =
            EventoFireStore.firestore.collection(eventos).doc().id.toString();

        //subir archivo de imagen de direccion al storage
        File? imgDireccion = await bitmapToFile(direccion.bitmap);

        String urlDireccion = await EventoFireStore()
            .uploadEventoArchivoToFireStorage(
                imgDireccion!, 'imgDireccion_$eventoId');
        direccion.url = urlDireccion;
        direccion.bitmap = null;

        // subir el video al storage retorna el url
        String urlPortada = await EventoFireStore()
            .uploadEventoArchivoToFireStorage(
                fileVideo, 'urlPortada_$eventoId');
        String urlThumbnail = await EventoFireStore()
            .uploadEventoArchivoToFireStorage(
                fileThumbnail[0]!, 'imgThumbnail_$eventoId');

        SharedPreferences _prefs = await SharedPreferences.getInstance();
        String? usuarioID = _prefs.getString('usuarioID');
        String? usuarioNombre = _prefs.getString('usuarioNombre');
        String? usuarioUrlImagen = _prefs.getString('usuarioUrlImagen');

        EventoItem evento = EventoItem(
            eventoID: eventoId,
            tipoEvento: 'single',
            active: true,
            grupo: widget.grupo.titulo,
            direccionEvento: direccion,
            usuarioID: usuarioID!,
            usuarioNombre: usuarioNombre!,
            usuarioUrlImagen: usuarioUrlImagen!,
            descripcion: _descripcion,
            fecha: Timestamp.now(),
            cantLikes: 0,
            urlPortada: urlPortada,
            urlThumbnail: urlThumbnail,
            fechaInicial: _fechaInicial,
            horaInicial: _horaInicial,
            fechaFinal: _fechaFinal,
            horaFinal: _horaFinal);

        await EventoFireStore.firestore
            .collection(eventos)
            .doc(eventoId)
            .set(evento.toJson());
        Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RootApp()),
            (Route<dynamic> route) => false);

        setState(() {
          _isInAsyncCall = false;
        });
      } else {
        setState(() {
          _validate = AutovalidateMode.onUserInteraction;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Problemas! $e')));
    }
  }
}
