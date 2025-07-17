import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/savings_service.dart';
import '../../services/loan_service.dart';

class InterestSettingsScreen extends StatefulWidget {
  const InterestSettingsScreen({super.key});

  @override
  State<InterestSettingsScreen> createState() => _InterestSettingsScreenState();
}

class _InterestSettingsScreenState extends State<InterestSettingsScreen> {
  final _savingsRateController = TextEditingController();
  final _loanRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final savingsService = Provider.of<SavingsService>(context, listen: false);
    final loanService = Provider.of<LoanService>(context, listen: false);
    _savingsRateController.text = savingsService.savingsInterestRate.toString();
    _loanRateController.text = loanService.loanInterestRate.toString();
  }

  @override
  void dispose() {
    _savingsRateController.dispose();
    _loanRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context);
    final loanService = Provider.of<LoanService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest Rate Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Savings Interest Rate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _savingsRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Annual Interest Rate (%)',
                        border: OutlineInputBorder(),
                        suffixText: '%',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final newRate = double.tryParse(_savingsRateController.text);
                          if (newRate != null) {
                            savingsService.setSavingsInterestRate(newRate);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Savings rate updated!')),
                            );
                          }
                        },
                        child: const Text('Update Savings Rate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loan Interest Rate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _loanRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Annual Interest Rate (%)',
                        border: OutlineInputBorder(),
                        suffixText: '%',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final newRate = double.tryParse(_loanRateController.text);
                          if (newRate != null) {
                            loanService.setLoanInterestRate(newRate);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Loan rate updated!')),
                            );
                          }
                        },
                        child: const Text('Update Loan Rate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Current Rates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Rate')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Savings Account')),
                  DataCell(Text('${savingsService.savingsInterestRate}% p.a.')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Loans')),
                  DataCell(Text('${loanService.loanInterestRate}% p.a.')),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}