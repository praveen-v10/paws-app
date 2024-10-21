import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pups/Pages/Appointment/appointment.dart';

import '../Booking/booking.dart';

class AppointmentClose extends StatefulWidget {
  const AppointmentClose({Key? key}) : super(key: key);

  @override
  State<AppointmentClose> createState() => _AppointmentCloseState();
}

class _AppointmentCloseState extends State<AppointmentClose> {


  int selectedIndexPayment = 0;
  String selectedPaymentMethod = 'Cash';


  List service = [];
  List servicePrice = [];
  String serviceTotalPrice ='';
  String appointmentDate='';
  String appointmentTime='';
  String groomerName='';
  String groomerImg='';
  String groomerId='';


  @override
  void initState() {
    super.initState();

    fetchAppointmentData();

  }

  fetchAppointmentData() async {

    setState(() {
      service.clear();
      servicePrice.clear();
    });

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(Appointment.appointmentId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> doc =
          documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            service = doc['service'];
            servicePrice = doc['servicePrice'];
            serviceTotalPrice = doc['serviceTotalPrice'].toString();
            appointmentTime=doc['serviceTime'];
            appointmentDate=doc['serviceDate'];
            groomerId=doc['groomerId'];
          });

          if(groomerId.isNotEmpty){
            await fetchGroomerDetails();
          }
          print( service);
        } else {
          print('Current Name does not exist on the database');
        }

      });
    } catch (e) {
      print(e);
    }
  }

  fetchGroomerDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('groomer')
          .doc(groomerId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> doc =
          documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            groomerName = doc['groomerName'];
            groomerImg = doc['groomerImg'];
          });
          print( groomerName);
        } else {
          print('Current Name does not exist on the database');
        }

      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(

        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Appointment Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
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
                                groomerImg.isEmpty?
                                SizedBox()
                                    :ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(20), // Image radius
                                    child: Image.network(groomerImg),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    groomerName,
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
                                    appointmentDate,
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
                                    appointmentTime,
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
                            itemCount: service.length, // Update with actual item count
                            itemBuilder: (context, index) {
                              print('object');
                              print(service);
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
                                      service[index], // Replace with correct data
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "₹${servicePrice[index]}", // Replace with correct data
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
                                  '₹ ${serviceTotalPrice}', // Replace with correct data
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
                              activeColor: Colors.grey,
                              value: 'Cash',
                              groupValue: selectedPaymentMethod,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedPaymentMethod = value!;
                                });
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
    );
  }
}
