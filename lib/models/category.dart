class Category {
  String id;
  String name;
  String subCategoryId;

  Category({this.id, this.name, this.subCategoryId});

  factory Category.fromMap(Map<String, dynamic> json, String id) => Category(
        id: id ?? '',
        name: json["name"] ?? '',
        subCategoryId: json["subCategoryId"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "subCategoryId": subCategoryId,
      };
}
