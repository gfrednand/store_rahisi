// To parse this JSON data, do
//
//     final purchase = purchaseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storeRahisi/constants/uuid.dart';
import 'index.dart';

String purchaseToJson(Purchase data) => json.encode(data.toMap());

class Purchase {
  String id;
  String purchaseDate;
  String updatedAt;
  String referenceNumber;
  bool active;
  String clientId;
  String companyName;
  List<Item> items;
  double grandTotalAmount;
  double paidAmount;
  double dueAmount;
  String userId;
  Purchase(
      {String id,
      String referenceNumber,
      @required this.userId,
      this.active,
      this.clientId,
      String purchaseDate,
      this.items,
      this.grandTotalAmount,
      this.companyName,
      this.paidAmount,
      this.dueAmount,
      this.updatedAt})
      : this.purchaseDate = purchaseDate ??
            new DateFormat('MMM dd, yyyy HH:mm').format(new DateTime.now()),
        this.id = id ?? Uuid().generateV4(),
        this.referenceNumber = referenceNumber ??
            new DateFormat('yyyy/MM').format(new DateTime.now()) +
                'P-' +
                DateFormat('ddHHms').format(new DateTime.now());

  factory Purchase.fromMap(Map<String, dynamic> json, String id) => Purchase(
        id: json['id'],
        userId: json['userId'],
        referenceNumber: json['referenceNumber'],
        active: json["active"],
        clientId: json["clientId"],
        purchaseDate: json["purchaseDate"],
        updatedAt: json["updatedAt"],
        items:
            List<Item>.from(json["items"].map((x) => Item.fromMap(x, x['id']))),
        grandTotalAmount: json["grandTotalAmount"],
        dueAmount: json["dueAmount"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'userId': userId,
        'referenceNumber': referenceNumber,
        "active": active,
        "clientId": clientId,
        "purchaseDate": purchaseDate,
        "updatedAt": updatedAt,
        "items": List<dynamic>.from(items.map((x) => x.toMapPurchase())),
        "grandTotalAmount": grandTotalAmount,
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
