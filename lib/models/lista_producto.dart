class ListaProducto {
  int id;
  int lista_compra_id;
  int producto_id;
  int cantidad;
  double precio_compra;
  String producto_nombre;
  String producto_descripcion;

  ListaProducto({
    required this.id,
    required this.lista_compra_id,
    required this.producto_id,
    required this.cantidad,
    required this.precio_compra,
    required this.producto_nombre,
    required this.producto_descripcion
  });

  factory ListaProducto.fromJson(Map<String, dynamic> json) {
    return ListaProducto(
      id: json['id'],
      lista_compra_id: json['lista_compra_id'],
      producto_id: json['producto_id'],
      cantidad: json['cantidad'],
      precio_compra: json['precio_compra'],
      producto_nombre: json['producto_nombre'],
      producto_descripcion: json['producto_descripcion']
    );
  }
}