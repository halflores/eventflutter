import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/evento_item.dart';
import 'package:eventflutter/widgets/custom_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class PopularItem extends StatelessWidget {
  PopularItem(
      {Key? key,
      required this.data,
      required this.index,
      this.onTap,
      this.raduis = 20})
      : super(key: key);
  final EventoItem data;
  final int index;

  final double raduis;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 350,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(raduis)),
        child: Hero(
          tag: data.urlPortada!,
          child: Stack(
            children: [
              CustomImage(
                data.urlThumbnail!,
                radius: raduis,
                isNetwork: true,
                width: double.infinity,
                height: double.infinity,
              ),
              // Preview(data.urlPortada),
              /*            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.memory(
                  data.urlThumbnail!,
                  fit: BoxFit.cover,
                ),
              ), */
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(raduis),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(.5),
                          Colors.white.withOpacity(.01),
                        ])),
              ),
              Positioned(
                bottom: 12,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.grupo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        /*  SvgPicture.asset(
                          "assets/icons/tag-dollar.svg",
                          width: 17,
                          height: 17,
                          color: Colors.white,
                        ), */
/*                         const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          data.visto.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ), */
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          data.direccionEvento!.state!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? fileName;
  _getFileImage(String url) async {
    await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    ).then((value) => fileName = value);
    return fileName;
  }
}
