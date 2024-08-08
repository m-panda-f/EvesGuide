import 'package:project/Tracker/calender.dart';
import 'package:project/screens/Articles/Contacts.dart';
import 'package:project/screens/common/Health.dart';
import 'package:project/screens/common/waste.dart';

import 'package:project/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
 

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    
    
  }
   Future<List<DocumentSnapshot>> fetchDoctors() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .get();
      return snapshot.docs;
    } else {
      return [];
    }
  }

  void _addAppointment() {
  showDialog(
    context: context,
    builder: (context) {
      final doctorController = TextEditingController();
      final dateController = TextEditingController();
      final timeController = TextEditingController();

      return AlertDialog(
        title: Text('Add Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: doctorController,
              decoration: InputDecoration(labelText: 'Doctor'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  dateController.text = pickedDate.toString().split(' ')[0];
                }
              },
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time'),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  timeController.text = pickedTime.format(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _firestore.collection('appointments').add({
                'userId': _currentUser!.uid,
                'doctor': doctorController.text,
                'date': dateController.text,
                'time': timeController.text,
              });
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

void _editAppointment(String id) {
  showDialog(
    context: context,
    builder: (context) {
      final doctorController = TextEditingController();
      final dateController = TextEditingController();
      final timeController = TextEditingController();

      // Fetch the current appointment data
      _firestore.collection('appointments').doc(id).get().then((doc) {
        doctorController.text = doc['doctor'];
        dateController.text = doc['date'];
        timeController.text = doc['time'];
      });

      return AlertDialog(
        title: Text('Edit Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: doctorController,
              decoration: InputDecoration(labelText: 'Doctor'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(dateController.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  dateController.text = pickedDate.toString().split(' ')[0];
                }
              },
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time'),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.parse("1970-01-01 ${timeController.text}")),
                );
                if (pickedTime != null) {
                  timeController.text = pickedTime.format(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _firestore.collection('appointments').doc(id).update({
                'doctor': doctorController.text,
                'date': dateController.text,
                'time': timeController.text,
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


  void _deleteAppointment(String id) {
    _firestore.collection('appointments').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Appointments'),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('appointments')
            .where('userId', isEqualTo: _currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final appointments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              return ListTile(
                title: Text(appointment['doctor']
                   ),
                subtitle: Text(appointment['date']
                    + ' at ' + appointment['time']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editAppointment(appointment.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteAppointment(appointment.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAppointment,
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
                icon: Icon(Icons.local_hospital),
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
                    context,
                  PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
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
      
    );
  }
}
