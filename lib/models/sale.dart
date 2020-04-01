// To parse this JSON data, do
//
//     final sale = saleFromJson(jsonString);

import 'dart:convert';

Sale saleFromJson(String str) => Sale.fromMap(json.decode(str));

String saleToJson(Sale data) => json.encode(data.toMap());

class Sale {
    String id;
    bool active;
    double subTotal;
    double discount;
    double tax;
    double grandTotal;
    String paymentMethod;
    String saleDate;
    List<Item> items;

    Sale({
        this.id,
        this.active,
        this.subTotal,
        this.discount,
        this.tax,
        this.grandTotal,
        this.paymentMethod,
        this.saleDate,
        this.items,
    });

    factory Sale.fromMap(Map<String, dynamic> json) => Sale(
        id: json["id"],
        active: json["active"],
        subTotal: json["subTotal"].toDouble(),
        discount: json["Discount"].toDouble(),
        tax: json["tax"].toDouble(),
        grandTotal: json["grandTotal"].toDouble(),
        paymentMethod: json["paymentMethod"],
        saleDate: json["saleDate"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "active": active,
        "subTotal": subTotal,
        "Discount": discount,
        "tax": tax,
        "grandTotal": grandTotal,
        "paymentMethod": paymentMethod,
        "saleDate": saleDate,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
    };
}

class Item {
    String item;
    double quantity;

    Item({
        this.item,
        this.quantity,
    });

    factory Item.fromMap(Map<String, dynamic> json) => Item(
        item: json["item"],
        quantity: json["quantity"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "item": item,
        "quantity": quantity,
    };
}
