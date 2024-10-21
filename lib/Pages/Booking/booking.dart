import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pups/Pages/Booking/checkout.dart';

import '../../Widgets/splash_screenn.dart';

class Booking extends StatefulWidget {
  static String selectedGroomerId = '';
  static String selectedGroomerName = '';
  static String selectedGroomerImg = '';
  static List selectedService = [];
  static List selectedServicePrice = [];
  static String selectedTime = '';
  static String formattedDate = '';
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final Map<String, dynamic> petCareServices = {
    'Complex Care': {
      'price': 2550,
      'subServices': [
        'Health Assessments',
        'Allergy Treatments',
        'Skin & Coat Care',
        'Mobility Support',
        'Post-Surgical Grooming',
      ]
    },
    'SPA Service': {
      'price': 1200,
      'subServices': [
        'Aromatherapy Baths',
        'Pawdicures',
        'Fur Conditioning Treatments',
        'Deep Coat Cleansing',
        'De-Stress Massages',
      ]
    },
    'Creative Grooming': {
      'price': 1000,
      'subServices': [
        'Fur Dyeing',
        'Stylish Haircuts',
        'Temporary Fur Tattoos',
        'Custom Hair Designs',
      ]
    },
    'Hygienic Care': {
      'price': 2080,
      'subServices': [
        'Regular Bathing',
        'Nail Trimming',
        'Ear Cleaning',
        'Anal Gland Expression',
      ]
    },
    'Feline Care': {
      'price': 1590,
      'subServices': [
        'Gentle Bathing',
        'De-Shedding Treatment',
        'Pawdicure',
        'Ear Cleaning',
        'Tear Stain Removal',
      ]
    },
    'Other Services': {
      'price': 1770,
      'subServices': [
        'Pet Taxi',
        'Pet Sitting',
        'Nutrition Consulting',
        'Pet Photography',
      ]
    },
  };


  // A list to store selected prices
  List<int> selectedPrices = [];

// A map to track selected services
  Map<String, bool> selectedServices = {};



  // Define a list of colors for each service category

  // final List<Color> serviceColors = [
  //   Color(0xFFA0CBFE),
  //   Color(0xFFCCF9B8),
  //   Color(0xFFFFC8EF),
  //   Color(0xFFB4E6FF),
  //   Color(0xFFB0F8E0),
  //   Color(0xFFD1C6FF),
  // ];

  int _selectedIndex = 0; // Store the selected radio button index

  List groomerData = [];


  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;



  @override
  void initState() {
    super.initState();
    petCareServices.forEach((key, value) {
      selectedServices[key] = false;
    });

    fetchGroomerData();

    Booking.formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate.toLocal());
  }

  fetchGroomerData() async {
    setState(() {
      groomerData.clear();
      // shimmerEffect = true;
    });
    await FirebaseFirestore.instance
        .collection('groomer')
        .where('groomerType', isEqualTo: 'Groomer')
        .snapshots()
        .listen((data) {
      setState(() {
        groomerData = data.docs;
        Booking.selectedGroomerId = groomerData[_selectedIndex]['groomerId']!;
        Booking.selectedGroomerName = groomerData[_selectedIndex]['groomerName']!;
        Booking.selectedGroomerImg = groomerData[_selectedIndex]['groomerImg']!;

        print("Initially selected Groomer ID: ${Booking.selectedGroomerId}");
        print("Initially selected Groomer Name: ${Booking.selectedGroomerName}");
      });
      print(groomerData.length);
    }, onError: (error) {
      // Handle error here
      print("Error getting documents: $error");
    });
  }

  // void _showToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.red,
  //     textColor: Colors.white,
  //   );
  // }
  //
  // void _continueAction() {
  //   if (_selectedTime == null) {
  //     _showToast('Please select a time.');
  //   } else if (_selectedDate == null) {
  //     _showToast('Please select a date.');
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Selected Date & Time'),
  //           content: Text(
  //             'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}\n'
  //                 'Time: ${_selectedTime!.format(context)}',
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select a Date:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    EasyDateTimeLine(
                      initialDate: DateTime.now(),
                      onDateChange: (selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                          Booking.formattedDate  = DateFormat('dd/MM/yyyy')
                              .format(_selectedDate.toLocal());
                        });
                        // print(object)
                        print( Booking.formattedDate );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Selected Date',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Booking.formattedDate ,
                                style: TextStyle(fontSize: 18),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFC8EF),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.calendar_month,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_selectedTime == null)
                      Text(
                        'Select Time',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    if (_selectedTime != null)
                      Text(
                        'Selected Time',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_selectedTime == null)
                                Text(
                                  '00:00 AM/PM',
                                  style: TextStyle(fontSize: 18),
                                ),
                              if (_selectedTime != null)
                                Text(
                                  '${_selectedTime!.format(context)}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFC8EF),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
                                        setState(() {
                                          _selectedTime = pickedTime;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      CupertinoIcons.clock_solid,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Remove the Expanded here to fix the layout issue

                    Text(
                      'Select Service',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 10),


                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: petCareServices.length,
                      itemBuilder: (context, index) {
                        String service = petCareServices.keys.elementAt(index);
                        List<String> subServices = petCareServices[service]['subServices'];
                        int servicePrice = petCareServices[service]['price'];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                            color: Colors.white,
                            //  color: serviceColors[index],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              shape: Border.all(color: Colors.transparent),
                              title: Row(
                                children: [
                                  Checkbox(
                                    value: selectedServices[service],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedServices[service] = value ?? false;

                                        if (value == true) {
                                          selectedPrices.add(servicePrice);
                                        } else {
                                          selectedPrices.remove(servicePrice);
                                        }
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Text('$service', overflow: TextOverflow.ellipsis,),
                                      Text(' (\₹$servicePrice)'),
                                    ],
                                  ),
                                ],
                              ),
                              children: subServices.map((subService) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: ListTile(
                                    title: Text(subService),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Text(
                    //     'Total Price: \$${selectedPrices.fold(0, (sum, price) => sum + price)}',
                    //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //   ),
                    // ),



                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: petCareServices.length,
                    //   itemBuilder: (context, index) {
                    //     String service = petCareServices.keys.elementAt(index);
                    //     List<String> subServices = petCareServices[service]!;
                    //
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             // color: serviceColors[index],
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(12)),
                    //         child: ExpansionTile(
                    //           shape: Border.all(color: Colors.transparent),
                    //           title: Row(
                    //             children: [
                    //               Checkbox(
                    //                 value: selectedServices[service],
                    //                 onChanged: (bool? value) {
                    //                   setState(() {
                    //                     selectedServices[service] =
                    //                         value ?? false;
                    //                   });
                    //                 },
                    //               ),
                    //               Text(service),
                    //             ],
                    //           ),
                    //           children: subServices.map((subService) {
                    //             return Padding(
                    //               padding: const EdgeInsets.only(left: 16.0),
                    //               child: ListTile(
                    //                 title: Text(subService),
                    //               ),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),

                    SizedBox(height: 20),

                    Text(
                      'Select Groomer',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: groomerData.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var groomersData = groomerData[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                                Booking.selectedGroomerId = groomersData[
                                    'groomerId']!; // Store selected groomer ID
                                Booking.selectedGroomerName = groomersData[
                                'groomerName']!; // Store selected groomer ID
                                Booking.selectedGroomerImg = groomersData[
                                'groomerImg']!;
                                print(
                                    "Selected Groomer Name: ${Booking.selectedGroomerName}"); // Print groomer ID
                                print(
                                    "Selected Groomer ID: ${Booking.selectedGroomerId}");
                              });
                            },
                            child: Container(
                              width: w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: SizedBox.fromSize(
                                            size: Size.fromRadius(
                                                24), // Image radius
                                            child: Image.network(groomersData[
                                                'groomerImg']), // Placeholder image
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(groomersData['groomerName'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              Text(groomersData['groomerType'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Adding the radio button
                                    Radio<int>(
                                      value: index,
                                      groupValue: _selectedIndex,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedIndex = index;
                                          Booking.selectedGroomerId = groomersData[
                                              'groomerId']!; // Store selected groomer ID
                                          Booking.selectedGroomerName = groomersData[
                                          'groomerName']!;
                                          Booking.selectedGroomerImg = groomersData[
                                          'groomerImg']!;
                                          print(
                                              "Selected Groomer ID: ${Booking.selectedGroomerId}"); // Print groomer ID
                                          print(
                                              "Selected Groomer Name: ${Booking.selectedGroomerName}");
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showSelectedServices,
      //   child: Icon(Icons.check),
      // ),

      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: GestureDetector(
          onTap: () {
            Booking.selectedService = selectedServices.entries
                .where((element) => element.value == true)
                .map((e) => e.key)
                .toList();


            DateTime now = DateTime.now();
            DateTime selectedDateTime = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime?.hour ?? 0,
              _selectedTime?.minute ?? 0,
            );

            if (_selectedDate.isBefore(DateTime(
                now.year, now.month, now.day))) {
              Fluttertoast.showToast(
                msg: "Please select a valid date in the future.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            } else if (_selectedDate.isAtSameMomentAs(DateTime(
                now.year, now.month, now.day)) &&
                selectedDateTime.isBefore(now)) {
              Fluttertoast.showToast(
                msg: "Please select a valid time in the future.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            }
            else if (_selectedTime == null) {
              Fluttertoast.showToast(
                msg: 'Please Select Time',
                gravity: ToastGravity.CENTER,
              );
            } else if (Booking.selectedService.isEmpty) {
              Fluttertoast.showToast(
                msg: 'Please Select any Service',
                gravity: ToastGravity.CENTER,
              );
            } else {
              setState(() {
                Booking.selectedTime = _selectedTime!.format(context);
                Booking.selectedServicePrice = selectedPrices;
              });

              print( Booking.formattedDate );
              print(Booking.selectedTime);
              print(Booking.selectedService);
              print(Booking.selectedGroomerId);
              print(Booking.selectedServicePrice);

              Get.to(Checkout());
            }
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
                'Book Their Special Time',
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

  // // Show selected services
  // void _showSelectedServices() {
  //   List<String> selected = selectedServices.entries
  //       .where((element) => element.value == true)
  //       .map((e) => e.key)
  //       .toList();
  //
  //   print(selected);
  //   print(Booking.selectedGroomerId);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Selected Services'),
  //         content: selected.isNotEmpty
  //             ? Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: selected.map((service) => Text(service)).toList(),
  //               )
  //             : Text('No services selected.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

// // Custom clipper to create the arrow shape
// class ArrowClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width - 20, 0);
//     path.lineTo(size.width, size.height / 2);
//     path.lineTo(size.width - 20, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
