import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/loan.dart';
import '../models/repayment.dart';

class LoanService extends ChangeNotifier{
  final List<Loan> _loans = [];
  final Map<String, List<Repayment>> _repayments = {};

  // Interest rate settings
  double _loanInterestRate = 10.0; // default value in percent
  double _savingsInterestRate = 5.0; // default value in percent

  // Getters
  double get loanInterestRate => _loanInterestRate;
  double get savingsInterestRate => _savingsInterestRate;

  // Setters
  void setLoanInterestRate(double rate) {
    _loanInterestRate = rate;
    notifyListeners();
  }

  void setSavingsInterestRate(double rate) {
    _savingsInterestRate = rate;
    notifyListeners();
  }

  // Active loan tracking
Loan? _activeLoan;

Loan? get activeLoan => _activeLoan;

set activeLoan(Loan? loan) {
  _activeLoan = loan;
  notifyListeners();
}

  // Create a new loan
  Future<Loan> createLoan({
    required double amount,
    required double interestRate,
    required int term,
    required String termUnit,
    required DateTime startDate,
    required DateTime disbursementDate,
    String? description,
    String? borrowerId,
  }) async {
    try {
      final now = DateTime.now();
      final newLoan = Loan(
        id: 'loan_${Random().nextInt(100000)}',
        amount: amount,
        interestRate: interestRate,
        term: term,
        termUnit: termUnit,
        startDate: startDate,
        description: description ?? '',
        borrowerId: borrowerId ?? '',
        status: '',
        userName: 'Unknown User',
        createdAt: now,
        updatedAt: now,
        disbursementDate: disbursementDate,
      );
      _loans.add(newLoan);
      notifyListeners();
      return newLoan;
    } catch (e) {
      debugPrint('Error creating loan: $e');
      rethrow;
    }
  }

  // Get all loans
  Future<List<Loan>> getAllLoans({String? borrowerId}) async {
    try {
      if (borrowerId != null) {
        return _loans.where((loan) => loan.borrowerId == borrowerId).toList();
      }
      return _loans;
    } catch (e) {
      debugPrint('Error fetching loans: $e');
      rethrow;
    }
  }

  // Get a single loan by ID
  Future<Loan> getLoanById(String loanId) async {
    try {
      return _loans.firstWhere((loan) => loan.id == loanId);
    } catch (e) {
      debugPrint('Error fetching loan $loanId: $e');
      rethrow;
    }
  }

  // Update a loan
  Future<Loan> updateLoan(Loan updatedLoan) async {
    try {
      final index = _loans.indexWhere((loan) => loan.id == updatedLoan.id);
      if (index == -1) throw Exception('Loan not found');
      _loans[index] = updatedLoan;
      return updatedLoan;
    } catch (e) {
      debugPrint('Error updating loan ${updatedLoan.id}: $e');
      rethrow;
    }
  }

  // Delete a loan
  Future<void> deleteLoan(String loanId) async {
    try {
      _loans.removeWhere((loan) => loan.id == loanId);
      _repayments.remove(loanId);
    } catch (e) {
      debugPrint('Error deleting loan $loanId: $e');
      rethrow;
    }
  }

  // Calculate repayment schedule
  Future<List<Repayment>> calculateRepaymentSchedule(Loan loan) async {
    try {
      final schedule = _calculateAmortizationSchedule(loan);
      _repayments[loan.id] = schedule;
      return schedule;
    } catch (e) {
      debugPrint('Error calculating repayment schedule: $e');
      rethrow;
    }
  }

  // Record a payment
  Future<Repayment> recordPayment({
    required String loanId,
    required double amount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    try {
      final payment = Repayment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        loanId: loanId,
        dueDate: paymentDate,
        amount: amount,
        principal: amount, // Simplified
        interest: 0.0,
        remainingBalance: 0.0,
        status: 'paid',
        notes: notes,
      );
      _repayments.putIfAbsent(loanId, () => []);
      _repayments[loanId]!.add(payment);
      return payment;
    } catch (e) {
      debugPrint('Error recording payment: $e');
      rethrow;
    }
  }

  // Get all repayments for a loan
  Future<List<Repayment>> getLoanRepayments(String loanId) async {
    try {
      return _repayments[loanId] ?? [];
    } catch (e) {
      debugPrint('Error fetching repayments for loan $loanId: $e');
      rethrow;
    }
  }

  // Calculate amortization schedule (client-side)
  List<Repayment> _calculateAmortizationSchedule(Loan loan) {
    final List<Repayment> schedule = [];
    final monthlyInterestRate = loan.interestRate / 100 / 12;
    final numberOfPayments = loan.termUnit == 'months'
        ? loan.term
        : loan.term * 12;

    final monthlyPayment = loan.amount *
        monthlyInterestRate *
        pow(1 + monthlyInterestRate, numberOfPayments) /
        (pow(1 + monthlyInterestRate, numberOfPayments) - 1);

    double remainingBalance = loan.amount;
    DateTime paymentDate = loan.startDate;

    for (int i = 1; i <= numberOfPayments; i++) {
      final interestPayment = remainingBalance * monthlyInterestRate;
      final principalPayment = monthlyPayment - interestPayment;

      schedule.add(Repayment(
        id: 'calc-$i',
        loanId: loan.id,
        dueDate: paymentDate,
        amount: monthlyPayment,
        principal: principalPayment,
        interest: interestPayment,
        remainingBalance: remainingBalance - principalPayment,
        status: 'pending',
      ));

      remainingBalance -= principalPayment;
      paymentDate = DateTime(
        paymentDate.year,
        paymentDate.month + 1,
        paymentDate.day,
      );
    }

    return schedule;
  }

  // Get loan statistics (basic)
  Future<Map<String, dynamic>> getLoanStatistics() async {
    try {
      final totalLoans = _loans.length;
      final totalAmount = _loans.fold(0.0, (sum, loan) => sum + loan.amount);
      return {
        'totalLoans': totalLoans,
        'totalAmount': totalAmount,
      };
    } catch (e) {
      debugPrint('Error fetching statistics: $e');
      rethrow;
    }
  }
  // GETTERS FOR ADMIN DASHBOARD

  int get activeLoansCount => _loans.where((loan) => loan.status == 'approved').length;

  int get pendingLoansCount => _loans.where((loan) => loan.status == 'pending').length;

  List<Loan> get recentLoanApplications {
    final sorted = [..._loans]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }

  get completedLoans => null;

  get activeLoans => null;

  get pendingLoans => null;

  // Example additional method: get current settings
  Map<String, double> getInterestSettings() {
    return {
      'loanInterestRate': _loanInterestRate,
      'savingsInterestRate': _savingsInterestRate,
    };
  }

  void approveLoan(String id) {}

  void rejectLoan(String id) {}

  calculateMonthlyPayment(double d, int i) {}

  calculateTotalRepayment(double d, int i) {}
}
