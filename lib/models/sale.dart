// To parse this JSON data, do
//
//     final sale = saleFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:storeRahisi/models/index.dart';

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
  double paidAmount;
  String referenceNumber;
  String userId;
  String clientId;
  String companyName;
  DateTime saleDate;
  List<Item> items;

  Sale({
    this.id,
    this.active,
    this.subTotal,
    this.discount,
    this.tax,
    this.grandTotal,
    this.paidAmount,
    this.companyName,
    this.paymentMethod,
    String referenceNumber,
    this.userId,
    this.clientId,
    DateTime saleDate,
    this.items,
  })  :this.saleDate = saleDate ?? DateTime.now(),
            // new DateFormat('MMM dd, yyyy HH:mm').format(new DateTime.now()),
             this.referenceNumber = referenceNumber ??
            new DateFormat('yyyy/MM').format(new DateTime.now()) +
                'S-' +
                DateFormat('ddHHms').format(new DateTime.now());

  factory Sale.fromMap(Map<String, dynamic> json) => Sale(
        id: json["id"],
        active: json["active"],
        subTotal: json["subTotal"].toDouble(),
        discount: json["Discount"].toDouble(),
        tax: json["tax"].toDouble(),
        grandTotal: json["grandTotal"].toDouble(),
        paymentMethod: json["paymentMethod"],
        userId: json["userId"],
        clientId: json["clientId"],
        saleDate: json["saleDate"],
        items:
            List<Item>.from(json["items"].map((x) => Item.fromMap(x, x['id']))),
      );

  factory Sale.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Sale(
      id: doc.documentID,
      active: data["active"],
      subTotal: data["subTotal"].toDouble(),
      discount: data["Discount"].toDouble(),
      tax: data["tax"].toDouble(),
      grandTotal: data["grandTotal"].toDouble(),
      paymentMethod: data["paymentMethod"],
      userId: data["userId"],
      clientId: data["clientId"],
      saleDate: DateTime.tryParse(data["saleDate"].toDate().toString()),
      items:
          List<Item>.from(data["items"].map((x) => Item.fromMap(x, x['id']))),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "active": active,
        "subTotal": subTotal,
        "Discount": discount,
        "tax": tax,
        "grandTotal": grandTotal,
        "paymentMethod": paymentMethod,
        "userId": userId,
        "clientId": clientId,
        "saleDate": saleDate,
        "items": List<dynamic>.from(items.map((x) => x.toMapSale())),
      };
}
