class Categoria {
  int id;
  String nombre;

  Categoria({
    required this.id,
    required this.nombre
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}