import 'dart:io';

import 'package:evesguide/main.dart';
import 'package:evesguide/profiles/scrollview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;

  ProfilePage({Key? key, required this.email, required this.userName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _profilePictureUrl = doc.data()?['profilePicture'];
        });
      }
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      final user = _auth.currentUser;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(user!.uid + '.jpg');

      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'profilePicture': downloadUrl}, SetOptions(merge: true));

      setState(() {
        _profilePictureUrl = downloadUrl;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEB6C96),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            iconSize: 20,
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onDoubleTap: () async {
                  _getImageFromGallery();
                },
                child: _profilePictureUrl != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(_profilePictureUrl!),
                        backgroundColor: Colors.grey.shade300,
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 200,
                        color: Color.fromARGB(255, 104, 100, 100),
                      ),
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              'Name: ${widget.userName}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${widget.email}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: OptionsScrollView(),
            ),
          ],
        ),
      ),
    );
  }
}
