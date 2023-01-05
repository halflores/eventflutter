import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/grupo.dart';
import 'package:eventflutter/theme/color.dart';
import 'custom_image.dart';

class CollectionBox extends StatelessWidget {
  const CollectionBox({Key? key, required this.data, this.isCardBox = true})
      : super(key: key);
  final Grupo data;
  final bool isCardBox;

  @override
  Widget build(BuildContext context) {
    return isCardBox
        ? Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: primary,
                      ),
                      shape: BoxShape.circle),
                  child: CustomImage(
                    data.imagen,
                    width: 65,
                    height: 65,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  data.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: primary,
                    ),
                    shape: BoxShape.circle),
                child: CustomImage(
                  data.imagen,
                  width: 65,
                  height: 65,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                data.titulo,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          );
  }
}
