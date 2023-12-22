import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/components/blackButtonRound.dart';
import 'package:project/components/navBar.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => editProfileState();
}

class editProfileState extends State<editProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _levelController;

  @override
  void initState() {
    super.initState();
    getDocs(); // Fetch user data and initialize controllers when the widget is first created
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        var userCollection = FirebaseFirestore.instance.collection('users');

        // Query for documents with the matching email
        var querySnapshot = await userCollection
            .where('email', isEqualTo: user?.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID of the first (and presumably only) document
          String docId = querySnapshot.docs.first.id;

          // Update the document in Firestore
          await userCollection.doc(docId).update({
            'name': _nameController!.text,
            'phone': _phoneNumberController!.text,
            'level': _levelController!.text,
          });
          print("User data updated successfully in Firestore.");
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => navBar(current: 2),
            ),
          );
        } else {
          print("No user found with email ${user?.email}");
        }
      } catch (e) {
        print("Error updating profile: $e");
      }
    }
  }

  Future<void> getDocs() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email) // Query based on email
          .limit(1)
          .get();
      print(querySnapshot.docs.first.data());
      // Check if the query returned any documents
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Initialize text controllers with data from Firestore
        _nameController = TextEditingController(text: userData['name']);
        _phoneNumberController = TextEditingController(text: userData['phone']);
        _levelController = TextEditingController(text: userData['level']);

        if (mounted) {
          setState(() {}); // Call setState to update the UI
        }
      } else {
        print(
            "User document does not exist in Firestore for email ${user.email}.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _levelController,
                decoration: InputDecoration(labelText: 'Academic Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your academic level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              blackButtonRound(
                  text: "Update Profile", onPressed: _updateProfile)
            ],
          ),
        ),
      ),
    );
  }
}
