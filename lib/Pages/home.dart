import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pups/Pages/Booking/pet_select.dart';
import 'package:pups/Widgets/splash_screenn.dart';
import 'package:uuid/uuid.dart';

import 'Booking/booking.dart';

class Home extends StatefulWidget {
  static String userName = '';
  static String userPhone = '';
  static String userEmail = '';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int currentIndex = 1;
  var uuid = const Uuid();

  List<String> slideImage = [
    'assets/slide1.png',
    'assets/slide2.png',
    'assets/slide3.png',
  ];

  List<String> complexCare = [
    'Health Assessments',
    'Allergy Treatments',
    'Skin & Coat Care',
    'Mobility Support (for older pets)',
    'Post-Surgical Grooming',
    'Veterinary Grooming Collaboration',
    'Special Needs Grooming',
    'Weight Management Support',
    'Joint & Muscle Therapy',
    'Flea & Tick Control',
  ];

  List<String> spaCare = [
    'Aromatherapy Baths',
    'Pawdicures (Paw Massage & Care)',
    'Fur Conditioning Treatments',
    'Deep Coat Cleansing',
    'De-Stress Massages',
    'Paw Smoothing & Repair',
    'Hydrating Skin Treatments',
    'Pet Relaxation Music Therapy',
    'Joint & Muscle Therapy',
    'Seasonal Coat Protection',
  ];

  List<String> creativeCare = [
    'Fur Dyeing (Pet-safe coloring)',
    'Stylish Haircuts & Patterns',
    'Temporary Fur Tattoos',
    'Custom Hair Designs (Mohawks, etc.)',
    'Glitter Fur Spray',
    'Festive Styling for Holidays',
    'Braids & Fur Accessories',
    'Special Occasion Grooming',
    'Designer Pet Apparel Fitting',
    'Nail Painting',
  ];

  List<String> hygienicCare = [
    'Regular Bathing',
    'Nail Trimming & Filing',
    'Ear Cleaning & Inspection',
    'Anal Gland Expression',
    'Eye Cleaning & Tear Stain Removal',
    'Teeth Brushing & Dental Care',
    'De-Shedding Treatments',
    'Flea & Tick Baths',
    'Sanitary Trimming',
    'Odor Control Treatments',
  ];

  List<String> otherService = [
    'Pet Taxi (Pickup & Drop-off for Appointments)',
    'Pet Sitting & Daycare',
    'Nutrition Consulting',
    'Pet Photography',
    'Pet Fitness Programs',
    'Behavioral Consulting',
    'Pet Travel Grooming',
    'Puppy/Kitten First Groom',
    'Senior Pet Grooming',
  ];

  List<String> felineCare = [
    'Gentle Bathing',
    'De-Shedding Treatment',
    'Pawdicure (Nail Trimming & Soft Paw Caps)',
    'Ear Cleaning',
    'Tear Stain Removal',
    'Anti-Matting Solutions',
    'Flea & Tick Control',
    'Lion Cut Styling',
    'Skin & Allergy Care',
  ];

  @override
  void initState() {
    super.initState();
    getUserDetailFirebase();
  }

  getUserDetailFirebase() async {

      await Hive.openBox("UserDetails");
      var box = Hive.box('UserDetails');
      var userid = box.get('user_id');

      print('useridqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
      print(userid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> doc =
          documentSnapshot.data() as Map<String, dynamic>;
          if (!mounted) return;
          setState(() {
            Home.userName = doc['userName'].toString();
            Home.userPhone = doc['userPhone'].toString();
            Home.userEmail = doc['userEmail'].toString();
          });
          print(Home.userName);
          print(Home.userPhone);
          print(Home.userEmail);
        } else {
          print('Current Name does not exist on the database');
        }
      });

  }

  add() async {
    String id = '';
    if (mounted) {
      setState(() {
        id = uuid.v4();
      });
    }
    await FirebaseFirestore.instance
        .collection('pets')
        .doc(id)
        .set({
      'petId': id,
      'petImage': 'https://firebasestorage.googleapis.com/v0/b/pups-8b213.appspot.com/o/Maine%20Coon.png?alt=media&token=13239575-45bb-4317-b780-0b90fa10f3aa',
      'petName': 'Maine Coon',
      'petDes': 'Gentle giants, friendly, and highly intelligent',
      'petType':'cat'
    });

    print(id);
    print('added');
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Row(
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(24), // Image radius
                          child: Image.asset(SplashScreen.selectedImage),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        Home.userName.isNotEmpty
                            ? 'Hello, ${Home.userName.replaceFirst(Home.userName[0], Home.userName[0].toUpperCase())}'
                            : 'Hello,',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 30, 0, 0),
                    child: Text(
                      'Premium Care',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: slideImage.isNotEmpty
                      ? CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          // currentIndex = index;
                        });
                      },
                    ),
                    items: slideImage
                        .map(
                          (item) => Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  )
                      : Text("No images available"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 20, 0, 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Time for a Grooming Session!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Color(0xFFB4E6FF),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/tab1.png',
                        ),
                      ),
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFC8EF),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          'assets/tab2.png',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(
                        0xFF6A5ACD), // A soft purple to complement the background
                    padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical:
                        12), // Add padding for a better touch target
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Rounded corners for a modern look
                    ),
                  ),
                  onPressed: () {
                   Get.to(PetSelect());
                  },
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 20, 0, 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pet Care Excellence',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                ),



                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allow elements to be positioned outside the container
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.6,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFA0CBFE),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 20, 0, 10),
                                            child: Text(
                                              'Complex Care',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: complexCare
                                                  .length, // Number of items in the list
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  child: Container(
                                                    height: 80,
                                                    child: Card(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              complexCare[
                                                              index],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                            leading:
                                                            Image.asset(
                                                              'assets/splash_logo.png',
                                                              width:
                                                              70, // Set the width of the image
                                                              height:
                                                              70, // Set the height of the image
                                                              fit: BoxFit
                                                                  .cover, // You can adjust this for fitting inside the box
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                      -60, // Move the button upwards by setting a negative value
                                      right: 10,

                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFA0CBFE),
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFA0CBFE),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(CupertinoIcons.heart_fill,size: 34,color: Colors.black54),
                            Text(
                              'Complex Care',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allow elements to be positioned outside the container
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.6,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(
                                            0xFFCCF9B8), // Adjust the background color
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 20, 0, 10),
                                            child: Text(
                                              'SPA Service',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: spaCare
                                                  .length, // Number of items in the list
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  child: Container(
                                                    height: 80,
                                                    child: Card(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              spaCare[index],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                            leading:
                                                            Image.asset(
                                                              'assets/splash_logo.png',
                                                              width:
                                                              70, // Set the width of the image
                                                              height:
                                                              70, // Set the height of the image
                                                              fit: BoxFit
                                                                  .cover, // You can adjust this for fitting inside the box
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                      -60, // Move the button upwards by setting a negative value
                                      right: 10,

                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFCCF9B8),
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFCCF9B8),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.beach_access,size: 34,color: Colors.black54),
                            Text(
                              'SPA Service',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allow elements to be positioned outside the container
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.6,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFC8EF),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 20, 0, 10),
                                            child: Text(
                                              'Creative Grooming',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: creativeCare
                                                  .length, // Number of items in the list
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  child: Container(
                                                    height: 80,
                                                    child: Card(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              creativeCare[
                                                              index],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                            leading:
                                                            Image.asset(
                                                              'assets/splash_logo.png',
                                                              width:
                                                              70, // Set the width of the image
                                                              height:
                                                              70, // Set the height of the image
                                                              fit: BoxFit
                                                                  .cover, // You can adjust this for fitting inside the box
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                      -60, // Move the button upwards by setting a negative value
                                      right: 10,

                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFC8EF),
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFC8EF),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.compost_rounded,size: 34,color: Colors.black54),
                            Text(
                              'Creative Grooming',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allow elements to be positioned outside the container
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.6,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFB4E6FF),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 20, 0, 10),
                                            child: Text(
                                              'Hygienic Care',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: hygienicCare
                                                  .length, // Number of items in the list
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  child: Container(
                                                    height: 80,
                                                    child: Card(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              hygienicCare[
                                                              index],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                            leading:
                                                            Image.asset(
                                                              'assets/splash_logo.png',
                                                              width:
                                                              70, // Set the width of the image
                                                              height:
                                                              70, // Set the height of the image
                                                              fit: BoxFit
                                                                  .cover, // You can adjust this for fitting inside the box
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                      -60, // Move the button upwards by setting a negative value
                                      right: 10,

                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFB4E6FF),
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFB4E6FF),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.cruelty_free_rounded,size: 34,color: Colors.black54),
                            Text(
                              'Hygienic Care',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allow elements to be positioned outside the container
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.6,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFB0F8E0),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 20, 0, 10),
                                            child: Text(
                                              'Feline Care',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: felineCare
                                                  .length, // Number of items in the list
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  child: Container(
                                                    height: 80,
                                                    child: Card(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              felineCare[
                                                              index],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                            leading:
                                                            Image.asset(
                                                              'assets/splash_logo.png',
                                                              width:
                                                              70, // Set the width of the image
                                                              height:
                                                              70, // Set the height of the image
                                                              fit: BoxFit
                                                                  .cover, // You can adjust this for fitting inside the box
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                      -60, // Move the button upwards by setting a negative value
                                      right: 10,

                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFB0F8E0),
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFB0F8E0),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.eco_rounded,size: 34,color: Colors.black54,),
                            Text(
                              'Feline Care',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allow elements to be positioned outside the container
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.6,
                                      width:
                                      MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFD1C6FF),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 20, 0, 10),
                                            child: Text(
                                              'Other Service',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: otherService
                                                  .length, // Number of items in the list
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  child: Container(
                                                    height: 80,
                                                    child: Card(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              otherService[
                                                              index],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                            leading:
                                                            Image.asset(
                                                              'assets/splash_logo.png',
                                                              width:
                                                              70, // Set the width of the image
                                                              height:
                                                              70, // Set the height of the image
                                                              fit: BoxFit
                                                                  .cover, // You can adjust this for fitting inside the box
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                      -60, // Move the button upwards by setting a negative value
                                      right: 10,

                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFD1C6FF),
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFD1C6FF),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.emoji_emotions_rounded,size: 34,color: Colors.black54,),
                            Text(
                              'Other Services',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                SizedBox(
                  height: 40,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}





