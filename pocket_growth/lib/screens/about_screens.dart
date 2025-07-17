import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Empowering communities to save, grow, and access affordable loans through digital innovation.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Our Story',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Founded in 2023, Savings & Loan App was created to provide accessible financial services '
              'to everyone in Uganda. We leverage mobile money technology to make savings and loans '
              'available at your fingertips, without the need for traditional banking infrastructure.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTeamMember(
              name: 'John Mugisha',
              role: 'CEO & Founder',
              image: 'assets/images/team1.jpg',
            ),
            _buildTeamMember(
              name: 'Sarah Nakato',
              role: 'Head of Operations',
              image: 'assets/images/team2.jpg',
            ),
            _buildTeamMember(
              name: 'David Ochieng',
              role: 'Technology Lead',
              image: 'assets/images/team3.jpg',
            ),
            const SizedBox(height: 30),
            const Text(
              'Our Partners',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/mtn.png', height: 50),
                Image.asset('assets/images/airtel.png', height: 50),
                Image.asset('assets/images/uganda.png', height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(role),
            ],
          ),
        ],
      ),
    );
  }
}