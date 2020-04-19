// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

Transaction transactionFromJson(String str) => Transaction.fromMap(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toMap());

class Transaction {
    String id;
    String referenceNo;
    String clientId;
    String transactionType;
    int totalCostPrice;
    double discount;
    int total;
    int invoiceTax;
    int totalTax;
    int laborCost;
    double netTotal;
    double paid;
    int changeAmount;
    bool transactionReturn;
    String createdAt;

    Transaction({
        this.id,
        this.referenceNo,
        this.clientId,
        this.transactionType,
        this.totalCostPrice,
        this.discount,
        this.total,
        this.invoiceTax,
        this.totalTax,
        this.laborCost,
        this.netTotal,
        this.paid,
        this.changeAmount,
        this.transactionReturn,
        this.createdAt,
    });

    factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        referenceNo: json["referenceNo"],
        clientId: json["clientId"],
        transactionType: json["transactionType"],
        totalCostPrice: json["totalCostPrice"],
        discount: json["discount"].toDouble(),
        total: json["total"],
        invoiceTax: json["invoiceTax"],
        totalTax: json["totalTax"],
        laborCost: json["laborCost"],
        netTotal: json["netTotal"].toDouble(),
        paid: json["paid"].toDouble(),
        changeAmount: json["changeAmount"],
        transactionReturn: json["return"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "referenceNo": referenceNo,
        "clientId": clientId,
        "transactionType": transactionType,
        "totalCostPrice": totalCostPrice,
        "discount": discount,
        "total": total,
        "invoiceTax": invoiceTax,
        "totalTax": totalTax,
        "laborCost": laborCost,
        "netTotal": netTotal,
        "paid": paid,
        "changeAmount": changeAmount,
        "return": transactionReturn,
        "createdAt": createdAt,
    };
}
