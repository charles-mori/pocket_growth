import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/savings_service.dart';
import '../../services/loan_service.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _savingsAmountController = TextEditingController();
  final _savingsDurationController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _loanDurationController = TextEditingController();

  // ignore: unused_field
  int _selectedTab = 0;

  @override
  void dispose() {
    _savingsAmountController.dispose();
    _savingsDurationController.dispose();
    _loanAmountController.dispose();
    _loanDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context);
    final loanService = Provider.of<LoanService>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Financial Calculators'),
          bottom: TabBar(
            onTap: (index) {
              setState(() => _selectedTab = index);
            },
            tabs: const [
              Tab(text: 'Savings Calculator'),
              Tab(text: 'Loan Calculator'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Savings Calculator
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _savingsAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Savings Amount (UGX)',
                      border: OutlineInputBorder(),
                      prefixText: 'UGX ',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _savingsDurationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (months)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 30),
                  if (_savingsAmountController.text.isNotEmpty &&
                      _savingsDurationController.text.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Projected Savings Growth',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildCalculationRow(
                              'Principal Amount',
                              'UGX ${_savingsAmountController.text}',
                            ),
                            _buildCalculationRow(
                              'Interest Rate',
                              '${savingsService.savingsInterestRate}% p.a.',
                            ),
                            _buildCalculationRow(
                              'Duration',
                              '${_savingsDurationController.text} months',
                            ),
                            const Divider(),
                            _buildCalculationRow(
                              'Projected Interest',
                              'UGX ${_calculateInterest().toStringAsFixed(2)}',
                              isBold: true,
                            ),
                            _buildCalculationRow(
                              'Total Value',
                              'UGX ${_calculateTotalValue().toStringAsFixed(2)}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Loan Calculator
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _loanAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Loan Amount (UGX)',
                      border: OutlineInputBorder(),
                      prefixText: 'UGX ',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _loanDurationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Repayment Period (months)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 30),
                  if (_loanAmountController.text.isNotEmpty &&
                      _loanDurationController.text.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Loan Repayment Summary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildCalculationRow(
                              'Loan Amount',
                              'UGX ${_loanAmountController.text}',
                            ),
                            _buildCalculationRow(
                              'Interest Rate',
                              '${loanService.loanInterestRate}% p.a.',
                            ),
                            _buildCalculationRow(
                              'Repayment Period',
                              '${_loanDurationController.text} months',
                            ),
                            const Divider(),
                            _buildCalculationRow(
                              'Total Interest',
                              'UGX ${_calculateLoanInterest().toStringAsFixed(2)}',
                              isBold: true,
                            ),
                            _buildCalculationRow(
                              'Total Repayment',
                              'UGX ${_calculateTotalRepayment().toStringAsFixed(2)}',
                              isBold: true,
                            ),
                            _buildCalculationRow(
                              'Monthly Installment',
                              'UGX ${_calculateMonthlyPayment().toStringAsFixed(2)}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: isBold
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ],
      ),
    );
  }

  double _calculateInterest() {
    final amount = double.tryParse(_savingsAmountController.text) ?? 0;
    final months = int.tryParse(_savingsDurationController.text) ?? 0;
    final years = months / 12;
    final savingsService = Provider.of<SavingsService>(context, listen: false);
    return amount * (savingsService.savingsInterestRate / 100) * years;
  }

  double _calculateTotalValue() {
    final amount = double.tryParse(_savingsAmountController.text) ?? 0;
    return amount + _calculateInterest();
  }

  double _calculateLoanInterest() {
    final amount = double.tryParse(_loanAmountController.text) ?? 0;
    final months = int.tryParse(_loanDurationController.text) ?? 0;
    final years = months / 12;
    final loanService = Provider.of<LoanService>(context, listen: false);
    return amount * (loanService.loanInterestRate / 100) * years;
  }

  double _calculateTotalRepayment() {
    final amount = double.tryParse(_loanAmountController.text) ?? 0;
    return amount + _calculateLoanInterest();
  }

  double _calculateMonthlyPayment() {
    final months = int.tryParse(_loanDurationController.text) ?? 1;
    return _calculateTotalRepayment() / months;
  }
}