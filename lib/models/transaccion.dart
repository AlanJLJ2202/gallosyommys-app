class Transaccion {
  int id;
  int user_id;
  int monto;
  String fecha;
  String tipo;
  String descripcion;

  Transaccion({
    required this.id,
    required this.user_id,
    required this.monto,
    required this.fecha,
    required this.tipo,
    required this.descripcion
  });

  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      id: json['id'],
      user_id: json['user_id'],
      monto: json['monto'],
      fecha: json['fecha'],
      tipo: json['tipo'],
      descripcion: json['descripcion']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'monto': monto,
      'fecha': fecha,
      'tipo': tipo,
      'descripcion': descripcion
    };
  }
}
