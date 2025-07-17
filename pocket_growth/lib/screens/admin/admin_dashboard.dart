import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/loan_service.dart';
import '../../services/savings_service.dart';
import '../../services/auth_service.dart';
import 'user_management.dart';
import 'loan_management.dart';
import 'interest_settings.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard Overview'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Loan Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoanManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Interest Rate Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InterestSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSummaryCard(
                  context,
                  title: 'Total Users',
                  value: Provider.of<AuthService>(context).userCount.toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _buildSummaryCard(
                  context,
                  title: 'Total Savings',
                  value: '\$${Provider.of<SavingsService>(context).totalSavings.toStringAsFixed(2)}',
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                _buildSummaryCard(
                  context,
                  title: 'Active Loans',
                  value: Provider.of<LoanService>(context).activeLoansCount.toString(),
                  icon: Icons.money,
                  color: Colors.orange,
                ),
                _buildSummaryCard(
                  context,
                  title: 'Pending Approvals',
                  value: Provider.of<LoanService>(context).pendingLoansCount.toString(),
                  icon: Icons.pending_actions,
                  color: Colors.red,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent Activity
            const Text(
              'Recent Loan Applications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Term')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: Provider.of<LoanService>(context)
                      .recentLoanApplications
                      .map((loan) => DataRow(cells: [
                            DataCell(Text(loan.userName ?? 'N/A')),
                            DataCell(Text('\$${loan.amount.toStringAsFixed(2)}')),
                            DataCell(Text('${loan.term} ${loan.termUnit}')),
                            DataCell(
                              Text(loan.status),
                              onTap: () {
                                // Show loan details
                              },
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () {
                                      // Approve loan
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      // Reject loan
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Icon(icon, color: color),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}