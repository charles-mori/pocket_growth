import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/savings_service.dart';
import '../../widgets/savings_calculator.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savings = context.watch<SavingsService>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Savings Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Savings'),
              Tab(text: 'Calculator'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // My Savings Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Total Savings Balance',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${savings.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Projected interest this year:'),
                          Text(
                            '\$${savings.projectedYearlyInterest.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Deposit/Withdraw Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Deposit'),
                          onPressed: () => _showDepositDialog(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.remove),
                          label: const Text('Withdraw'),
                          onPressed: () => _showWithdrawDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Transaction History
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savings.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = savings.transactions[index];
                      return ListTile(
                        leading: Icon(
                          transaction.type == 'deposit'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: transaction.type == 'deposit'
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(
                          transaction.type.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(transaction.date),
                        trailing: Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction.type == 'deposit'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Calculator Tab
            const SavingsCalculatorWidget(),
          ],
        ),
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deposit Money'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Select Mobile Money Provider:'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: const Text('MTN'),
                      selected: true,
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: const Text('Airtel'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Process deposit
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deposit request sent to your mobile money')),
                  );
                }
              },
              child: const Text('Deposit'),
            ),
          ],
        );
      },
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    // Similar implementation to deposit dialog
  }
}