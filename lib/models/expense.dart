// To parse this JSON data, do
//
//     final expense = expenseFromJson(jsonString);

import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromMap(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toMap());

class Expense {
    String id;
    String date;
    bool active;
    String responsiblePerson;
    double amount;
    String category;
    String description;

    Expense({
        this.id,
        this.date,
        this.active,
        this.responsiblePerson,
        this.amount,
        this.category,
        this.description,
    });

    factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        id: json["id"],
        date: json["date"],
        active: json["active"],
        responsiblePerson: json["ResponsiblePerson"],
        amount: json["Amount"].toDouble(),
        category: json["category"],
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "date": date,
        "active": active,
        "ResponsiblePerson": responsiblePerson,
        "Amount": amount,
        "category": category,
        "description": description,
    };
}
