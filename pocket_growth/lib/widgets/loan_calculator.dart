import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanCalculator {
  // Calculate monthly payment for a loan
  static double calculateMonthlyPayment({
    required double principal,
    required double annualRate,
    required int termInMonths,
  }) {
    if (principal <= 0 || annualRate <= 0 || termInMonths <= 0) return 0;
    
    final monthlyRate = annualRate / 12 / 100;
    final denominator = 1 - pow(1 + monthlyRate, -termInMonths);
    
    return principal * monthlyRate / denominator;
  }

  // Calculate total interest for a loan
  static double calculateTotalInterest({
    required double principal,
    required double annualRate,
    required int termInMonths,
  }) {
    final monthlyPayment = calculateMonthlyPayment(
      principal: principal,
      annualRate: annualRate,
      termInMonths: termInMonths,
    );
    
    return (monthlyPayment * termInMonths) - principal;
  }

  // Generate amortization schedule
  static List<Map<String, dynamic>> generateAmortizationSchedule({
    required double principal,
    required double annualRate,
    required int termInMonths,
    DateTime? startDate,
  }) {
    final schedule = <Map<String, dynamic>>[];
    final monthlyPayment = calculateMonthlyPayment(
      principal: principal,
      annualRate: annualRate,
      termInMonths: termInMonths,
    );
    final monthlyRate = annualRate / 12 / 100;
    double remainingBalance = principal;
    DateTime currentDate = startDate ?? DateTime.now();

    for (int i = 1; i <= termInMonths; i++) {
      final interestPayment = remainingBalance * monthlyRate;
      final principalPayment = monthlyPayment - interestPayment;
      remainingBalance -= principalPayment;

      // Handle potential floating point rounding errors on last payment
      if (i == termInMonths) {
        remainingBalance = 0;
      }

      schedule.add({
        'paymentNumber': i,
        'paymentDate': currentDate,
        'paymentAmount': monthlyPayment,
        'principal': principalPayment,
        'interest': interestPayment,
        'remainingBalance': remainingBalance > 0 ? remainingBalance : 0,
      });

      currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    }

    return schedule;
  }

  // Format currency for display
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(amount);
  }

  // Calculate loan affordability (how much you can borrow)
  static double calculateAffordableLoanAmount({
    required double monthlyPayment,
    required double annualRate,
    required int termInMonths,
  }) {
    if (monthlyPayment <= 0 || annualRate <= 0 || termInMonths <= 0) return 0;
    
    final monthlyRate = annualRate / 12 / 100;
    final numerator = monthlyPayment * (1 - pow(1 + monthlyRate, -termInMonths));
    
    return numerator / monthlyRate;
  }

  // Calculate how long it will take to pay off a loan with a given payment
  static int calculatePayoffPeriod({
    required double principal,
    required double annualRate,
    required double monthlyPayment,
  }) {
    if (principal <= 0 || annualRate <= 0 || monthlyPayment <= 0) return 0;
    
    final monthlyRate = annualRate / 12 / 100;
    if (monthlyPayment <= principal * monthlyRate) {
      return -1; // Payment too small to ever pay off loan
    }
    
    return (log(monthlyPayment / (monthlyPayment - principal * monthlyRate)) / 
            log(1 + monthlyRate)).ceil();
  }
}

class LoanCalculatorWidget extends StatefulWidget {
  const LoanCalculatorWidget({super.key});

  @override
  State<LoanCalculatorWidget> createState() => _LoanCalculatorWidgetState();
}

class _LoanCalculatorWidgetState extends State<LoanCalculatorWidget> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _termController = TextEditingController();

  double? monthlyPayment;
  double? totalInterest;
  List<Map<String, dynamic>>? amortizationSchedule;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final principal = double.parse(_principalController.text);
      final rate = double.parse(_rateController.text);
      final term = int.parse(_termController.text);

      final payment = LoanCalculator.calculateMonthlyPayment(
        principal: principal,
        annualRate: rate,
        termInMonths: term,
      );

      final interest = LoanCalculator.calculateTotalInterest(
        principal: principal,
        annualRate: rate,
        termInMonths: term,
      );

      final schedule = LoanCalculator.generateAmortizationSchedule(
        principal: principal,
        annualRate: rate,
        termInMonths: term,
      );

      setState(() {
        monthlyPayment = payment;
        totalInterest = interest;
        amortizationSchedule = schedule;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loan Calculator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _principalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Loan Amount'),
              validator: _validateNumber,
            ),
            TextFormField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Annual Interest Rate (%)'),
              validator: _validateNumber,
            ),
            TextFormField(
              controller: _termController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Loan Term (months)'),
              validator: _validateNumber,
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate'),
            ),

            if (monthlyPayment != null && totalInterest != null) ...[
              const SizedBox(height: 16),
              Text(
                'Monthly Payment: ${LoanCalculator.formatCurrency(monthlyPayment!)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                'Total Interest: ${LoanCalculator.formatCurrency(totalInterest!)}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              const Text(
                'Amortization Schedule:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: amortizationSchedule!.length,
                itemBuilder: (context, index) {
                  final item = amortizationSchedule![index];
                  return ListTile(
                    dense: true,
                    leading: Text('Month ${item['paymentNumber']}'),
                    title: Text(
                      'Principal: ${LoanCalculator.formatCurrency(item['principal'])}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      'Interest: ${LoanCalculator.formatCurrency(item['interest'])}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      'Balance: ${LoanCalculator.formatCurrency(item['remainingBalance'])}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) return 'Enter a number';
    final number = double.tryParse(value);
    if (number == null || number <= 0) return 'Enter a valid positive number';
    return null;
  }
}