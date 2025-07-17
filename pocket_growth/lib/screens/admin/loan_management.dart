import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/loan.dart';
import '../../services/loan_service.dart';

class LoanManagementScreen extends StatelessWidget {
  const LoanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loanService = Provider.of<LoanService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loan Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Loans
            _buildLoanList(
              context,
              loans: loanService.pendingLoans,
              showApproveButtons: true,
            ),
            
            // Active Loans
            _buildLoanList(
              context,
              loans: loanService.activeLoans,
              showApproveButtons: false,
            ),
            
            // Completed Loans
            _buildLoanList(
              context,
              loans: loanService.completedLoans,
              showApproveButtons: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanList(
    BuildContext context, {
    required List<Loan> loans,
    required bool showApproveButtons,
  }) {
    if (loans.isEmpty) {
      return const Center(
        child: Text('No loans found'),
      );
    }

    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('${loan.userName} - \$${loan.amount.toStringAsFixed(2)}'),
            subtitle: Text('Status: ${loan.status}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLoanDetailRow('User', loan.userName ?? ''),
                    _buildLoanDetailRow('Amount', '\$${loan.amount.toStringAsFixed(2)}'),
                    _buildLoanDetailRow('Term', '${loan.term} ${loan.termUnit}'),
                    _buildLoanDetailRow('Interest Rate', '${loan.interestRate}%'),
                    _buildLoanDetailRow('Total Repayable', '\$${loan.totalRepayment.toStringAsFixed(2)}'),
                    _buildLoanDetailRow('Disbursement Date', loan.disbursementDate as String),
                    _buildLoanDetailRow('Status', loan.status),
                    
                    if (showApproveButtons) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Approve loan
                              Provider.of<LoanService>(context, listen: false)
                                  .approveLoan(loan.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Approve'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Reject loan
                              Provider.of<LoanService>(context, listen: false)
                                  .rejectLoan(loan.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                    
                    if (!showApproveButtons && loan.status == 'Active') ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Repayment History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...loan.paymentHistory.map((payment) => ListTile(
                        title: Text('\$${payment.amount.toStringAsFixed(2)}'),
                        subtitle: Text(payment.date),
                        trailing: Text(payment.status),
                      )).toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
}