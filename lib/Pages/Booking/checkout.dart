import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/Booking/booking.dart';
import 'package:pups/Pages/Booking/pet_select.dart';
import 'package:pups/Pages/Login/login.dart';
import 'package:pups/Pages/bottom.dart';
import 'package:pups/Pages/home.dart';
import 'package:pups/Widgets/loading.dart';
import 'package:uuid/uuid.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int totalPrice = 0;
  int selectedIndexPayment = 0;
  String selectedPaymentMethod = 'Cash';
  bool _Loading = false;


  var uuid = const Uuid();


  @override
  void initState() {
    super.initState();
    totalPrice = Booking.selectedServicePrice
        .cast<int>()
        .reduce((value, element) => value + element);
    print('Total: $totalPrice');
  }


  addBooking() async {
    // Show loading indicator
    if (mounted) {
      setState(() {
        _Loading = true;
      });
    }

    await Hive.openBox("UserDetails");
    var box = Hive.box('UserDetails');
    var userId = box.get('user_id');

    String id = uuid.v4(); // Generate UUID

    // Add booking to Firestore
    await FirebaseFirestore.instance.collection('bookings').doc(id).set({
      'bookingId': id,
      'userId': userId,
      'groomerId': Booking.selectedGroomerId,
      'petId': PetSelect.cartPetId,
      'service': Booking.selectedService,
      'servicePrice': Booking.selectedServicePrice,
      'serviceTotalPrice': totalPrice,
      'serviceDate': Booking.formattedDate,
      'serviceTime': Booking.selectedTime,
      'shopLocation': 'Chennai, TamilNadu',
      'paymentMethod': 'Cash',
      'orderedTime': DateTime.now(),
      'status': 'Active'
    });

    print(id);
    print('added');

    // Send push notification
    final userName = Home.userName;
    final bookingDate = Booking.formattedDate;
    final bookingTime = Booking.selectedTime;
    sendPushNotification(userName, bookingDate, bookingTime);

    // Hide loading indicator
    if (mounted) {
      setState(() {
        _Loading = false;
      });
    }
  }


  // Send Push Notification using Firebase HTTP v1 API
  Future<void> sendPushNotification(String userName, String bookingTime, String bookingDate) async {
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
          'body': '$userName has booked an appointment on $bookingDate at $bookingTime',
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'user_name': userName,
          'booking_time': bookingTime,
          'booking_date': bookingDate,
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




  void bookingDone(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: (){
          return Future.value(false);
        },
        child: AlertDialog(
          backgroundColor: Colors.white, // Set the background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Add rounded corners
          ),
          title: Center(
            child: const Text(
              "Booking Successful",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ), // Make the title bold
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Set a fixed width for the dialog (80% of screen width)
            child: Column(
              mainAxisSize: MainAxisSize.min, // This makes the dialog only as tall as the content
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Image.asset('assets/calendar.png')

                ),
                SizedBox(height: 10),
                Text(
                  Booking.formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  Booking.selectedTime,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Chennai, TamilNadu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text(
                  'Ready to Shine!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Increase font size for better visibility
                    fontWeight: FontWeight.bold, // Make the text bold for emphasis
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF6A5ACD), // A soft purple to complement the background
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Add padding for a better touch target
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Rounded corners for a modern look
                  ),
                ),
                onPressed: () {
                 //Navigator.pop(context);
                 Get.offAll(Bottom());
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return _Loading?DefaultLoading():Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Checkout',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              width: w,
              decoration: BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(20), // Image radius
                                      child: Image.network(Booking.selectedGroomerImg),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      Booking.selectedGroomerName,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      Booking.formattedDate,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.clock_fill,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      Booking.selectedTime,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.location_on,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      'Chennai, TamilNadu',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Services',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent scrolling conflict
                              itemCount: Booking.selectedService
                                  .length, // Update with actual item count
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Booking.selectedService[
                                            index], // Replace with correct data
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '₹${Booking.selectedServicePrice[index]}', // Replace with correct data
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total', // Replace with correct data
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '₹ ${totalPrice}', // Replace with correct data
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Payment Method',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cash',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Radio<String>(
                                value: 'Cash',
                                groupValue: selectedPaymentMethod,
                                onChanged: (String? value) {

                                  if (mounted) {
                                    setState(() {
                                      selectedPaymentMethod = value!;
                                    });
                                  }

                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: GestureDetector(
          onTap: () async {
          await addBooking();

            bookingDone();

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF6A5ACD),
            ),
            width: 300,
            height: 50,
            child: Center(
              child: Text(
                'Lock In the Love',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Increase font size for better visibility
                  fontWeight:
                      FontWeight.bold, // Make the text bold for emphasis
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
