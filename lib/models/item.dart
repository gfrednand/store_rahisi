// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String createdAt;
  String updatedAt;
  int alertQty;
  int openingStock;
  int quantity;
  String userId;
  int totalPurchase;
  int totalSales;
  int inStock;

  bool active;

  Item({
    this.id,
    this.userId,
    @required this.name,
    this.category,
    String createdAt,
    this.updatedAt,
    this.unit,
    this.description,
    this.salePrice,
    this.purchasePrice,
    this.paidAmount,
    this.alertQty,
    this.totalPurchase,
    this.totalSales,
    this.inStock,
    this.openingStock,
    this.quantity,
    this.active,
  }) : this.createdAt = createdAt ??
            new DateFormat('MMM dd, yyyy HH:mm').format(new DateTime.now());

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;

    return Item(
      id: doc.documentID,
      userId: json['userId'],
      name: json['name'],
      category: json['category'],
      unit: json['unit'],
      description: json['description'],
      salePrice: json['salePrice']?.toDouble(),
      purchasePrice: json['purchasePrice']?.toDouble(),
      paidAmount: json['paidAmount']?.toDouble(),
      alertQty: json['alertQty'],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      openingStock: json['openingStock'],
      quantity: json['quantity'],
      active: json['active'],
    );
  }

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
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
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
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        'openingStock': openingStock,
        'quantity': quantity,
        'active': active,
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
}
