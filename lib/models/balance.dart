class Balance {
  final int user_id;
  final int saldo;

  Balance({
    required this.user_id,
    required this.saldo,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      user_id: json['user_id'],
      saldo: json['saldo'],
    );
  }
}