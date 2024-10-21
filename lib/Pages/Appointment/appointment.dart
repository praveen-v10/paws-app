import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:hive/hive.dart'; // For local storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:flutter/material.dart';
import 'package:pups/Pages/Appointment/appointment_close.dart';
import 'package:pups/Pages/Appointment/appointment_open.dart'; // Flutter framework

class Appointment extends StatefulWidget {
  static String appointmentId='';
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  List bookingActiveData = [];
  List bookingCloseData = [];

  @override
  void initState() {
    super.initState();

    fetchBookingActiveData();
    fetchBookingCloseData();
  }

  fetchBookingActiveData() async {
    if (mounted) {
      setState(() {
        bookingActiveData.clear();
      });
    }


    await Hive.openBox("UserDetails");
    var box = Hive.box('UserDetails');
    var userId = box.get('user_id');

    await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Active')
        .snapshots()
        .listen((data) {
      setState(() {
        bookingActiveData = data.docs;

        // Sort bookings by nearest serviceDate and serviceTime compared to the current time
        bookingActiveData.sort((a, b) {
          // Parse serviceDate and serviceTime
          DateTime getBookingDateTime(dynamic booking) {
            var serviceDate = booking['serviceDate']; // e.g., 04/10/2024
            var serviceTime = booking['serviceTime']; // e.g., 1:55 PM
            var parsedDate = DateFormat('dd/MM/yyyy').parse(serviceDate);
            var parsedTime = DateFormat('h:mm a').parse(serviceTime);

            // Combine parsedDate and parsedTime into a single DateTime
            return DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
                parsedTime.hour, parsedTime.minute);
          }

          DateTime dateTimeA = getBookingDateTime(a);
          DateTime dateTimeB = getBookingDateTime(b);

          return dateTimeA
              .compareTo(dateTimeB); // Sort ascending by nearest date and time
        });
      });

      print(bookingActiveData.length);
    }, onError: (error) {
      // Handle error here
      print("Error getting documents: $error");
    });
  }

  fetchBookingCloseData() async {
    setState(() {
      bookingCloseData.clear();
    });

    await Hive.openBox("UserDetails");
    var box = Hive.box('UserDetails');
    var userId = box.get('user_id');

    await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Close')
        .snapshots()
        .listen((data) {
      setState(() {
        bookingCloseData = data.docs;

        // Sort bookings by nearest serviceDate and serviceTime compared to the current time
        bookingCloseData.sort((a, b) {
          // Parse serviceDate and serviceTime
          DateTime getBookingDateTime(dynamic booking) {
            var serviceDate = booking['serviceDate']; // e.g., 04/10/2024
            var serviceTime = booking['serviceTime']; // e.g., 1:55 PM
            var parsedDate = DateFormat('dd/MM/yyyy').parse(serviceDate);
            var parsedTime = DateFormat('h:mm a').parse(serviceTime);

            // Combine parsedDate and parsedTime into a single DateTime
            return DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
                parsedTime.hour, parsedTime.minute);
          }

          DateTime dateTimeA = getBookingDateTime(a);
          DateTime dateTimeB = getBookingDateTime(b);

          return dateTimeA
              .compareTo(dateTimeB); // Sort ascending by nearest date and time
        });
      });

      print(bookingCloseData.length);
    }, onError: (error) {
      // Handle error here
      print("Error getting documents: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Appointments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  bookingActiveData.isEmpty&&bookingCloseData.isEmpty?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Image.asset('assets/calendar.png',width: w*0.5,),
                              ),
                              Text('Start their care journey—book today!',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black54),textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ):
                  bookingActiveData.isEmpty?
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('No Upcoming Appointments',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black54),)),
                          ),
                        ),
                      )
                      :Text('Upcoming',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  // bookingActiveData.isEmpty
                  //     ? Center(
                  //         child:
                  //             CircularProgressIndicator()) // Show loader if no data
                  //     :

                  SizedBox(height: 10,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bookingActiveData.length,
                    itemBuilder: (context, index) {
                      var booking = bookingActiveData[index].data();
                      var serviceDate = booking['serviceDate']; // e.g., 04/10/2024
                      var serviceTime = booking['serviceTime']; // e.g., 1:55 PM
                      var price = booking['serviceTotalPrice'].toString();
                      var services = booking['service']
                          .join(', '); // e.g., 'Hygienic Care, Feline Care'

                      // Split the serviceDate into day and month
                      var day = serviceDate.split('/')[0];
                      var month = DateFormat.MMM().format(
                          DateFormat('MM').parse(serviceDate.split('/')[1]));

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              Appointment.appointmentId=booking['bookingId'];
                            });
                            print( Appointment.appointmentId);
                            Get.to(AppointmentOpen());
                          },
                          child: Container(
                            width: w,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      height: 100,
                                      width:
                                      80, // Set a fixed width to prevent overflow
                                      decoration: BoxDecoration(
                                        color: Color(0xFF6A5ACD),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              day,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              month,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 10), // Add space between the containers
                                  Expanded(
                                    // Use Expanded to prevent overflow
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            serviceTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            services,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                            overflow: TextOverflow
                                                .ellipsis, // Prevent text overflow
                                          ),
                                          Text(
                                            '₹ $price',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),


                  SizedBox(height: 20,),
                  bookingCloseData.isEmpty?SizedBox():Text('Previous',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  // bookingActiveData.isEmpty
                  //     ? Center(
                  //         child:
                  //             CircularProgressIndicator()) // Show loader if no data
                  //     :

                  SizedBox(height: 10,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bookingCloseData.length,
                    itemBuilder: (context, index) {
                      var booking = bookingCloseData[index].data();
                      var serviceDate = booking['serviceDate']; // e.g., 04/10/2024
                      var serviceTime = booking['serviceTime']; // e.g., 1:55 PM
                      var price = booking['serviceTotalPrice'].toString();
                      var services = booking['service']
                          .join(', '); // e.g., 'Hygienic Care, Feline Care'

                      // Split the serviceDate into day and month
                      var day = serviceDate.split('/')[0];
                      var month = DateFormat.MMM().format(
                          DateFormat('MM').parse(serviceDate.split('/')[1]));

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              Appointment.appointmentId=booking['bookingId'];
                            });
                            print( Appointment.appointmentId);
                            Get.to(AppointmentClose());
                          },
                          child: Container(
                            width: w,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      height: 100,
                                      width:
                                      80, // Set a fixed width to prevent overflow
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              day,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              month,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 10), // Add space between the containers
                                  Expanded(
                                    // Use Expanded to prevent overflow
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            serviceTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            services,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                            overflow: TextOverflow
                                                .ellipsis, // Prevent text overflow
                                          ),
                                          Text(
                                            '₹ $price',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
