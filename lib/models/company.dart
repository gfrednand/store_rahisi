// To parse this JSON data, do
//
//     final company = companyFromMap(jsonString);

import 'dart:convert';

class Company {
    Company({
        this.id,
        this.name,
    });

    String id;
    String name;
    String memberCount;

    Company copyWith({
        String id,
        String name,
    }) => 
        Company(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
    };
}
