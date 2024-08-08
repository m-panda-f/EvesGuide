// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

// Model for Doctor
class Doctor {
  final String id;
  final String name;
  final String specialty;

  Doctor({required this.id, required this.name, required this.specialty});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
    );
  }
}

// Model for Appointment
class Appointment {
  final String doctorId;
  final DateTime dateTime;

  Appointment({required this.doctorId, required this.dateTime});

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

// Symptom model
class Symptom {
  final String title;
  final String description;
  final String link;

  Symptom({required this.title, required this.description, required this.link});
}

// Symptom Screen
class SymptomsScreen extends StatelessWidget {
  final List<Symptom> symptoms = [
    Symptom(
      title: "Missed Periods",
      description: "Missing periods can be a sign of pregnancy, stress, or hormonal imbalances.",
      link: "https://www.healthline.com/health/womens-health/why-is-my-period-late",
    ),
    Symptom(
      title: "Fatigue",
      description: "Feeling more tired than usual can be related to hormonal changes.",
      link: "https://www.healthline.com/health/fatigue",
    ),
    Symptom(
      title: "Weight Gain",
      description: "Unexpected weight gain can be due to hormonal fluctuations.",
      link: "https://www.healthline.com/health/unintentional-weight-gain",
    ),
    Symptom(
      title: "Mood Swings",
      description: "Changes in mood can be caused by hormonal imbalances.",
      link: "https://www.healthline.com/health/mood-swings",
    ),
    Symptom(
      title: "Acne",
      description: "Hormonal changes can lead to increased acne.",
      link: "https://www.healthline.com/health/acne",
    ),
    Symptom(
      title: "Headaches",
      description: "Hormonal fluctuations can cause frequent headaches or migraines.",
      link: "https://www.healthline.com/health/migraine/hormonal-headache",
    ),
    Symptom(
      title: "Breast Tenderness",
      description: "Hormonal changes can make the breasts feel sore or tender.",
      link: "https://www.healthline.com/health/breast-tenderness",
    ),
    Symptom(
      title: "Sleep Problems",
      description: "Insomnia or changes in sleep patterns can be related to hormonal changes.",
      link: "https://www.healthline.com/health/sleep-disorders",
    ),
    Symptom(
      title: "Hair Loss",
      description: "Hormonal imbalances can contribute to hair thinning or hair loss.",
      link: "https://www.healthline.com/health/womens-health/hormonal-hair-loss",
    ),
    Symptom(
      title: "Hot Flashes",
      description: "Sudden feelings of warmth, usually most intense over the face, neck, and chest.",
      link: "https://www.healthline.com/health/menopause/hot-flashes",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skipped Period Symptoms"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                symptoms[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              subtitle: Text(
                symptoms[index].description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.info_outline, color: Colors.pinkAccent),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(symptoms[index].title),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(symptoms[index].description),
                            SizedBox(height: 10),
                            GestureDetector(
                              child: Text(
                                "Learn more",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                _launchURL(context, symptoms[index].link);
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}

// Appointment Form
class AppointmentForm extends StatefulWidget {
  final Doctor doctor;

  AppointmentForm({required this.doctor});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    final appointment = Appointment(
      doctorId: widget.doctor.id,
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
    );

    final response = await http.post(
      Uri.parse('http://your-backend-url.com/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson()),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(_selectedDate == null
              ? 'Select Date'
              : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
          trailing: Icon(Icons.calendar_today, color: Colors.pinkAccent),
          onTap: _pickDate,
        ),
        ListTile(
          title: Text(_selectedTime == null
              ? 'Select Time'
              : 'Selected Time: ${_selectedTime.format(context)}'),
          trailing: Icon(Icons.access_time, color: Colors.pinkAccent),
          onTap: _pickTime,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _bookAppointment,
          child: Text('Book Appointment'),
        ),
      ],
    );
  }
}

// Doctors Screen
class DoctorsScreen extends StatefulWidget {
  @override
  _DoctorsScreenState createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  Future<List<Doctor>> _fetchDoctors() async {
    final response = await http.get(Uri.parse('http://your-backend-url.com/doctors'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((doctor) => Doctor.fromJson(doctor)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<Doctor>>(
        future: _fetchDoctors(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      snapshot.data![index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    subtitle: Text(snapshot.data![index].specialty),
                    trailing: Icon(Icons.call, color: Colors.pinkAccent),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: Text("Book Appointment with ${snapshot.data![index].name}"),
                            content: AppointmentForm(doctor: snapshot.data![index]),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// Main Application

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women\'s Health App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Panda(),
    );
  }
}

class Panda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Women\'s Health'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('View Symptoms'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SymptomsScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('View Doctors'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _launchURL(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $url')),
    );
  }
}