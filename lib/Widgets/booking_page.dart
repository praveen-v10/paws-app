import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bookingTimeController = TextEditingController();

  // Send Push Notification using Firebase HTTP v1 API
  Future<void> sendPushNotification(String userName, String bookingTime) async {
    // Retrieve the admin token from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('admin_tokens')
        .doc('admin')
        .get();

    String? adminToken = snapshot.get('token');
    if (adminToken == null) {
      print("No admin token found");
      return;
    }

    // Get service account credentials from the downloaded JSON file
    final serviceAccount = json.decode(
        await DefaultAssetBundle.of(context).loadString('assets/service_account.json'));

    // Create Firebase OAuth2 client
    final client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccount),
        ['https://www.googleapis.com/auth/cloud-platform']);

    final url = 'https://fcm.googleapis.com/v1/projects/pups-8b213/messages:send';

    final body = jsonEncode({
      'message': {
        'token': adminToken,
        'notification': {
          'title': 'New Booking',
          'body': '$userName booked an appointment at $bookingTime',
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'user_name': userName,
          'booking_time': bookingTime,
        },
      },
    });

    // Send the request
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print('Notification sent: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            TextField(
              controller: bookingTimeController,
              decoration: InputDecoration(labelText: 'Booking Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final userName = userNameController.text;
                final bookingTime = bookingTimeController.text;
                sendPushNotification(userName, bookingTime);
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
