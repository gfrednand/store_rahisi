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
  int salePrice;
  double purchasePrice;
  int alertQty;
  int openingStock;
  String userId;

  bool active;

  Item({
    this.id,
    @required this.userId,
    @required this.name,
    this.category,
    this.unit,
    this.description,
    this.salePrice,
    this.purchasePrice,
    this.alertQty,
    this.openingStock,
    this.active,
  });

  factory Item.fromMap(Map<String, dynamic> json, String id) => Item(
        id: id ?? '',
        userId: json['userId'],
        name: json['name'],
        category: json['category'],
        unit: json['unit'],
        description: json['description'],
        salePrice: json['salePrice'],
        purchasePrice: json['purchasePrice'].toDouble(),
        alertQty: json['alertQty'],
        openingStock: json['openingStock'],
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
        'alertQty': alertQty,
        'openingStock': openingStock,
        'active': active,
      };
}
