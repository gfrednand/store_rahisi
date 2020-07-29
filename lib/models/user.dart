import 'dart:convert';

class User {
    User({
        this.uid,
        this.email,
        this.active,
        this.fullName,
        this.phoneNumber,
        this.designation,
        this.companyId,
        this.companyName,
        this.photoUrl,
    });

    String uid;
    String email;
    bool active;
    String fullName;
    String phoneNumber;
    String designation;
    String companyId;
    String companyName;
    String photoUrl;

    User copyWith({
        String uid,
        String email,
        bool active,
        String fullName,
        String phoneNumber,
        String designation,
        String companyId,
        String companyName,
        String photoUrl,
    }) => 
        User(
            uid: uid ?? this.uid,
            email: email ?? this.email,
            active: active ?? this.active,
            fullName: fullName ?? this.fullName,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            designation: designation ?? this.designation,
            companyId: companyId ?? this.companyId,
            companyName: companyName ?? this.companyName,
            photoUrl: photoUrl ?? this.photoUrl,
        );

    factory User.fromJson(String str) => User.fromMap(jsonDecode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        uid: json["uid"] == null ? null : json["uid"],
        email: json["email"] == null ? null : json["email"],
        active: json["active"] == null ? null : json["active"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        designation: json["designation"] == null ? null : json["designation"],
        companyId: json["companyId"] == null ? null : json["companyId"].toString(),
        companyName: json["companyName"] == null ? null : json["companyName"],
        photoUrl: json["photoUrl"] == null ? null : json["photoUrl"],
    );

    Map<String, dynamic> toMap() => {
        "uid": uid == null ? null : uid,
        "email": email == null ? null : email,
        "active": active == null ? null : active,
        "fullName": fullName == null ? null : fullName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "designation": designation == null ? null : designation,
        "companyId": companyId == null ? null : companyId,
        "companyName": companyName == null ? null : companyName,
        "photoUrl": photoUrl == null ? null : photoUrl,
    };
}
