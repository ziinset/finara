import 'package:flutter/material.dart';

class WalletModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final double balance;
  final bool isActive;

  WalletModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.balance,
    this.isActive = false,
  });

  WalletModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    double? balance,
    bool? isActive,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
    );
  }
}
