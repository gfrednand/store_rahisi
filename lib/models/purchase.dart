// To parse this JSON data, do
//
//     final purchase = purchaseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'index.dart';

String purchaseToJson(Purchase data) => json.encode(data.toMap());

class Purchase {
  String id;
  String purchaseDate;
  String updatedAt;
  bool active;
  String supplierId;
  String supplier;
  List<Item> items;
  double grandTotalAmount;
  double paidAmount;
  double dueAmount;
  String userId;
  Purchase(
      {this.id,
      @required this.userId,
      this.active,
      this.supplierId,
      String purchaseDate,
      this.items,
      this.grandTotalAmount,
      this.supplier,
      this.paidAmount,
      this.dueAmount,
      this.updatedAt})
      : this.purchaseDate = purchaseDate ??
            new DateFormat('yyyy-MM-dd HH:mm').format(new DateTime.now());
  // this.referenceNo = referenceNo ??
  //     DateFormat('yyyy/MM/').format(new DateTime.now()) +
  //         'P-' +
  //         Uuid().generateV4();

  factory Purchase.fromMap(Map<String, dynamic> json, String id) => Purchase(
        id: id ?? '',
        userId: json['userId'],
        active: json["active"],
        supplierId: json["supplierId"],
        purchaseDate: json["purchaseDate"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x, id))),
        grandTotalAmount: json["grandTotalAmount"],
        paidAmount: json["paidAmount"],
        dueAmount: json["dueAmount"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'userId': userId,
        "active": active,
        "supplierId": supplierId,
        "purchaseDate": purchaseDate,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "grandTotalAmount": grandTotalAmount,
        "paidAmount": paidAmount,
        "dueAmount": dueAmount,
      };
}

// class Item {
//   String itemId;
//   double quantity;
//   int purchasePrice;
//   int salePrice;

//   Item({
//     this.itemId,
//     this.quantity,
//     this.purchasePrice,
//     this.salePrice,
//   });

//   factory Item.fromMap(Map<String, dynamic> json) => Item(
//         itemId: json["itemId"],
//         quantity: json["quantity"].toDouble(),
//         purchasePrice: json["purchasePrice"],
//         salePrice: json["salePrice"],
//       );

//   Map<String, dynamic> toMap() => {
//         "itemId": itemId,
//         "quantity": quantity,
//         "purchasePrice": purchasePrice,
//         "salePrice": salePrice,
//       };
// }
