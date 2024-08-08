import 'package:audioplayers/audioplayers.dart';
import 'package:evesguide/Tracker/calender.dart';
import 'package:evesguide/screens/common/fake.dart';
import 'package:evesguide/screens/common/health.dart';
import 'package:evesguide/screens/common/waste.dart';
import 'package:evesguide/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactManagementScreen extends StatefulWidget {
  @override
  
  _ContactManagementScreenState createState() => _ContactManagementScreenState();
  
}

class _ContactManagementScreenState extends State<ContactManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  
  

  late CollectionReference _contactsCollection;

  @override
  void initState() {
    super.initState();
    // Initialize Firestore collection
    fetchContacts();
    _contactsCollection = FirebaseFirestore.instance.collection('user_contacts');
  }

  // Fetch contacts for the current user
  Future<List<DocumentSnapshot>> fetchContacts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _contactsCollection.where('userId', isEqualTo: user.uid).get();
      return snapshot.docs;
    } else {
      return [];
    }
  }

  // Add contact to Firestore
  Future<void> addContact(String name, String number) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _contactsCollection.add({
        'userId': user.uid,
        'name': name,
        'number': '+91$number',
      });
      _nameController.clear();
      _numberController.clear();
      fetchContacts();
    }
  }

  // Update contact in Firestore
  Future<void> updateContact(String id, String newName, String newNumber) async {
    await _contactsCollection.doc(id).update({
      'name': newName,
      'number': newNumber,
      
    }
    );
    fetchContacts();
  }

  // Delete contact from Firestore
  Future<void> deleteContact(String id) async {
    await _contactsCollection.doc(id).delete();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      
      onWillPop: () async {
        // Handle back button press
        Navigator.pop(context);
        return false; // Return true to allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact Management'),
          
        ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: fetchContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No contacts found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String id = snapshot.data![index].id;
                  String name = snapshot.data![index].get('name');
                  String number = snapshot.data![index].get('number');
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(number),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Edit Contact'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: TextEditingController(text: name),
                                      decoration: InputDecoration(labelText: 'Name'),
                                      onChanged: (value) => name = value,
                                    ),
                                    TextField(
                                      controller: TextEditingController(text: number),
                                      decoration: InputDecoration(labelText: 'Number'),
                                      onChanged: (value) => number = value,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      updateContact(id, name, number);
                                      fetchContacts();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteContact(id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Add Contact'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _numberController,
                      decoration: InputDecoration(labelText: 'Number'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addContact(_nameController.text.trim(), _numberController.text.trim());
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        
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
                    MaterialPageRoute(builder: (context) => panda()),
                  );
                 
                },
              ),
              IconButton(
                 icon: Icon(Icons.school_outlined),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OpportunitiesApp()),
                  );
                 
                 
                },
              ),
              IconButton(
                icon: Icon(Icons.home_outlined),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.contacts),
                iconSize: 30,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ContactManagementScreen()),
                  );
                  
                },
              ),
              IconButton(
                icon: Icon(Icons.calendar_month_outlined),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()),
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
