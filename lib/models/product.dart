class Product {
  int id;
  int user_id;
  String name;
  String description;
  int precio_compra;
  String? isDeleted;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;

  Product({
      required this.id,
      required this.user_id,
      required this.name,
      required this.description,
      required this.precio_compra,
      this.isDeleted,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        user_id: json['user_id'],
        name: json['name'],
        description: json['description'],
        precio_compra: json['precio_compra'],
        isDeleted: json['isDeleted'],
        createdBy: json['createdBy'],
        createdDate: json['createdDate'],
        updatedBy: json['updatedBy'],
        updatedDate: json['updatedDate']
    );
  }

}
