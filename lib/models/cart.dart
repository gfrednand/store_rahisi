// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromMap(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toMap());

class Cart {
    String itemId;
    int quantity;
    double price;

    Cart({
        this.itemId,
        this.quantity,
        this.price,
    });

    factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        itemId: json["itemId"],
        quantity: json["quantity"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "itemId": itemId,
        "quantity": quantity,
        "price": price,
    };
}
