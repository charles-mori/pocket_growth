import 'package:flutter/material.dart';

class FAQsScreen extends StatelessWidget {
  final List<FAQItem> faqs = [
    FAQItem(
      question: "How do I create a savings account?",
      answer: "Simply register on the app, verify your mobile money number, and you can start saving immediately.",
    ),
    FAQItem(
      question: "What is the minimum savings amount?",
      answer: "You can start saving with as little as 1,000 UGX. There's no maximum limit.",
    ),
    FAQItem(
      question: "How are interest rates calculated?",
      answer: "Interest is calculated daily and credited monthly at 5% per annum on your savings balance.",
    ),
    FAQItem(
      question: "How can I apply for a loan?",
      answer: "Navigate to the Loans section, check your eligibility, and submit a loan application. Loans are approved based on your savings history.",
    ),
    FAQItem(
      question: "What mobile money providers do you support?",
      answer: "We currently support MTN Mobile Money and Airtel Money for all transactions.",
    ),
    FAQItem(
      question: "How long does loan approval take?",
      answer: "Most loans are approved within 24 hours if you meet all requirements.",
    ),
  ];

  FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqs[index].question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(faqs[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}