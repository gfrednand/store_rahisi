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
    String fname;
    String lname;
    String phoneNumber;
    String designation;
    String companyId;

    User({
        this.id,
        this.email,
        this.active,
        this.fname,
        this.lname,
        this.phoneNumber,
        this.designation,
        this.companyId,
    });

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        active: json["active"],
        fname: json["fname"],
        lname: json["lname"],
        phoneNumber: json["phoneNumber"],
        designation: json["designation"],
        companyId: json["companyId"].toString(),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "active": active,
        "fname": fname,
        "lname": lname,
        "phoneNumber": phoneNumber,
        "designation": designation,
        "companyId": companyId,
    };
}
