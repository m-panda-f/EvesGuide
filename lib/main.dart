import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'Login/login.dart' as login;
import 'Login/signin.dart' as signup;
import 'screens/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: "Eve's Guide",
      home: AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return EvesGuideApp();
    } else {
      return const AuthPage();
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button on home screen
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF32E4F0),
          title: const Text("Eve's Guide"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
              },
            ),
          ],
        ),
        body: const Center(
          child: Text("Welcome to Eve's Guide!"),
        ),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      
        child: 
         Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the text vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally
          children: [
            SizedBox(height: 200,),
            Text(
              "Eve's Guide",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 44.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Makes the text bold
                fontStyle: FontStyle.italic, // Adds an italic style to the text
                color: Colors.deepPurple,

  // Changes the text color to deep purple
                 // Specify your custom font
              ),
            ),
            const SizedBox(height: 200), // Space between text and buttons
            Column(
              mainAxisSize: MainAxisSize.min, // Use minimum space for the buttons
              children: [
                SizedBox(height: 100,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 122, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login.LogIn()),
                    );
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 210, 175, 164),
                    padding: const EdgeInsets.symmetric(horizontal: 118, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signup.SignUp()),
                    );
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
