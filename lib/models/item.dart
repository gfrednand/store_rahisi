// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Item itemFromJson(String str) => Item.fromMap(json.decode(str));

String itemToJson(Item data) => json.encode(data.toMap());

class Item {
  String id;
  String name;
  String categoryId;
  String category;
  String unit;
  String description;
  double salePrice;
  double purchasePrice;
  double paidAmount;
  double profit;
  String barcode;
  DateTime createdAt;
  DateTime updatedAt;
  int alertQty;
  int openingStock;
  int quantity;
  int saleQuantity;
  int purchaseQuantity;
  String userId;
  int totalPurchase;
  int totalSales;
  int inStock;

  bool active;

  Item({
    this.id,
    this.userId,
    this.name,
    this.categoryId,
    this.category,
    DateTime createdAt,
    this.updatedAt,
    this.unit,
    this.description,
    this.salePrice,
    this.purchasePrice,
    this.paidAmount,
    this.barcode,
    this.alertQty,
    this.totalPurchase,
    this.totalSales,
    this.profit,
    this.inStock,
    this.openingStock,
    this.quantity,
    this.saleQuantity,
    this.purchaseQuantity,
    this.active,
  }) :
        //  assert(name != null, 'name must not be null'),
        this.createdAt = createdAt ?? DateTime.now();
  // new DateFormat('MMM dd, yyyy HH:mm').format(new DateTime.now());

  Item copyWith({
    String id,
    String userId,
    String name,
    String categoryId,
    String category,
    DateTime createdAt,
    DateTime updatedAt,
    String unit,
    String description,
    double salePrice,
    double purchasePrice,
    double paidAmount,
    String barcode,
    int alertQty,
    String totalPurchase,
    double totalSales,
    double profit,
    int inStock,
    int openingStock,
    int quantity,
    int saleQuantity,
    int purchaseQuantity,
    bool active,
  }) =>
      Item(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        unit: unit ?? this.unit,
        description: description ?? this.description,
        salePrice: salePrice ?? this.salePrice,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        paidAmount: paidAmount ?? this.paidAmount,
        barcode: barcode ?? this.barcode,
        alertQty: alertQty ?? this.alertQty,
        totalPurchase: totalPurchase ?? this.totalPurchase,
        totalSales: totalSales ?? this.totalSales,
        profit: profit ?? this.profit,
        inStock: inStock ?? this.inStock,
        openingStock: openingStock ?? this.openingStock,
        quantity: quantity ?? this.quantity,
        saleQuantity: saleQuantity ?? this.saleQuantity,
        purchaseQuantity: purchaseQuantity ?? this.purchaseQuantity,
        active: active ?? this.active,
      );

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;
    return Item(
      id: doc.documentID,
      userId: json["userId"] == null ? null : json["userId"],
      name: json["name"] == null ? null : json["name"],
      categoryId: json["categoryId"] == null ? null : json["categoryId"],
      category: json["category"] == null ? null : json["category"],
      createdAt: json["createdAt"] == null ? null : json["createdAt"].toDate(),
      updatedAt: json["updatedAt"] == null ? null : json["updatedAt"].toDate(),
      unit: json["unit"] == null ? null : json["unit"],
      description: json["description"] == null ? null : json["description"],
      salePrice:
          json["salePrice"] == null ? null : json["salePrice"].toDouble(),
      purchasePrice: json["purchasePrice"] == null
          ? null
          : json["purchasePrice"].toDouble(),
      paidAmount:
          json["paidAmount"] == null ? null : json["paidAmount"].toDouble(),
      barcode: json["barcode"] == null ? null : json["barcode"],
      alertQty: json["alertQty"] == null ? null : json["alertQty"],
      totalPurchase:
          json["totalPurchase"] == null ? null : json["totalPurchase"],
      totalSales:
          json["totalSales"] == null ? null : json["totalSales"].toDouble(),
      profit: json["profit"] == null ? null : json["profit"].toDouble(),
      inStock: json["inStock"] == null ? null : json["inStock"],
      openingStock: json["openingStock"] == null ? null : json["openingStock"],
      quantity: json["quantity"] == null ? null : json["quantity"],
      saleQuantity: json["saleQuantity"] == null ? null : json["saleQuantity"],
      purchaseQuantity:
          json["purchaseQuantity"] == null ? null : json["purchaseQuantity"],
      active: json["active"] == null ? null : json["active"],
    );
  }

  factory Item.fromMap(Map<String, dynamic> json, String id) => Item(
        id: id ?? '',
        userId: json["userId"] == null ? null : json["userId"],
        name: json["name"] == null ? null : json["name"],
        categoryId: json["categoryId"] == null ? null : json["categoryId"],
        category: json["category"] == null ? null : json["category"],
        createdAt:
            json["createdAt"] == null ? null : json["createdAt"].toDate(),
        updatedAt:
            json["updatedAt"] == null ? null : json["updatedAt"].toDate(),
        unit: json["unit"] == null ? null : json["unit"],
        description: json["description"] == null ? null : json["description"],
        salePrice:
            json["salePrice"] == null ? null : json["salePrice"].toDouble(),
        purchasePrice: json["purchasePrice"] == null
            ? null
            : json["purchasePrice"].toDouble(),
        paidAmount:
            json["paidAmount"] == null ? null : json["paidAmount"].toDouble(),
        barcode: json["barcode"] == null ? null : json["barcode"],
        alertQty: json["alertQty"] == null ? null : json["alertQty"],
        totalPurchase:
            json["totalPurchase"] == null ? null : json["totalPurchase"],
        totalSales:
            json["totalSales"] == null ? null : json["totalSales"].toDouble(),
        profit: json["profit"] == null ? null : json["profit"].toDouble(),
        inStock: json["inStock"] == null ? null : json["inStock"],
        openingStock:
            json["openingStock"] == null ? null : json["openingStock"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        saleQuantity:
            json["saleQuantity"] == null ? null : json["saleQuantity"],
        purchaseQuantity:
            json["purchaseQuantity"] == null ? null : json["purchaseQuantity"],
        active: json["active"] == null ? null : json["active"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "userId": userId == null ? null : userId,
        "name": name == null ? null : name,
        "categoryId": categoryId == null ? null : categoryId,
        "category": category == null ? null : category,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "unit": unit == null ? null : unit,
        "description": description == null ? null : description,
        "salePrice": salePrice == null ? null : salePrice,
        "purchasePrice": purchasePrice == null ? null : purchasePrice,
        "paidAmount": paidAmount == null ? null : paidAmount,
        "barcode": barcode == null ? null : barcode,
        "alertQty": alertQty == null ? null : alertQty,
        "totalPurchase": totalPurchase == null ? null : totalPurchase,
        "totalSales": totalSales == null ? null : totalSales,
        "profit": profit == null ? null : profit,
        "inStock": inStock == null ? null : inStock,
        "openingStock": openingStock == null ? null : openingStock,
        "quantity": quantity == null ? null : quantity,
        "saleQuantity": saleQuantity == null ? null : saleQuantity,
        "purchaseQuantity": purchaseQuantity == null ? null : purchaseQuantity,
        "active": active == null ? null : active,
      };
  Map<String, dynamic> toMapPurchase() => {
        'id': id,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
        'paidAmount': paidAmount,
        'quantity': quantity,
      };
  Map<String, dynamic> toMapSale() => {
        'id': id,
        'paidAmount': paidAmount,
        'quantity': quantity,
      };

  factory Item.initialValue() => Item(
      name: 'Nothing Found',
      active: true,
      alertQty: 0,
      barcode: '',
      categoryId: '',
      description: '',
      id: '',
      inStock: 0,
      openingStock: 0,
      unit: '');
}
