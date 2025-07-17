import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/loan_service.dart';
import '../../services/savings_service.dart';
import '../../widgets/loan_calculator.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loans = context.watch<LoanService>();

    return DefaultTabController(
      length: loans.activeLoan == null ? 2 : 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loan Management'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Apply'),
              if (loans.activeLoan != null) const Tab(text: 'My Loan'),
              const Tab(text: 'Calculator'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Apply for Loan
            _buildApplyLoanTab(context),
            
            // My Loan (if active)
            if (loans.activeLoan != null) _buildMyLoanTab(context),
            
            // Calculator
            const LoanCalculatorWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyLoanTab(BuildContext context) {
    final loans = context.watch<LoanService>();
    final savings = context.watch<SavingsService>();
    
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final durationController = TextEditingController();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Loan Eligibility',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Based on your current savings of \$${savings.balance.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can borrow up to \$${savings.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount',
                    prefixText: '\$',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid number';
                    }
                    if (amount > savings.balance) {
                      return 'Amount exceeds your maximum eligibility';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Repayment Period (months)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a duration';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Loan Summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Loan Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Interest Rate:'),
                            Text('10% per annum'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Repayable:'),
                            Text(
                              amountController.text.isEmpty || durationController.text.isEmpty
                                  ? '\$0.00'
                                  : '\$${loans.calculateTotalRepayment(
                                      double.tryParse(amountController.text) ?? 0,
                                      int.tryParse(durationController.text) ?? 0,
                                    ).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Monthly Installment:'),
                            Text(
                              amountController.text.isEmpty || durationController.text.isEmpty
                                  ? '\$0.00'
                                  : '\$${loans.calculateMonthlyPayment(
                                      double.tryParse(amountController.text) ?? 0,
                                      int.tryParse(durationController.text) ?? 0,
                                    ).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _submitLoanApplication(context);
                    }
                  },
                  child: const Text('Apply for Loan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyLoanTab(BuildContext context) {
    final loans = context.watch<LoanService>();
    final activeLoan = loans.activeLoan!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Active Loan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLoanDetailRow('Loan Amount', '\$${activeLoan.amount.toStringAsFixed(2)}'),
                  _buildLoanDetailRow('Disbursed On', activeLoan.disbursementDate as String),
                  _buildLoanDetailRow('Interest Rate', '${activeLoan.interestRate}%'),
                  _buildLoanDetailRow('Term', '${activeLoan.term} ${activeLoan.termUnit}'),
                  _buildLoanDetailRow('Total Repayable', '\$${activeLoan.totalRepayment.toStringAsFixed(2)}'),
                  _buildLoanDetailRow('Amount Paid', '\$${activeLoan.amountPaid.toStringAsFixed(2)}'),
                  _buildLoanDetailRow('Remaining Balance', '\$${activeLoan.remainingAmount.toStringAsFixed(2)}'),
                  _buildLoanDetailRow('Next Payment Due', '${activeLoan.nextPaymentDate} - \$${activeLoan.nextPaymentAmount.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ElevatedButton(
            onPressed: () => _makePayment(context),
            child: const Text('Make Payment'),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Payment History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activeLoan.paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = activeLoan.paymentHistory[index];
              return ListTile(
                leading: const Icon(Icons.payment, color: Colors.green),
                title: Text('\$${payment.amount.toStringAsFixed(2)}'),
                subtitle: Text(payment.date),
                trailing: Text(payment.status),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _submitLoanApplication(BuildContext context) {
    // Implement loan application submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loan application submitted for approval')),
    );
  }

  void _makePayment(BuildContext context) {
    // Implement payment functionality
  }
}