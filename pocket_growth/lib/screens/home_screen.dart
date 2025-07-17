import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logo.svg',
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Join Now'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Save, Borrow, and Earn More with Ease',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Manage your savings, access loans, and calculate your financial growth online.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Start Saving Today'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Learn More About Loans'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Features Section
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Text(
                    'Key Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      FeatureCard(
                        icon: Icons.account_balance_wallet,
                        title: 'Savings Management',
                        description: 'Easily manage your savings with our intuitive platform.',
                      ),
                      FeatureCard(
                        icon: Icons.money,
                        title: 'Loan Borrowing',
                        description: 'Access loans based on your savings balance.',
                      ),
                      FeatureCard(
                        icon: Icons.calculate,
                        title: 'Interest Calculations',
                        description: 'Calculate your potential earnings and loan repayments.',
                      ),
                      FeatureCard(
                        icon: Icons.phone_android,
                        title: 'Mobile Money Integration',
                        description: 'Seamless integration with MTN and Airtel Mobile Money.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Footer would be implemented here
    );
  }
}