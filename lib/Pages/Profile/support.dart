
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/splash_screenn.dart';

class Support extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
        backgroundColor: SplashScreen.selectedColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "How can we help you?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),

              // Contact Us Section
              Text(
                "If you have any questions or need assistance, feel free to contact our support team:",
                style: TextStyle(fontSize: 16,color: Colors.black54),
              ),
              SizedBox(height: 16),

              // Contact Details
              Card(
                elevation: 4,
                color: SplashScreen.selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.black54),
                        title: Text("Email:"),
                        subtitle: Text("support@pups.com"),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.black54),
                        title: Text("Phone:"),
                        subtitle: Text("+91 987 555 3322"),
                      ),
                      ListTile(
                        leading: Icon(Icons.chat, color: Colors.black54),
                        title: Text("Whatsapp Chat:"),
                        subtitle: Text("Available Mon-Fri, 9 AM - 6 PM"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // FAQ Section
              Card(
                elevation: 4,
                color: SplashScreen.selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.black54),
                  title: Text("FAQ Section"),
                  subtitle: Text("Visit our FAQ section for common questions and answers."),
                  onTap: () {
                    // Navigate to FAQ page (if implemented)
                  },
                ),
              ),
              SizedBox(height: 16),

              // Pet Care Assistance Section
              Text(
                "Pet Care Assistance",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                "Have a question about our services or need help with booking? Our team is ready to assist with all your pet care needs.",
                style: TextStyle(fontSize: 16,color: Colors.black54),
              ),
              SizedBox(height: 16),

              // Technical Support Section
              Text(
                "Technical Support",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                "Facing any technical issues or app bugs? Reach out to our tech team and we'll get it sorted right away.",
                style: TextStyle(fontSize: 16,color: Colors.black54),
              ),
              SizedBox(height: 24),

              // Contact Support Button
              Center(
                child: ElevatedButton.icon(
                   onPressed: (){
                     whatsapp();
                   },
                  icon: Icon(Icons.support_agent,color: Colors.white,),
                  label: Text("Contact Support",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(
                        0xFF6A5ACD),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  whatsapp() async{
    var contact = "+918072875342";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{
   print('Error');
    }
  }

}
