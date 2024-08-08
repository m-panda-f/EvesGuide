import 'package:evesguide/Tracker/calender.dart';
import 'package:evesguide/screens/Articles/Contacts.dart';
import 'package:evesguide/screens/common/answer.dart';
import 'package:evesguide/screens/common/fake.dart';
import 'package:evesguide/screens/common/waste.dart';
import 'package:evesguide/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Symptom {
  final String title;
  final String description;
  final String url;

  Symptom({required this.title, required this.description, required this.url});
}

class DietPlan {
  final String title;
  final String description;
  final String url;

  DietPlan({required this.title, required this.description, required this.url});
}

class Exercise {
  final String title;
  final String description;
  final String url;

  Exercise({required this.title, required this.description, required this.url});
}



class SymptomsScreen extends StatelessWidget {
  final List<Symptom> symptoms = [
    Symptom(
      title: "Missed Periods",
      description: "Missing periods can be a sign of pregnancy, stress, or hormonal imbalances.",
      url: "https://www.healthline.com/health/womens-health/why-is-my-period-late",
    ),
    Symptom(
      title: "Fatigue",
      description: "Feeling more tired than usual can be related to hormonal changes.",
      url: "https://www.healthline.com/health/fatigue",
    ),
    Symptom(
      title: "Weight Gain",
      description: "Unexpected weight gain can be due to hormonal fluctuations.",
      url: "https://www.healthline.com/health/unintentional-weight-gain",
    ),
    Symptom(
      title: "Mood Swings",
      description: "Changes in mood can be caused by hormonal imbalances.",
      url: "https://www.healthline.com/health/mood-swings",
    ),
    Symptom(
      title: "Acne",
      description: "Hormonal changes can lead to increased acne.",
      url: "https://www.healthline.com/health/acne",
    ),
    Symptom(
      title: "Headaches",
      description: "Hormonal fluctuations can cause frequent headaches or migraines.",
      url: "https://www.healthline.com/health/migraine/hormonal-headache",
    ),
    Symptom(
      title: "Breast Tenderness",
      description: "Hormonal changes can make the breasts feel sore or tender.",
      url: "https://www.healthline.com/health/breast-tenderness",
    ),
    Symptom(
      title: "Sleep Problems",
      description: "Insomnia or changes in sleep patterns can be related to hormonal changes.",
      url: "https://www.healthline.com/health/sleep-disorders",
    ),
    Symptom(
      title: "Hair Loss",
      description: "Hormonal imbalances can contribute to hair thinning or hair loss.",
      url: "https://www.healthline.com/health/womens-health/hormonal-hair-loss",
    ),
    Symptom(
      title: "Hot Flashes",
      description: "Sudden feelings of warmth, usually most intense over the face, neck, and chest.",
      url: "https://www.healthline.com/health/menopause/hot-flashes",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Missed Period Symptoms"),
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
                final link =
                          symptoms[index].url
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

class DietPlanScreen extends StatelessWidget {
  final List<DietPlan> dietPlans = [
    DietPlan(
      title: "Balanced Diet",
      description: "Include fruits, vegetables, whole grains, and lean proteins in your diet.",
      url: "https://www.healthline.com/nutrition/balanced-diet",
    ),
    DietPlan(
      title: "Stay Hydrated",
      description: "Drink plenty of water to stay hydrated and maintain hormone balance.",
      url: "https://www.healthline.com/nutrition/how-much-water-should-you-drink-per-day",
    ),
    DietPlan(
      title: "Reduce Caffeine",
      description: "Limit caffeine intake to help regulate your menstrual cycle.",
      url: "https://www.healthline.com/nutrition/how-much-caffeine-in-coffee",
    ),
    DietPlan(
      title: "Increase Fiber",
      description: "High-fiber foods can help balance hormones.",
      url: "https://www.healthline.com/nutrition/22-high-fiber-foods",
    ),
    DietPlan(
      title: "Healthy Fats",
      description: "Include healthy fats like omega-3s to help regulate hormones.",
      url: "https://www.healthline.com/nutrition/healthy-fats",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diet Plans"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: dietPlans.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                dietPlans[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              subtitle: Text(
                dietPlans[index].description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.info_outline, color: Colors.pinkAccent),
              onTap: () {
                 final link =
                          dietPlans[index].url
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

class ExerciseScreen extends StatelessWidget {
  final List<Exercise> exercises = [
    Exercise(
      title: "Yoga",
      description: "Practice yoga to help relieve stress and regulate hormones.",
      url: "https://www.youtube.com/watch?v=v7AYKMP6rOE",
    ),
    Exercise(
      title: "Cardio",
      description: "Engage in regular cardio exercises to maintain a healthy weight.",
      url: "https://www.youtube.com/watch?v=ml6cT4AZdqI",
    ),
    Exercise(
      title: "Strength Training",
      description: "Incorporate strength training exercises to improve overall fitness.",
      url: "https://www.youtube.com/watch?v=UBMk30rjy0o",
    ),
    Exercise(
      title: "Pilates",
      description: "Pilates can help strengthen your core and improve flexibility.",
      url: "https://www.youtube.com/watch?v=lCg_gh_fppI",
    ),
    Exercise(
      title: "Stretching",
      description: "Regular stretching can help reduce tension and improve mobility.",
      url: "https://www.youtube.com/watch?v=JE-Nyt4Bmi8",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercises"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                exercises[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              subtitle: Text(
                exercises[index].description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.play_circle_fill, color: Colors.pinkAccent),
              onTap: () {
                final link =
                          exercises[index].url
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

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});
}

class VideoScreen extends StatelessWidget {
  final List<Video> videos = [
    Video(
      title: "Stress Relief Meditation",
      url: "https://www.youtube.com/watch?v=inpok4MKVLM",
    ),
    Video(
      title: "Yoga for Stress Relief",
      url: "https://www.youtube.com/watch?v=v7AYKMP6rOE",
    ),
    Video(
      title: "Guided Meditation for Relaxation",
      url: "https://www.youtube.com/watch?v=ZToicYcHIOU",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stress Relief Videos"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                videos[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              trailing: Icon(Icons.play_circle_fill, color: Colors.pinkAccent),
              onTap: () {
               final link =
                          videos[index].url
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


class panda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Women's Health"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: <Widget>[
              _buildCustomButton(context, 'View Symptoms', SymptomsScreen()),
              _buildCustomButton(context, 'View Diet Plans', DietPlanScreen()),
              _buildCustomButton(context, 'View Exercises', ExerciseScreen()),
              _buildCustomButton(context, 'View Stress Relief Videos', VideoScreen()),
            ],
          ),
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
                icon: Icon(Icons.medical_services_rounded),
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
     
    );
  }


Widget _buildCustomButton(BuildContext context, String title, Widget screen) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => screen,
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
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.lightBlueAccent],
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
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15.0,
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
    ),
  );
}
}