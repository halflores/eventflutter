class Grupo {
  String titulo;
  String imagen;

  Grupo({
    required this.titulo,
    required this.imagen,
  });

  factory Grupo.fromJson(Map<String, dynamic> parsedJson) {
    return Grupo(
      titulo: parsedJson['titulo'] ?? '',
      imagen: parsedJson['imagen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'titulo': titulo, 'imagen': imagen};
  }
}
