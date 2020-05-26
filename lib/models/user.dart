// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
    String id;
    String email;
    bool active;
    String fullName;
    // String lname;
    String phoneNumber;
    String designation;
    String companyId;
    String businessName;

    User({
        this.id,
        this.email,
        this.active,
        this.fullName,
        // this.lname,
        this.phoneNumber,
        this.designation,
        this.companyId,
        this.businessName,
    });

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        active: json["active"],
        fullName: json["fullName"],
        // lname: json["lname"],
        phoneNumber: json["phoneNumber"],
        designation: json["designation"],
        businessName: json["businessName"],
        companyId: json["companyId"].toString(),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "active": active,
        "fullName": fullName,
        // "lname": lname,
        "phoneNumber": phoneNumber,
        "designation": designation,
        "companyId": companyId,
        "businessName": businessName,
    };
}
