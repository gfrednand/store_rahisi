// To parse this JSON data, do
//
//     final supplier = supplierFromJson(jsonString);

import 'dart:convert';

// Supplier supplierFromJson(String str) => Supplier.fromMap(json.decode(str));

String supplierToJson(Supplier data) => json.encode(data.toMap());

class Supplier {
  String id;
  String name;
  bool active;
  String contactPerson;
  String phoneNumber;
  String email;
  String address;
  String description;

  Supplier({
    this.id,
    this.name,
    this.active,
    this.contactPerson,
    this.phoneNumber,
    this.email,
    this.address,
    this.description,
  });

  factory Supplier.fromMap(Map<String, dynamic> json, String id) => Supplier(
        id: id ?? '',
        name: json["name"] ?? '',
        active: json["active"],
        contactPerson: json["contactPerson"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        email: json["email"] ?? '',
        address: json["address"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "active": active,
        "contactPerson": contactPerson,
        "phoneNumber": phoneNumber,
        "email": email,
        "address": address,
        "description": description,
      };
}
