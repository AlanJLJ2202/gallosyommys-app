class ProductCategory {
  int id;
  String name;
  String description;
  String? isDeleted;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;

  ProductCategory({
      required this.id,
      required this.name,
      required this.description,
      this.isDeleted,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        isDeleted: json['isDeleted'],
        createdBy: json['createdBy'],
        createdDate: json['createdDate'],
        updatedBy: json['updatedBy'],
        updatedDate: json['updatedDate']
    );
  }

}
