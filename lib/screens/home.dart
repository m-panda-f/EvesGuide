import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:evesguide/Tracker/calender.dart';
import 'package:evesguide/Login/waste.dart';
import 'package:evesguide/screens/Articles/articles.dart';
import 'package:evesguide/screens/common/fake.dart';
import 'package:evesguide/screens/common/Health.dart';
import 'package:evesguide/profiles/privacy.dart';
import 'package:evesguide/screens/common/waste.dart';
import 'package:http/http.dart' as http;

import 'package:evesguide/profiles/profile.dart';
import 'package:evesguide/screens/Articles/Contacts.dart';


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class EvesGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eve's Guide",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primaryColor: Color(0xFFEB6C96),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? lastPressed;
  final Random random = Random();
  
  String? _profilePictureUrl;
  final List<String> motivationalQuotes = [
    "Empowered women empower women.",
    "Believe in yourself and all that you are.",
    "She believed she could, so she did.",
    "Strong women don't have attitudes; they have standards.",
    "A girl should be two things: who and what she wants.",
    "The future is female.",
    "You are capable of amazing things.",
    "Be the woman who fixes another woman's crown without telling the world it was crooked.",
    "You are more powerful than you know; you are beautiful just as you are.",
    "Here's to strong women: may we know them, may we be them, may we raise them."
  ];
  late final String motivationalQuote;
  final FirebaseAuth _auth = FirebaseAuth.instance;
   Location location = Location();
  LocationData? currentLocation;
 

  void initPlatformState() async {
    await location.requestPermission();
  }

Future<List<DocumentSnapshot>> fetchContacts() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user_contacts') // Corrected to use FirebaseFirestore.instance.collection
        .where('userId', isEqualTo: user.uid)
        .get();
    return snapshot.docs;
  } else {
    return [];
  }
}

void triggerSOS() async {
  List<DocumentSnapshot> contacts = await fetchContacts();
  List<String> recipientNumbers = contacts.map((doc) => (doc.data() as Map<String, dynamic>)['number'].toString()).toList().cast<String>();
  sendWhatsAppMessages(recipientNumbers);  // Send WhatsApp message with location link
}
  

  Future<void> sendWhatsAppMessages(List<String> recipientNumbers) async {
    if (currentLocation != null) {
      final double latitude = currentLocation!.latitude!;
      final double longitude = currentLocation!.longitude!;
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      final accountSid = 'AC621836db3994197afa9ba0c354226767'; // Replace with your Twilio Account SID
      final authToken = '8db11f56f56b74e3e208b764b11bbc29'; // Replace with your Twilio Auth Token
      final twilioNumber = '+17624004081'; // Replace with your Twilio WhatsApp number

      for (String recipientNumber in recipientNumbers) {
        final uri = Uri.parse(
          'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json',
        );
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Authorization': 'Basic ' +
                base64Encode(utf8.encode('$accountSid:$authToken')),
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: <String, String>{
            'From': twilioNumber,
            'To': recipientNumber,
            'Body': 'Emergency! Need immediate assistance. Please Help Location: $googleMapsUrl',
          },
        );

        if (response.statusCode == 201) {
          print('Message sent to $recipientNumber successfully');
        } else {
          print('Failed to send message to $recipientNumber: ${response.reasonPhrase}');
        }
      }
    }
  }
  
 
 


  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
    motivationalQuote = motivationalQuotes[random.nextInt(motivationalQuotes.length-1)];
    initPlatformState();
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  Future<void> _loadProfilePicture() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _profilePictureUrl = doc.data()?['profilePicture'];
        });
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 1)) {
          lastPressed = now;
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFEB6C96),
          titleSpacing: 20.0,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Eve's Guide"),
          ),
          centerTitle: true,
          actions: [
            FutureBuilder<DocumentSnapshot>(
              future: _auth.currentUser != null
                  ? FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get()
                  // ignore: null_argument_to_non_null_type
                  : Future.value(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  var email = userData['email'] ?? _auth.currentUser!.email ?? "No Email";
                  var userName = userData['name'] ?? "No Name";

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      child: _profilePictureUrl != null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(_profilePictureUrl!),
                              backgroundColor: Colors.grey.shade300,
                            )
                          : const Icon(
                              Icons.account_circle,
                              size: 40,
                              color: Color(0xFF686464),
                            ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              email: email,
                              userName: userName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        
        
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome to Eve's Guide!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    

   Container(
    margin: EdgeInsets.all(5),
    padding: EdgeInsets.all(20),
    width: 300,
    height: 250,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          spreadRadius: 4,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF0EEFA),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.format_quote_rounded,
              color: Color(0xFF7165D6),
              size: 35,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Motivation",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Text(
          motivationalQuote,
          style: TextStyle(
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  )
                    
                  ],
                  
                ),
                
                SizedBox(height: 25),
                SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      InkWell(
        onTap: () async {
          final link = "https://www.google.com/maps/search/?api=1&query=police+stations+near+me" as String;
          launchUrl(Uri.parse(link),
          mode: LaunchMode.externalApplication);
        },
        child: Container(
          margin: EdgeInsets.all(5), // Add margin for spacing
          padding: EdgeInsets.all(5),
          width: 200, // Set a fixed width
          height: 200, // Set a fixed height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF0EEFA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.local_police,
                    color: Color(0xFF7165D6),
                    size: 35,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Police Station",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Find nearby police stations",
                style: TextStyle(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          // Navigate to nearby hospitals
           final link = "https://www.google.com/maps/search/?api=1&query=hospitals+near+me" as String;
          launchUrl(Uri.parse(link),
          mode: LaunchMode.externalApplication);
        },
        child: Container(
          margin: EdgeInsets.all(5), // Add margin for spacing
          padding: EdgeInsets.all(5),
          width: 200, // Set a fixed width
          height: 200, // Set a fixed height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF0EEFA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.local_hospital,
                    color: Color(0xFF7165D6),
                    size: 35,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Hospital",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Find nearby hospitals",
                style: TextStyle(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          // Navigate to nearby medicals
           final link = "https://www.google.com/maps/search/?api=1&query=medicals+near+me" as String;
          launchUrl(Uri.parse(link),
          mode: LaunchMode.externalApplication);
        },
        child: Container(
          margin: EdgeInsets.all(5), // Add margin for spacing
          padding: EdgeInsets.all(5),
          width: 200, // Set a fixed width
          height: 200, // Set a fixed height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF0EEFA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.local_pharmacy,
                    color: Color(0xFF7165D6),
                    size: 35,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Medicals",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Find nearby medicals",
                style: TextStyle(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

              
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: motivationalQuotes.length-1,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          
                          
                        },
                        
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            triggerSOS();
            final phoneNumber = "tel:112"; // replace with the actual phone number
            await launchUrl(Uri.parse(phoneNumber), mode: LaunchMode.externalApplication);
          },
          child: Icon(Icons.sos),
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFFEB6C96),
          shape: CircularNotchedRectangle(),
          notchMargin: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.medical_services_outlined),
                iconSize: 30,
                onPressed: () {
                   Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => panda(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
                  );
                },          
              ),
              IconButton(
                icon: Icon(Icons.school_outlined),
                iconSize: 30,
                onPressed: () {
                 Navigator.pushReplacement(
                    context,
                  PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => OpportunitiesApp(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
                  );
                 
                },
              ),
              IconButton(
                icon: Icon(Icons.home),
                iconSize: 30,
                onPressed: () {
                 Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => HomeScreen())
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.contacts_outlined),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                   PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ContactManagementScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
                  );
                  
                },
              ),
              IconButton(
                icon: Icon(Icons.calendar_month_outlined),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => CalendarScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
