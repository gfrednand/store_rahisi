// To parse this JSON data, do
//
//     final tax = taxFromJson(jsonString);

import 'dart:convert';

Tax taxFromJson(String str) => Tax.fromMap(json.decode(str));

String taxToJson(Tax data) => json.encode(data.toMap());

class Tax {
    String id;
    String name;
    String rate;
    String type;
    String createdAt;
    String updatedAt;

    Tax({
        this.id,
        this.name,
        this.rate,
        this.type,
        this.createdAt,
        this.updatedAt,
    });

    factory Tax.fromMap(Map<String, dynamic> json) => Tax(
        id: json["id"],
        name: json["name"],
        rate: json["rate"],
        type: json["type"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "rate": rate,
        "type": type,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}


// type::: percentage/fixed