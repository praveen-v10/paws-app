import 'package:flutter/material.dart';

import '../../Widgets/splash_screenn.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor:SplashScreen.selectedColor,
        title: Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acceptance of Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By using our app, you agree to the following terms and conditions. If you do not agree with these terms, please do not use our services.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Booking and Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'All bookings are subject to availability and must be confirmed with payment. Cancellations must be made at least 24 hours in advance to avoid fees.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We take utmost care in providing grooming services to your pets. However, we are not responsible for any unforeseen issues related to pet health or behavior during the service.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Service Modifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We reserve the right to modify or discontinue any service without prior notice. Any changes will be communicated via the app or email.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'User Conduct',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Users are expected to behave respectfully toward our staff and other users. Any misuse of the app or inappropriate behavior may result in suspension or termination of your account.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
