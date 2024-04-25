class ListaCompra {
  int id;
  int user_id;
  String nombre;
  String fecha;

  ListaCompra({
    required this.id,
    required this.user_id,
    required this.nombre,
    required this.fecha
  });

  factory ListaCompra.fromJson(Map<String, dynamic> json) {
    return ListaCompra(
      id: json['id'],
      user_id: json['user_id'],
      nombre: json['nombre'],
      fecha: json['fecha']
    );
  }
}