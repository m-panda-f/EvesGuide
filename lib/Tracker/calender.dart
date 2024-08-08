// ignore_for_file: unused_local_variable
import 'package:project/screens/common/Health.dart';
import 'package:project/screens/common/waste.dart';
import 'package:project/screens/home.dart';
import 'package:project/screens/Articles/Contacts.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddEvent.dart'; // Assuming this is where EventForm is defined

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _events = [];
  DateTime? _selectedStartDate; // Track the selected start date
  int _periodDuration = 1; // Default period duration
  int _averageCycleLength = 28; // Default average cycle length
  final TextEditingController _periodDurationController = TextEditingController();
  final TextEditingController _averageCycleLengthController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents();
    fetchAndSetPeriodDetails();
  }
  
  Future<void> fetchAndSetPeriodDetails() async {
    Map<String, dynamic>? periodData = await _getPeriodDetails();
    if (periodData != null) {
      // Convert startDate to DateTime and keep other values as they are
      setState(() {
        _selectedStartDate = DateTime.parse(periodData['startDate']);
        _periodDuration = periodData['duration'];
        _averageCycleLength = periodData['cycleLength'];
      });
    }
  }

  Future<Map<String, dynamic>?> _getPeriodDetails() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('periods').doc(user!.uid).get();
      if (snapshot.exists) {
        return {
          'startDate': snapshot['startDate'],
          'duration': snapshot['duration'],
          'cycleLength': snapshot['cycleLength'],
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting period details: $e');
      return null;
    }
  }

  void _showPeriodDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime startDate = _selectedStartDate ?? _focusedDay;

        return AlertDialog(
          title: Text('Enter Period Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start Date: ${startDate.toLocal().toString().split(' ')[0]}'), // Displaying date without time
              SizedBox(height: 8),
              Text('Period Duration (1-8 days)'),
              TextField(
                controller: _periodDurationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter duration',
                ),
                onChanged: (value) {
                  setState(() {
                    _periodDuration = int.tryParse(value) ?? 1;
                  });
                },
              ),
              SizedBox(height: 8),
              Text('Average Cycle Length (days)'),
              TextField(
                controller: _averageCycleLengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter cycle length',
                ),
                onChanged: (value) {
                  setState(() {
                    _averageCycleLength = int.tryParse(value) ?? 28;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                int? duration = int.tryParse(_periodDurationController.text);
                int? cycleLength = int.tryParse(_averageCycleLengthController.text);
                if (duration != null && duration >= 1 && duration <= 8 &&
                    cycleLength != null && cycleLength > 0) {
                  setState(() {
                    _periodDuration = duration;
                    _averageCycleLength = cycleLength;
                    if (_selectedStartDate == null) {
                      _selectedStartDate = _focusedDay;
                    }
                  });

                  await _storePeriodDetails(_selectedStartDate!, _periodDuration, _averageCycleLength); // Store data in Firestore

                  Navigator.of(context).pop();
                } else {
                  // Show error if input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid inputs.')),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _storePeriodDetails(DateTime startDate, int duration, int cycleLength) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('periods').doc(user!.uid).set({
        'userId': user!.uid,
        'startDate': startDate.toIso8601String(),
        'duration': duration,
        'cycleLength': cycleLength,
      });
    }
  }

  Future<void> _deletePeriodDetails() async {
    try {
      if (user != null) {
        await FirebaseFirestore.instance.collection('periods').doc(user!.uid).delete();
        setState(() {
          _selectedStartDate = null;
        });
      }
    } catch (e) {
      print('Failed to delete period details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete period details.')),
      );
    }
  }

  Future<void> _updatePeriodDetails(DateTime startDate, int duration, int cycleLength) async {
    if (user != null) {
      await _firestore.collection('periods').doc(user!.uid).update({
        'startDate': startDate.toIso8601String(),
        'duration': duration,
        'cycleLength': cycleLength,
      });
    }
  }

  void _showEditPeriodDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime startDate = _selectedStartDate ?? _focusedDay;
        final TextEditingController _editPeriodDurationController =
            TextEditingController(text: _periodDuration.toString());
        final TextEditingController _editAverageCycleLengthController =
            TextEditingController(text: _averageCycleLength.toString());

        return AlertDialog(
          title: Text('Edit Period Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Start Date: ${startDate.toLocal().toString().split(' ')[0]}'), // Displaying date without time
              SizedBox(height: 8),
              Text('New Start Date'),
              TextField(
                controller: TextEditingController(
                  text: startDate.toLocal().toString().split(' ')[0],
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (picked != null && picked != startDate) {
                    setState(() {
                      startDate = picked;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Pick a new start date',
                ),
              ),
              SizedBox(height: 8),
              Text('Period Duration (1-8 days)'),
              TextField(
                controller: _editPeriodDurationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter duration',
                ),
              ),
              SizedBox(height: 8),
              Text('Average Cycle Length (days)'),
              TextField(
                controller: _editAverageCycleLengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter cycle length',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                int? duration = int.tryParse(_editPeriodDurationController.text);
                int? cycleLength = int.tryParse(_editAverageCycleLengthController.text);
                if (duration != null && duration >= 1 && duration <= 8 &&
                    cycleLength != null && cycleLength > 0) {
                  setState(() {
                    _selectedStartDate = startDate;
                    _periodDuration = duration;
                    _averageCycleLength = cycleLength;
                  });

                  await _updatePeriodDetails(
                      _selectedStartDate!, _periodDuration, _averageCycleLength); // Update data in Firestore

                  Navigator.of(context).pop();
                } else {
                  // Show error if input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid inputs.')),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog() {
    if (_selectedDay != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventForm(selectedDay: _selectedDay!),
        ),
      ).then((_) => _fetchEvents()); // Refresh events after adding a new one
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date first.')),
      );
    }
  }

  List<DateTime> _getAllPredictedPeriodDates() {
    List<DateTime> dates = [];
    if (_selectedStartDate != null) {
      DateTime startDate = _selectedStartDate!;
      while (startDate.isBefore(DateTime.now().add(Duration(days: 365 * 10)))) {
        // Predict for the next 10 years
        startDate = startDate.add(Duration(days: _averageCycleLength));
        dates.add(startDate);
      }
    }
    return dates;
  }

  List<PopupMenuEntry<String>> _getMenuOptions() {
    List<PopupMenuEntry<String>> options = [];

    if (_selectedStartDate == null) {
      options.add(
        PopupMenuItem<String>(
          value: 'Add Period',
          child: Text('Add Period'),
        ),
      );
    } else {
      options.add(
        PopupMenuItem<String>(
          value: 'Edit Period Dates',
          child: Text('Edit Period Dates'),
        ),
      );
      options.add(
        PopupMenuItem<String>(
          value: 'Delete Period Dates',
          child: Text('Delete Period Dates'),
        ),
      );
    }

    options.add(
      PopupMenuItem<String>(
        value: 'Add Event',
        child: Text('Add Event'),
      ),
    );

    return options;
  }

  Future<void> _fetchEvents() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_selectedDay != null && user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(_selectedDay!.subtract(Duration(days: 0))))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(_selectedDay!.add(Duration(days: 0))))
          .get();

      setState(() {
        _events = snapshot.docs.map((doc) {
          final eventData = doc.data() as Map<String, dynamic>;
          eventData['id'] = doc.id; // Add document ID (eventId)
          return eventData;
        }).toList();
      });
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event was deleted')),
      );
      _fetchEvents(); // Refresh events after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event')),
      );
      print('Failed to delete event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Add Period':
                  _showPeriodDetailsDialog();
                  break;
                case 'Edit Period Dates':
                  _showEditPeriodDetailsDialog();
                  break;
                case 'Add Event':
                  _showAddEventDialog();
                  break;
                case 'Delete Period Dates':
                  _deletePeriodDetails();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return _getMenuOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarBuilders: CalendarBuilders(
               defaultBuilder: (context, day, selectedDay) {
            if (_selectedStartDate != null) {
              // Calculate and highlight current period
              if (day.isAfter(_selectedStartDate!.subtract(Duration(days: 0))) &&
                  day.isBefore(_selectedStartDate!.add(Duration(days: _periodDuration)))) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFF56D6D),
                    shape: BoxShape.circle,
                  ),
                  child: Text(day.day.toString()),
                );
              }
                  // Highlight predicted periods
                  for (DateTime date in _getAllPredictedPeriodDates()) {
                if (day.isAfter(date.subtract(Duration(days: 0))) &&
                    day.isBefore(date.add(Duration(days: _periodDuration)))) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFF56D6D),
                      shape: BoxShape.circle,
                    ),
                    child: Text(day.day.toString()),
                  );
                }
              }}
              for (DateTime date in _getAllPredictedPeriodDates()) {
                if (day.isAfter(date.subtract(Duration(days: 0))) &&
                    day.isBefore(date.add(Duration(days: _periodDuration+8)))) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFC3E7F3),
                      shape: BoxShape.circle,
                    ),
                    child: Text(day.day.toString()),
                  );
                }
              }
              if (_selectedStartDate != null){
                if (day.isAfter(_selectedStartDate!.subtract(Duration(days: 0))) &&
                  day.isBefore(_selectedStartDate!.add(Duration(days: _periodDuration+8)))) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFC3E7F3),
                      shape: BoxShape.circle,
                    ),
                    child: Text(day.day.toString()),
                  );
                  
                
                }
              }
                
                    

                return null; // Return null for days that do not need special decoration
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchEvents();
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Note/Events',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'), // Displaying the index as a number bullet
                        ),
                        title: Text(_events[index]['title']),
                        subtitle: Text(_events[index]['description'] ?? ''),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEvent(_events[index]['id']),
                        ),
                      );
                    },
                  ),
                ),
                
              ],
            ),
          ),
          
        ],
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
                    MaterialPageRoute(builder: (context) => EvesGuideApp()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.contacts_outlined),
                iconSize: 30,
                onPressed: () {Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ContactManagementScreen()),
                  );
                  
                },
              ),
              IconButton(
                icon: Icon(Icons.calendar_month_rounded),
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
      
    );
  }
}
