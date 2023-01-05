import 'dart:io';

//import 'package:image_picker/image_picker.dart';

class ImageUpload {
  String? id;
  bool? isUploaded;
  bool? uploading;
  // PickedFile? imageFile;
  File? imageTipoFile;
  String? imageUrl;

  ImageUpload({
    this.id,
    this.isUploaded,
    this.uploading,
    //  this.imageFile,
    this.imageTipoFile,
    this.imageUrl,
  });
}
