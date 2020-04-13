// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

// Payment paymentFromJson(String str) => Payment.fromMap(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toMap());

class Payment {
  String id;
  String clientId;
  String method;
  String type;
  String referenceNo;
  double amount;
  String note;
  String userId;
  Payment({
    this.id,
    this.userId,
    this.clientId,
    this.method,
    this.type,
    this.referenceNo,
    this.amount,
    this.note,
  });

  factory Payment.fromMap(Map<String, dynamic> json, String id) => Payment(
        id: id ?? '',
        clientId: json["clientId"],
        userId: json["userId"],
        method: json["method"],
        type: json["type"],
        referenceNo: json["purchaseId"],
        amount: json["amount"],
        note: json["note"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "clientId": clientId,
        "userId": userId,
        "method": method,
        "type": type,
        "purchaseId": referenceNo,
        "amount": amount,
        "note": note,
      };
}
