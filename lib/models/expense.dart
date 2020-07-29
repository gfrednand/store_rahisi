// To parse this JSON data, do
//
//     final expense = expenseFromJson(jsonString);

import 'dart:convert';

// Expense expenseFromJson(String str) => Expense.fromMap(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toMap());

class Expense {
  String id;
  DateTime date;
  bool active;
  String responsiblePerson;
  double amount;
  String description;
  String userId;

  Expense({
    this.id,
    this.userId,
    DateTime date,
    this.active,
    this.responsiblePerson,
    this.amount,
    this.description,
  }) : this.date = date ?? DateTime.now();

  factory Expense.fromMap(Map<String, dynamic> json, String id) => Expense(
        id: id ?? '',
        date: json["date"].toDate(),
        userId: json["userId"],
        active: json["active"],
        responsiblePerson: json["ResponsiblePerson"],
        amount: json["Amount"].toDouble(),
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date,
        "userId": userId,
        "active": active,
        "ResponsiblePerson": responsiblePerson,
        "Amount": amount,
        "description": description,
      };
}
