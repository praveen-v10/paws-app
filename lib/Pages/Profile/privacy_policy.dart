import 'package:flutter/material.dart';

import '../../Widgets/splash_screenn.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: SplashScreen.selectedColor,
        title: Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Data Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We collect personal details such as your name, contact information, pet details, and payment methods for the purpose of providing our services. All data is stored securely.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Use of Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We use your data to facilitate grooming appointments, offer personalized services, and improve your user experience. We do not share your information with third parties without your consent.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your data is encrypted and stored on secure servers. We take appropriate measures to prevent unauthorized access or data breaches.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Your Rights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You have the right to access, update, or delete your personal information at any time. Contact us at privacy@pups.com for any requests or inquiries.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
