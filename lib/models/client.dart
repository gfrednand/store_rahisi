// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

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
  });

  factory Client.fromMap(Map<String, dynamic> json, String id) => Client(
        id: id ?? '',
        companyName: json["companyName"] ?? '',
        clientType: json["clientType"] ?? '',
        proviousDue: json["proviousDue"] ?? '',
        accountNo: json["accountNo"] ?? '',
        userId: json["userId"] ?? '',
        active: json["active"],
        contactPerson: json["contactPerson"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        email: json["email"] ?? '',
        address: json["address"] ?? '',
        description: json["description"] ?? '',
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
      };
}
