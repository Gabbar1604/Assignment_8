import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? description;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
  }) : id = id ?? const Uuid().v4();

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    String? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      type: TransactionType.values.byName(json['type']),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}

class Category {
  final String name;
  final String icon;
  final Color color;

  const Category({required this.name, required this.icon, required this.color});
}

// Predefined categories for expenses
const List<Category> expenseCategories = [
  Category(name: 'Food', icon: '🍔', color: Color(0xFFFF6B6B)),
  Category(name: 'Transport', icon: '🚗', color: Color(0xFF4ECDC4)),
  Category(name: 'Shopping', icon: '🛍️', color: Color(0xFFFFE66D)),
  Category(name: 'Bills', icon: '💡', color: Color(0xFFA8E6CF)),
  Category(name: 'Entertainment', icon: '🎬', color: Color(0xFFDDA0DD)),
  Category(name: 'Health', icon: '💊', color: Color(0xFF87CEEB)),
  Category(name: 'Education', icon: '📚', color: Color(0xFFFFA07A)),
  Category(name: 'Other', icon: '📦', color: Color(0xFFD3D3D3)),
];

// Predefined categories for income
const List<Category> incomeCategories = [
  Category(name: 'Salary', icon: '💰', color: Color(0xFF90EE90)),
  Category(name: 'Freelance', icon: '💻', color: Color(0xFF98FB98)),
  Category(name: 'Investment', icon: '📈', color: Color(0xFF32CD32)),
  Category(name: 'Gift', icon: '🎁', color: Color(0xFF00FA9A)),
  Category(name: 'Other', icon: '💵', color: Color(0xFF3CB371)),
];
