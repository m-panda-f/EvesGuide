import 'package:project/Tracker/calender.dart';
import 'package:project/screens/Articles/Contacts.dart';
import 'package:project/screens/common/Health.dart';
import 'package:project/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class OpportunitiesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eves's Guide",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        hintColor: Colors.pinkAccent,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          buttonColor: Colors.pink,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opportunities'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            _buildCustomButton(context, 'Scholarships', ScholarshipListPage()),
            _buildCustomButton(context, 'Internships and Job Opportunities', OpportunitiesListPage()),
          ],
        ),
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
                icon: Icon(Icons.school_rounded),
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
                icon: Icon(Icons.home_outlined),
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
     
    );
  }

  Widget _buildCustomButton(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Color.fromARGB(154, 86, 225, 235)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        padding: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black45,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ScholarshipListPage extends StatelessWidget {
  final List<Opportunity> scholarships = [
    Opportunity(
      title: 'Post Graduate Indira Gandhi Scholarship for Single Girl Child',
      description: 'A scholarship for single girl child pursuing postgraduate studies.',
      link: "https://www.ugc.gov.in/Scholarships/stu_Scholarship4",
    ),
    Opportunity(
      title: 'CBSE Udaan for Girls',
      description: 'A scholarship for girl students to prepare for engineering entrance exams.',
      link: 'https://www.india.gov.in/spotlight/udaan-program-give-wings-girl-students',
    ),
    Opportunity(
      title: 'AICTE Pragati Scholarship for Girls',
      description: 'A scholarship for girl students pursuing technical education.',
      link: 'https://www.aicte-india.org/schemes/students-development-schemes/pragati-scholarship-scheme-girls',
    ),
    Opportunity(
      title: 'Lady Meherbai D Tata Education Trust Scholarship',
      description: 'A scholarship for Indian women pursuing higher education abroad.',
      link: 'https://www.tatatrusts.org/our-work/education/individual-grants-programme',
    ),
    Opportunity(
      title: 'L\'Oréal India For Young Women in Science Scholarships',
      description: 'A scholarship for young women pursuing a career in science.',
      link: 'https://www.foryoungwomeninscience.com/',
    ),
    Opportunity(
      title: 'Google Women Techmakers Scholars Program',
      description: 'A scholarship program for women in computer science and related fields.',
      link: 'https://www.womentechmakers.com/',
    ),
    Opportunity(
      title: 'Adobe Research Women-in-Technology Scholarship',
      description: 'A scholarship for outstanding female graduate students in computer science.',
      link: 'https://www.adobe.com/in/lead/creativecloud/women-in-technology.html',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarships'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: scholarships.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                scholarships[index].title,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              ),
              subtitle: Text(
                scholarships[index].description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.info_outline, color: Colors.pinkAccent),
              onTap: () {
                final link =
                          scholarships[index].link
                                  as String;
                          launchUrl(Uri.parse(link),
                              mode: LaunchMode.externalApplication);
              },
            ),
          );
        },
      ),
      
    );
  }

  
  
}

class OpportunitiesListPage extends StatelessWidget {
  final List<Opportunity> opportunities = [
    Opportunity(
      title: 'Internshala',
      description: 'Find internships and jobs across various fields.',
      link: 'https://internshala.com/',
    ),
    Opportunity(
      title: 'LinkedIn Jobs',
      description: 'Explore job opportunities on LinkedIn.',
      link: 'https://www.linkedin.com/jobs/',
    ),
    Opportunity(
      title: 'JobsForHer',
      description: 'Connecting women with job opportunities.',
      link: 'https://www.jobsforher.com/',
    ),
    Opportunity(
      title: 'Sheroes',
      description: 'A community for women offering job opportunities, resources, and support.',
      link: 'https://sheroes.com/',
    ),
    Opportunity(
      title: 'Career Reboot Program',
      description: 'An exclusive program helping women return to the workforce after a career break. It’s a part of the Vaahini network dedicated to women empowerment.',
      link: 'https://www.accenture.com/in-en/careers/local/career-reboot-program',
    ),
    Opportunity(
      title: 'Google Women Techmakers Program',
      description: 'Programs and job opportunities for women in technology.',
      link: 'https://www.womentechmakers.com/',
    ),
    Opportunity(
      title: 'TechWomen',
      description: 'Professional mentorship and exchange program for women in STEM.',
      link: 'https://www.techwomen.org/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship and Job Opportunities'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: opportunities.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                opportunities[index].title,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              ),
              subtitle: Text(
                opportunities[index].description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.info_outline, color: Colors.pinkAccent),
              onTap: () {
                final link =
                          opportunities[index].link
                                  as String;
                          launchUrl(Uri.parse(link),
                              mode: LaunchMode.externalApplication);
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

class DetailPage extends StatelessWidget {
  final Opportunity opportunity;
  final bool isScholarship;

  DetailPage({required this.opportunity, required this.isScholarship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(opportunity.title),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              opportunity.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchURL(context, opportunity.link);
              },
              child: Text('Learn More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ],
        ),
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

class Opportunity {
  final String title;
  final String description;
  final String link;

  Opportunity({required this.title, required this.description, required this.link});
}