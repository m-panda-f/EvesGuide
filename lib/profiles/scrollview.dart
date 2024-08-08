import 'package:audioplayers/audioplayers.dart';
import 'package:evesguide/screens/Articles/articles.dart';
import 'package:evesguide/screens/common/fake.dart';
import 'package:evesguide/profiles/privacy.dart';
import 'package:evesguide/profiles/symptoms.dart';
import 'package:flutter/material.dart';
import 'package:evesguide/screens/common/fake.dart' as fake;
import 'package:flutter/widgets.dart';

class OptionsScrollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildSafety(context),
        _buildPrivacy(context),
      
        _buildappoint(context),
      ]  
    );
  }

  Widget _buildSafety(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ArticleScreen()),
                  );
        // Navigate to safety articles screen
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEB6C96), Color(0xFFCEE2E3)],
          ),
          borderRadius: BorderRadius.circular(35.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Row(
                  children: [
                    Text(
                      'Safety Articles',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 120.0),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildappoint(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                   
        // Navigate to privacy policy screen
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEB6C96), Color(0xFFCEE2E3)],
          ),
          borderRadius: BorderRadius.circular(35.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Row(
                  children: [
                    Text(
                      'Privacy Policy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 120.0),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
  
  Widget _buildPrivacy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppointmentsPage()));
                   
        // Navigate to privacy policy screen
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEB6C96), Color(0xFFCEE2E3)],
          ),
          borderRadius: BorderRadius.circular(35.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Row(
                  children: [
                    Text(
                      'Doctors Appointments',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 50.0),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
