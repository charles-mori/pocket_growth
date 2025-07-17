import 'package:flutter/material.dart';
import '../models/transaction.dart';

class SavingsService with ChangeNotifier {
  double _balance = 0.0;
  double _savingsInterestRate = 5.0; // 5% annual interest
  final List<Transaction> _transactions = [];

  double get balance => _balance;
  double get totalSavings => _balance; // In a real app, this might be different
  double get savingsInterestRate => _savingsInterestRate;
  double get projectedYearlyInterest => _balance * (_savingsInterestRate / 100);
  List<Transaction> get transactions => _transactions;

  void deposit(double amount) {
    _balance += amount;
    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'deposit',
      amount: amount,
      date: DateTime.now().toIso8601String(),
    ));
    notifyListeners();
  }

  void withdraw(double amount) {
    if (amount > _balance) {
      throw Exception('Insufficient funds');
    }
    _balance -= amount;
    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'withdrawal',
      amount: amount,
      date: DateTime.now().toIso8601String(),
    ));
    notifyListeners();
  }

  void setSavingsInterestRate(double newRate) {
    _savingsInterestRate = newRate;
    notifyListeners(); // Notifies UI to update
  }

  double calculateProjectedSavings(int months) {
    final years = months / 12;
    return _balance * (1 + (_savingsInterestRate / 100) * years);
  }
}