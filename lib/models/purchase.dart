// To parse this JSON data, do
//
//     final purchase = purchaseFromJson(jsonString);

import 'dart:convert';

Purchase purchaseFromJson(String str) => Purchase.fromMap(json.decode(str));

String purchaseToJson(Purchase data) => json.encode(data.toMap());

class Purchase {
  String id;
  String name;
  bool active;
  String supplierId;
  String purchaseDate;
  List<Item> items;
  int grandTotalAmount;
  int paidAmount;
  double dueAmount;

  Purchase({
    this.id,
    this.name,
    this.active,
    this.supplierId,
    this.purchaseDate,
    this.items,
    this.grandTotalAmount,
    this.paidAmount,
    this.dueAmount,
  });

  factory Purchase.fromMap(Map<String, dynamic> json) => Purchase(
        id: json["id"],
        name: json["name"],
        active: json["active"],
        supplierId: json["supplierId"],
        purchaseDate: json["purchaseDate"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        grandTotalAmount: json["grandTotalAmount"],
        paidAmount: json["paidAmount"],
        dueAmount: json["dueAmount"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "active": active,
        "supplierId": supplierId,
        "purchaseDate": purchaseDate,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "grandTotalAmount": grandTotalAmount,
        "paidAmount": paidAmount,
        "dueAmount": dueAmount,
      };
}

class Item {
  String itemId;
  double quantity;
  int purchasePrice;
  int salePrice;

  Item({
    this.itemId,
    this.quantity,
    this.purchasePrice,
    this.salePrice,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        itemId: json["itemId"],
        quantity: json["quantity"].toDouble(),
        purchasePrice: json["purchasePrice"],
        salePrice: json["salePrice"],
      );

  Map<String, dynamic> toMap() => {
        "itemId": itemId,
        "quantity": quantity,
        "purchasePrice": purchasePrice,
        "salePrice": salePrice,
      };
}
