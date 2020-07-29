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
  DateTime purchaseDate;
  DateTime updatedAt;
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
      DateTime purchaseDate,
      this.items,
      this.grandTotalAmount,
      this.companyName,
      this.paidAmount,
      this.dueAmount,
      this.updatedAt})
      : this.purchaseDate = purchaseDate ?? DateTime.now(),
        // new DateFormat('MMM dd, yyyy HH:mm').format(new DateTime.now()),
        this.id = id ?? Uuid().generateV4(),
        this.referenceNumber = referenceNumber ??
            new DateFormat('yyyy/MM').format(new DateTime.now()) +
                'P-' +
                DateFormat('ddHHms').format(new DateTime.now());

  Purchase copyWith({
    String id,
    String purchaseDate,
    String updatedAt,
    String referenceNumber,
    bool active,
    String clientId,
    String companyName,
    List<Item> items,
    double grandTotalAmount,
    int paidAmount,
    double dueAmount,
    String userId,
  }) =>
      Purchase(
        id: id ?? this.id,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        updatedAt: updatedAt ?? this.updatedAt,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        active: active ?? this.active,
        clientId: clientId ?? this.clientId,
        companyName: companyName ?? this.companyName,
        items: items ?? this.items,
        grandTotalAmount: grandTotalAmount ?? this.grandTotalAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        dueAmount: dueAmount ?? this.dueAmount,
        userId: userId ?? this.userId,
      );

  factory Purchase.fromMap(Map<String, dynamic> json, String id) => Purchase(
        id: json["id"] == null ? null : json["id"],
        purchaseDate: json["purchaseDate"] == null ? null :json["purchaseDate"].toDate(),
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        referenceNumber: json["referenceNumber"] == null ? null : json["referenceNumber"],
        active: json["active"] == null ? null : json["active"],
        clientId: json["clientId"] == null ? null : json["clientId"],
        companyName: json["companyName"] == null ? null : json["companyName"],
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromMap(x,x['id']))),
        grandTotalAmount: json["grandTotalAmount"] == null ? null : json["grandTotalAmount"].toDouble(),
        paidAmount: json["paidAmount"] == null ? null : json["paidAmount"],
        dueAmount: json["dueAmount"] == null ? null : json["dueAmount"].toDouble(),
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "purchaseDate": purchaseDate == null ? null : purchaseDate,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "referenceNumber": referenceNumber == null ? null : referenceNumber,
        "active": active == null ? null : active,
        "clientId": clientId == null ? null : clientId,
        "companyName": companyName == null ? null : companyName,
        "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toMapPurchase())),
        "grandTotalAmount": grandTotalAmount == null ? null : grandTotalAmount,
        "paidAmount": paidAmount == null ? null : paidAmount,
        "dueAmount": dueAmount == null ? null : dueAmount,
        "userId": userId == null ? null : userId,
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
