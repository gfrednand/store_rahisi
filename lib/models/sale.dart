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
  String companyId;
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
    this.companyId,
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


                    Sale copyWith({
        String id,
        bool active,
        double subTotal,
        double discount,
        double tax,
        double grandTotal,
        String paymentMethod,
        double paidAmount,
        String referenceNumber,
        String userId,
        String clientId,
        String companyName,
        String companyId,
        String saleDate,
        List<Item> items,
    }) => 
        Sale(
            id: id ?? this.id,
            active: active ?? this.active,
            subTotal: subTotal ?? this.subTotal,
            discount: discount ?? this.discount,
            tax: tax ?? this.tax,
            grandTotal: grandTotal ?? this.grandTotal,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            paidAmount: paidAmount ?? this.paidAmount,
            referenceNumber: referenceNumber ?? this.referenceNumber,
            userId: userId ?? this.userId,
            clientId: clientId ?? this.clientId,
            companyName: companyName ?? this.companyName,
            companyId: companyId ?? this.companyId,
            saleDate: saleDate ?? this.saleDate,
            items: items ?? this.items,
        );

  factory Sale.fromMap(Map<String, dynamic> json) => Sale(
        id: json["id"] == null ? null : json["id"],
        active: json["active"] == null ? null : json["active"],
        subTotal: json["subTotal"] == null ? null : json["subTotal"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"].toDouble(),
        tax: json["tax"] == null ? null : json["tax"].toDouble(),
        grandTotal: json["grandTotal"] == null ? 0 : json["grandTotal"].toDouble(),
        paymentMethod: json["paymentMethod"] == null ? null : json["paymentMethod"],
        paidAmount: json["paidAmount"] == null ? null : json["paidAmount"].toDouble(),
        referenceNumber: json["referenceNumber"] == null ? null : json["referenceNumber"],
        userId: json["userId"] == null ? null : json["userId"],
        clientId: json["clientId"] == null ? null : json["clientId"],
        companyName: json["companyName"] == null ? null : json["companyName"],
        companyId: json["companyId"] == null ? null : json["companyId"],
        saleDate: json["saleDate"] == null ? null : json["saleDate"],
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromMap(x,x['id']))),
    );

  factory Sale.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;

    return Sale(
      id: doc.documentID,
        active: json["active"] == null ? null : json["active"],
        subTotal: json["subTotal"] == null ? null : json["subTotal"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"].toDouble(),
        tax: json["tax"] == null ? null : json[" tax"].toDouble(),
        grandTotal: json["grandTotal"] == null ? 0 : json["grandTotal"].toDouble(),
        paymentMethod: json["paymentMethod"] == null ? null : json["paymentMethod"],
        paidAmount: json["paidAmount"] == null ? null : json["paidAmount"].toDouble(),
        referenceNumber: json["referenceNumber"] == null ? null : json["referenceNumber"],
        userId: json["userId"] == null ? null : json["userId"],
        clientId: json["clientId"] == null ? null : json["clientId"],
        companyName: json["companyName"] == null ? null : json["companyName"],
        companyId: json["companyId"] == null ? null : json["companyId"],
        saleDate: json["saleDate"] == null ? null :json["saleDate"].toDate(),
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromMap(x,x['id']))),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
        "active": active == null ? null : active,
        "subTotal": subTotal == null ? null : subTotal,
        "discount": discount == null ? null : discount,
        "tax": tax == null ? null : tax,
        "grandTotal": grandTotal == null ? null : grandTotal,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "paidAmount": paidAmount == null ? null : paidAmount,
        "referenceNumber": referenceNumber == null ? null : referenceNumber,
        "userId": userId == null ? null : userId,
        "clientId": clientId == null ? null : clientId,
        "companyId": companyId == null ? null : companyId,
        "companyName": companyName == null ? null : companyName,
        "saleDate": saleDate == null ? null : saleDate,
        "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toMapSale())),
      };
}
