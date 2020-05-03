// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:storeRahisi/constants/app_constants.dart';

// Client clientFromJson(String str) => Client.fromMap(json.decode(str));

String clientToJson(Client data) => json.encode(data.toMap());

class Client {
  String id;
  String userId;
  String companyName;
  bool active;
  String contactPerson;
  String phoneNumber;
  String email;
  String address;
  String description;
  String clientType;
  double proviousDue;
  String accountNo;
  String createdAt;
  String updatedAt;

  Client({
    this.id,
    this.userId,
    this.companyName,
    this.clientType,
    this.proviousDue,
    this.accountNo,
    this.active,
    this.contactPerson,
    this.phoneNumber,
    this.email,
    this.address,
    this.description,
    String createdAt,
    this.updatedAt,
  }) : this.createdAt = createdAt ??
            new DateFormat('MMM dd, yyyy HH:mm').format(new DateTime.now());

  factory Client.fromMap(Map<String, dynamic> json, String id) => Client(
        id: id ?? '',
        companyName: json["companyName"] ?? '',
        clientType: json["clientType"] ?? '',
        proviousDue: json["proviousDue"]?.toDouble() ?? '',
        accountNo: json["accountNo"] ?? '',
        userId: json["userId"] ?? '',
        active: json["active"],
        contactPerson: json["contactPerson"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        email: json["email"] ?? '',
        address: json["address"] ?? '',
        description: json["description"] ?? '',
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "companyName": companyName,
        "clientType": clientType,
        "proviousDue": proviousDue,
        "accountNo": accountNo,
        "userId": userId,
        "active": active,
        "contactPerson": contactPerson,
        "phoneNumber": phoneNumber,
        "email": email,
        "address": address,
        "description": description,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
  factory Client.defaultCustomer() => Client(
        id: 'd-01ef-01au-01lt-01ID',
        companyName: 'Default Company',
        clientType: AppConstants.clientTypeCustomer,
        proviousDue: 0.0,
        accountNo: '',
        userId: '',
        active: true,
        contactPerson: 'default customer',
        phoneNumber: '000000000',
        email: 'default@mail.com',
        address: '',
        description: '',
        createdAt: '',
        updatedAt: '',
      );
}
