import 'package:flutter/material.dart';

import '../../Widgets/splash_screenn.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('FAQ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Container(

            decoration: BoxDecoration(
              color: SplashScreen.selectedColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  title: Text('How do I book an appointment?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'You can book an appointment by selecting your pet and preferred service, then choosing a date and time that works for you.',style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  title: Text('Can I reschedule or cancel an appointment?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Yes, you can reschedule or cancel your appointments from the "Appointment History" section, but note that cancellations must be made 24 hours in advance to avoid charges.',
                        style: TextStyle(color: Colors.black54),  ),
                    ),
                  ],
                ),
                ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  title: Text('What services do you offer for cats?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'We offer specialized grooming services for cats including flea and tick treatments, de-shedding, and stress-free baths. Check our "Feline Care" section for more details.',
                        style: TextStyle(color: Colors.black54),   ),
                    ),
                  ],
                ),
                ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  title: Text('How do I update my pet’s profile?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'You can update your pet’s details by going to the "My Pets" section and selecting the pet you want to edit.',
                        style: TextStyle(color: Colors.black54),   ),
                    ),
                  ],
                ),
                ExpansionTile(
                  shape: Border.all(color: Colors.transparent),
                  title: Text('Is there a referral program?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Yes, you can invite friends and earn discounts on your next appointment! Visit the "Referral Program" section for more details.',
                        style: TextStyle(color: Colors.black54),       ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
