import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pups/Pages/Booking/booking.dart';
import 'package:pups/Widgets/loading.dart';

class PetSelect extends StatefulWidget {
  static List cartPetId = [];
  const PetSelect({Key? key}) : super(key: key);

  @override
  State<PetSelect> createState() => _PetSelectState();
}

class _PetSelectState extends State<PetSelect> with TickerProviderStateMixin {
  late TabController _tabController;

  bool _Loading = false;

  List allDogData = [];
  List allCatData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    fetchDogData();
    fetchCatData();
  }

  fetchDogData() async {
    setState(() {
      _Loading =true;
      allDogData.clear();
      // shimmerEffect = true;
    });
    await FirebaseFirestore.instance
        .collection('pets')
        .where('petType', isEqualTo: 'dog')
        .snapshots()
        .listen((data) {
      setState(() {
        allDogData = data.docs; // Update the state with fetched data
      });
      print(allDogData);
    }, onError: (error) {
      // Handle error here
      print("Error getting documents: $error");
    });

    setState(() {
      _Loading =false;

    });
  }

  fetchCatData() async {
    setState(() {
      allCatData.clear();
      // shimmerEffect = true;
    });
    await FirebaseFirestore.instance
        .collection('pets')
        .where('petType', isEqualTo: 'cat')
        .snapshots()
        .listen((data) {
      setState(() {
        allCatData = data.docs; // Update the state with fetched data
      });
      print(allCatData.length);
    }, onError: (error) {
      // Handle error here
      print("Error getting documents: $error");
    });
  }

  List<String> catDataIds = []; // List to hold added cat data IDs
  bool showBottomNavBar =
      false; // Flag to control bottom navigation bar visibility

  void toggleItem(String id) {
    setState(() {
      if (catDataIds.contains(id)) {
        // Remove item if it already exists
        catDataIds.remove(id);
        // Hide bottom nav bar if list is empty
        if (catDataIds.isEmpty) {
          showBottomNavBar = false;
        }
      } else {
        // Add item if it doesn't exist
        catDataIds.add(id);
        // Show bottom nav bar when item is added
        showBottomNavBar = true;
      }
    });

    print('Current IDs in the cart: $catDataIds');
    print('Show Bottom Nav Bar: $showBottomNavBar');
  }

  @override
  Widget build(BuildContext context) {


    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return _Loading
        ? DefaultLoading()
        : Scaffold(
      backgroundColor: Colors.white,
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.36,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Color(0xFFD1C6FF),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        unselectedLabelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Color(0xFF6A5ACD),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        tabs: [
                          Tab(
                            child: Image.asset(
                              'assets/tab1.png',
                              width: 50,
                            ),
                          ),
                          Tab(
                            child: Image.asset(
                              'assets/tab2.png',
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Assign a fixed height for TabBarView
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: allDogData
                                  .length, // Number of items in the list
                              itemBuilder: (context, index) {
                                var dogData = allDogData[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 12, 4),
                                  child: Container(
                                    height: h * 0.16,
                                    width: w * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            child: Image.network(
                                              dogData['petImage'],
                                              width: w * 0.3,
                                              fit: BoxFit
                                                  .cover, // Ensures the image covers the space without distortion
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                16), // Space between image and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // Aligns text to the left
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center vertically within the column
                                            children: [
                                              Text(
                                                dogData['petName'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                  height:
                                                      4), // Space between title and description
                                              Text(
                                                dogData['petDes'],
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8,
                                              8,
                                              8,
                                              8), // Adjust padding for the button
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                toggleItem(dogData['petId']);
                                              },
                                              child: Icon(
                                                catDataIds.contains(
                                                        dogData['petId'])
                                                    ? Icons.remove
                                                    : Icons.add,
                                                color: Colors.white,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF6A5ACD),
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: allCatData
                                  .length, // Number of items in the list
                              itemBuilder: (context, index) {
                                var catData = allCatData[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 12, 4),
                                  child: Container(
                                    height: h * 0.16,
                                    width: w * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            child: Image.network(
                                              catData['petImage'],
                                              width: w * 0.3,
                                              fit: BoxFit
                                                  .cover, // Ensures the image covers the space without distortion
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                16), // Space between image and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // Aligns text to the left
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center vertically within the column
                                            children: [
                                              Text(
                                                catData['petName'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                  height:
                                                      4), // Space between title and description
                                              Text(
                                                catData['petDes'],
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8,
                                              8,
                                              8,
                                              8), // Adjust padding for the button
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                toggleItem(catData['petId']);
                                              },
                                              child: Icon(
                                                catDataIds.contains(
                                                    catData['petId'])
                                                    ? Icons.remove
                                                    : Icons.add,
                                                color: Colors.white,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF6A5ACD),
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: showBottomNavBar
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          PetSelect.cartPetId = catDataIds;
                        });
                        print( PetSelect.cartPetId);

                        Get.to(Booking());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF6A5ACD),
                        ),
                        width: 300,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Pick Your Paw Partner',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          18, // Increase font size for better visibility
                                      fontWeight: FontWeight
                                          .bold, // Make the text bold for emphasis
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    catDataIds.length.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(
                                          0xFF6A5ACD), // Match text color with button background
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          );
  }
}
