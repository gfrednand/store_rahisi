// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

// Payment paymentFromJson(String str) => Payment.fromMap(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toMap());

class Payment {
  String id;
  String supplierId;
  String method;
  String type;
  String purchaseId;
  double amount;
  String note;

  Payment({
    this.id,
    this.supplierId,
    this.method,
    this.type,
    this.purchaseId,
    this.amount,
    this.note,
  });

  factory Payment.fromMap(Map<String, dynamic> json, String id) => Payment(
        id: id ?? '',
        supplierId: json["supplierId"],
        method: json["method"],
        type: json["type"],
        purchaseId: json["purchaseId"],
        amount: json["amount"],
        note: json["note"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "supplierId": supplierId,
        "method": method,
        "type": type,
        "purchaseId": purchaseId,
        "amount": amount,
        "note": note,
      };
}
