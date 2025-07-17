import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/savings_service.dart';
import '../../services/loan_service.dart';
import 'profile_screen.dart';
import 'savings_screen.dart';
import 'loans_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    const SavingsScreen(),
    const LoansScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Loans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final savings = context.watch<SavingsService>();
    final loans = context.watch<LoanService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Savings Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Savings Balance',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Deposit'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Withdraw'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Loan Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Loan Status',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  loans.activeLoan == null
                      ? const Text(
                          'No active loan',
                          style: TextStyle(fontSize: 16),
                        )
                      : Column(
                          children: [
                            Text(
                              'Outstanding: \$${loans.activeLoan!.remainingAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Next payment: \$${loans.activeLoan!.nextPaymentAmount.toStringAsFixed(2)} on ${loans.activeLoan!.nextPaymentDate}',
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: loans.activeLoan == null
                        ? const Text('Apply for Loan')
                        : const Text('Make Payment'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildQuickAction(
                icon: Icons.calculate,
                label: 'Savings Calculator',
                onTap: () {},
              ),
              _buildQuickAction(
                icon: Icons.calculate,
                label: 'Loan Calculator',
                onTap: () {},
              ),
              _buildQuickAction(
                icon: Icons.history,
                label: 'Transaction History',
                onTap: () {},
              ),
              _buildQuickAction(
                icon: Icons.help,
                label: 'FAQs',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}