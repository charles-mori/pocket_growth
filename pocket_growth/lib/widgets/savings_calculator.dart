import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingsCalculatorWidget extends StatefulWidget {
  const SavingsCalculatorWidget({super.key});

  @override
  State<SavingsCalculatorWidget> createState() => _SavingsCalculatorWidgetState();
}

class _SavingsCalculatorWidgetState extends State<SavingsCalculatorWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _initialAmountController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  double? _futureValue;
  List<Map<String, dynamic>> _projection = [];

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final initialAmount = double.parse(_initialAmountController.text);
      final monthlyContribution = double.parse(_monthlyContributionController.text);
      final annualRate = double.parse(_annualRateController.text);
      final years = int.parse(_yearsController.text);

      final futureValue = SavingCalculator.calculateFutureValueOfSeries(
        monthlyContribution: monthlyContribution,
        annualRate: annualRate,
        years: years,
      ) + SavingCalculator.calculateFutureValue(
        principal: initialAmount,
        annualRate: annualRate,
        years: years,
      );

      final projection = SavingCalculator.generateSavingsProjection(
        initialAmount: initialAmount,
        monthlyContribution: monthlyContribution,
        annualRate: annualRate,
        years: years,
      );

      setState(() {
        _futureValue = futureValue;
        _projection = projection;
      });
    }
  }

  @override
  void dispose() {
    _initialAmountController.dispose();
    _monthlyContributionController.dispose();
    _annualRateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _initialAmountController,
                decoration: const InputDecoration(labelText: 'Initial Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter amount' : null,
              ),
              TextFormField(
                controller: _monthlyContributionController,
                decoration: const InputDecoration(labelText: 'Monthly Contribution'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter contribution' : null,
              ),
              TextFormField(
                controller: _annualRateController,
                decoration: const InputDecoration(labelText: 'Annual Interest Rate (%)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter interest rate' : null,
              ),
              TextFormField(
                controller: _yearsController,
                decoration: const InputDecoration(labelText: 'Years to Save'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter number of years' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 20),
              if (_futureValue != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Savings: ${SavingCalculator.formatCurrency(_futureValue!)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('After ${_yearsController.text} years of saving.'),
                    const Divider(),
                    const Text('Growth Projection (First 5 Months):'),
                    ..._projection.take(5).map((entry) => ListTile(
                          title: Text(
                            'Month ${entry['month']}: ${SavingCalculator.formatCurrency(entry['balance'])}',
                          ),
                          subtitle: Text('Date: ${entry['date'].toString().split(' ')[0]}'),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavingCalculator {
  // Calculate future value of a single lump sum investment
  static double calculateFutureValue({
    required double principal,
    required double annualRate,
    required int years,
    int compoundingPeriodsPerYear = 1,
  }) {
    if (principal <= 0 || annualRate <= 0 || years <= 0) return 0;
    
    final ratePerPeriod = annualRate / 100 / compoundingPeriodsPerYear;
    final totalPeriods = years * compoundingPeriodsPerYear;
    
    return principal * pow(1 + ratePerPeriod, totalPeriods);
  }

  // Calculate future value of regular contributions
  static double calculateFutureValueOfSeries({
    required double monthlyContribution,
    required double annualRate,
    required int years,
    int compoundingPeriodsPerYear = 12,
  }) {
    if (monthlyContribution <= 0 || annualRate <= 0 || years <= 0) return 0;
    
    final ratePerPeriod = annualRate / 100 / compoundingPeriodsPerYear;
    final totalPeriods = years * compoundingPeriodsPerYear;
    
    return monthlyContribution * 
        ((pow(1 + ratePerPeriod, totalPeriods) - 1) / ratePerPeriod);
  }

  // Calculate how much to save each month to reach a goal
  static double calculateRequiredMonthlySavings({
    required double futureValueGoal,
    required double annualRate,
    required int years,
    int compoundingPeriodsPerYear = 12,
  }) {
    if (futureValueGoal <= 0 || annualRate <= 0 || years <= 0) return 0;
    
    final ratePerPeriod = annualRate / 100 / compoundingPeriodsPerYear;
    final totalPeriods = years * compoundingPeriodsPerYear;
    
    return futureValueGoal * 
        (ratePerPeriod / (pow(1 + ratePerPeriod, totalPeriods) - 1));
  }

  // Calculate how long it will take to reach a savings goal
  static double calculateTimeToGoal({
    required double futureValueGoal,
    required double monthlyContribution,
    required double annualRate,
    int compoundingPeriodsPerYear = 12,
  }) {
    if (futureValueGoal <= 0 || monthlyContribution <= 0 || annualRate <= 0) return 0;
    
    final ratePerPeriod = annualRate / 100 / compoundingPeriodsPerYear;
    final numerator = log(
      (futureValueGoal * ratePerPeriod / monthlyContribution) + 1
    );
    final denominator = log(1 + ratePerPeriod);
    
    return numerator / denominator / compoundingPeriodsPerYear;
  }

  // Format currency for display
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(amount);
  }

  // Generate savings growth projection
  static List<Map<String, dynamic>> generateSavingsProjection({
    required double initialAmount,
    required double monthlyContribution,
    required double annualRate,
    required int years,
    DateTime? startDate,
    int compoundingPeriodsPerYear = 12,
  }) {
    final projection = <Map<String, dynamic>>[];
    final ratePerPeriod = annualRate / 100 / compoundingPeriodsPerYear;
    double balance = initialAmount;
    DateTime currentDate = startDate ?? DateTime.now();
    final totalMonths = years * 12;

    for (int i = 0; i <= totalMonths; i++) {
      if (i > 0) {
        // Add interest and contribution at the end of each month
        final interest = balance * ratePerPeriod;
        balance += interest + monthlyContribution;
      }

      projection.add({
        'month': i,
        'date': currentDate,
        'balance': balance,
        'totalContributions': initialAmount + (monthlyContribution * i),
        'interestEarned': balance - (initialAmount + (monthlyContribution * i)),
      });

      currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    }

    return projection;
  }
}