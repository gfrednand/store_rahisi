// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromMap(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toMap());

class Cart {
    String itemId;
    int quantity;
    double paidAmount;

    Cart({
        this.itemId,
        this.quantity,
        this.paidAmount,
    });

    factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        itemId: json["itemId"],
        quantity: json["quantity"],
        paidAmount: json["paidAmount"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "itemId": itemId,
        "quantity": quantity,
        "paidAmount": paidAmount,
    };
}
