// services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>?> getPeriodDetails(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('periods').doc(userId).get();
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

  Future<void> storePeriodDetails(String userId, DateTime startDate, int duration, int cycleLength) async {
    try {
      await _firestore.collection('periods').doc(userId).set({
        'userId': userId,
        'startDate': startDate.toIso8601String(),
        'duration': duration,
        'cycleLength': cycleLength,
      });
    } catch (e) {
      print('Error storing period details: $e');
      throw e;
    }
  }

  Future<void> updatePeriodDetails(String userId, DateTime startDate, int duration, int cycleLength) async {
    try {
      await _firestore.collection('periods').doc(userId).update({
        'startDate': startDate.toIso8601String(),
        'duration': duration,
        'cycleLength': cycleLength,
      });
    } catch (e) {
      print('Error updating period details: $e');
      throw e;
    }
  }

  Future<void> deletePeriodDetails(String userId) async {
    try {
      await _firestore.collection('periods').doc(userId).delete();
    } catch (e) {
      print('Error deleting period details: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> fetchEvents(DateTime selectedDay, String userId) async {
    List<Map<String, dynamic>> events = [];

    try {
      final snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDay.subtract(Duration(days: 0))))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(selectedDay.add(Duration(days: 0))))
          .get();

      events = snapshot.docs.map((doc) {
        final eventData = doc.data() as Map<String, dynamic>;
        eventData['id'] = doc.id;
        return eventData;
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
    }

    return events;
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
      throw e;
    }
  }
}
