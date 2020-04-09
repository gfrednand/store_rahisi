// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

// Item itemFromJson(String str) => Item.fromMap(json.decode(str));

String itemToJson(Item data) => json.encode(data.toMap());

class Item {
  String id;
  String name;
  String category;
  String unit;
  String description;
  double salePrice;
  double purchasePrice;
  double paidAmount;
  
  int alertQty;
  int openingStock;
  int quantity;
  String userId;

  bool active;

  Item({
    this.id,
    this.userId,
    @required this.name,
    this.category,
    this.unit,
    this.description,
    this.salePrice,
    this.purchasePrice,
    this.paidAmount,
    this.alertQty,
    this.openingStock,
    this.quantity,
    this.active,
  });

  factory Item.fromMap(Map<String, dynamic> json, String id) => Item(
        id: id ?? '',
        userId: json['userId'],
        name: json['name'],
        category: json['category'],
        unit: json['unit'],
        description: json['description'],
        salePrice: json['salePrice']?.toDouble(),
        purchasePrice: json['purchasePrice']?.toDouble(),
        paidAmount: json['paidAmount']?.toDouble(),
        alertQty: json['alertQty'],
        openingStock: json['openingStock'],
        quantity: json['quantity'],
        active: json['active'],
      );


  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'name': name,
        'category': category,
        'unit': unit,
        'description': description,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
        'paidAmount': paidAmount,
        'alertQty': alertQty,
        'openingStock': openingStock,
        'quantity': quantity,
        'active': active,
      };
  Map<String, dynamic> toMapPurchase() => {
        'id': id,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
        'paidAmount': paidAmount,
        'openingStock': openingStock,
        'quantity': quantity,
      };
}
