import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/evento_item.dart';

import 'package:eventflutter/widgets/favorite_box.dart';
import 'package:eventflutter/theme/color.dart' as color;

class NewItem extends StatefulWidget {
  const NewItem({required this.data, Key? key, this.onTap, this.onTapFavorite})
      : super(key: key);
  final EventoItem data;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapFavorite;

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // EventoArchivo? _eventoArchivo;
  // bool _loading = true;
/*   _obtenerEventoArchivo() async {
    _eventoArchivo = await FireStoreAnuncioArchivo()
        .getPortadaEventoArchivo(widget.data.eventoID)
        .then((value) {
      return value;
    });
    setState(() {
      _loading = false;
    });
  } */

  @override
  void initState() {
    // _obtenerEventoArchivo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 200,
        height: 300,
        child: Stack(
          children: [
            /*       CustomImage(
              _eventoArchivo!.urlArchivo!,
              radius: 20,
              width: 200,
              height: 250,
            ), */
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                widget.data.urlPortada!,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      color: color.blue,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: color.shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 200.0,
                    height: 250.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: color.primary,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            color.inActiveColor),
                        backgroundColor: color.shadowColor,
                        value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, object, stackTrace) {
                  return Material(
                    child: Image.asset(
                      'assets/images/placeholder.jpg',
                      width: 200.0,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    clipBehavior: Clip.hardEdge,
                  );
                },
                width: 200.0,
                height: 250.0,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FavoriteBox(
                  onTap: widget.onTapFavorite,
                  isFavorited: true // data["is_favorited"],
                  ),
            ),
            Positioned(
                top: 260,
                left: 0,
                child: Text(
                  widget.data.direccionEvento!.country!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: color.darker),
                )),
            Positioned(
                top: 280,
                left: 0,
                child: Text(
                  widget.data.usuarioNombre,
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: color.textColor),
                ))
          ],
        ),
      ),
    );
  }
}
