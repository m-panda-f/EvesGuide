import 'package:flutter/material.dart';
class Symptom {
  final String title;
  final String description;

  Symptom({required this.title, required this.description});
}
class SymptomsScreen extends StatelessWidget {
  final List<Symptom> symptoms = [
    Symptom(
      title: "Missed Periods",
      description: "Missing periods can be a sign of pregnancy, stress, or hormonal imbalances.",
    ),
    Symptom(
      title: "Fatigue",
      description: "Feeling more tired than usual can be related to hormonal changes.",
    ),
    Symptom(
      title: "Weight Gain",
      description: "Unexpected weight gain can be due to hormonal fluctuations.",
    ),
    Symptom(
      title: "Mood Swings",
      description: "Changes in mood can be caused by hormonal imbalances.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skipped Period Symptoms"),
      ),
      body: ListView.builder(
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(symptoms[index].title),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(symptoms[index].title),
                    content: Text(symptoms[index].description),
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
          );
        },
      ),
    );
  }
}
