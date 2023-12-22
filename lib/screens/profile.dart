import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/blackButtonRound.dart';
import 'package:project/screens/history.dart';
import 'package:project/components/database.dart';
import 'package:project/screens/editProfile.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  DatabaseHelper mydb = DatabaseHelper();
  Map<String, dynamic> userData = {};
  Map<String, dynamic> userDataCloud = {};
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = true;
  Future<void> fetchUserDataFromLocalDB(String email) async {
    try {
      // Query the database for the user with the specified email
      List<Map<String, dynamic>> queryResult = await mydb.queryRows(email);
      if (queryResult.isNotEmpty) {
        // Assuming there's only one match for the given email
        setState(() {
          userData = queryResult.first;
        });
      } else {
        print("No local user data found for email $email");
      }
    } catch (e) {
      print('Error fetching user data from local DB: $e');
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> saveUserDataToLocalDB(Map<String, dynamic> userData) async {
    try {
      // Map the userData to the database columns
      Map<String, dynamic> row = {
        DatabaseHelper.columnEmail: userData['email'],
        DatabaseHelper.columnName: userData['name'],
        DatabaseHelper.columnLevel: userData['level'],
        DatabaseHelper.columnPhoneNumber: userData['phone'],
        // Ensure that the keys used here ('email', 'name', 'level', 'phone') match the keys in your userData map
      };

      // Update the user data in the SQLite database
      final rowsAffected = await mydb.update(row);
      if (rowsAffected > 0) {
        print(
            'Updated user data in local DB for email: ${row[DatabaseHelper.columnEmail]}');
      } else {
        print(
            'No record was found with email: ${row[DatabaseHelper.columnEmail]} to update.');
      }
    } catch (e) {
      print('Error saving user data to local DB: $e');
    }
  }

  // Fetch a user document from Firestore by email
  Future<void> fetchUserByEmail(String? email) async {
    try {
      // Reference to Firestore collection
      var userCollection = FirebaseFirestore.instance.collection('users');

      // Query for documents with the matching email
      var querySnapshot =
          await userCollection.where('email', isEqualTo: email).limit(1).get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Return the first document found (should be the only one due to the query)
        setState(() {
          userDataCloud = querySnapshot.docs.first.data();
        });
        saveUserDataToLocalDB(userDataCloud);
      } else {
        print("Non Found");
        // No documents found
      }
    } catch (e) {
      // Handle any errors here
      print("error");
      print(e);
    }
    fetchUserDataFromLocalDB(user!.email!);
  }

  @override
  void initState() {
    fetchUserByEmail(user?.email);
    super.initState();
    // Fetch the user document by email
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              blackButtonRound(
                  text: "Trips History",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => history(),
                      ),
                    );
                  }),
              SizedBox(height: 80),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "lib/assets/user.png",
                        height: 85,
                        width: 85,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      userData[DatabaseHelper.columnName] ?? 'No Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(5), // 5px margin on all sides
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align the label to the left
                        children: [
                          const Text(
                            'Pinned Email', // The label text
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey, // Label font size
                              fontWeight:
                                  FontWeight.bold, // Make the label bold
                            ),
                          ),
                          const SizedBox(
                              height:
                                  5), // Space between the label and the container
                          Container(
                            width: MediaQuery.of(context).size.width -
                                10, // Screen width minus the total horizontal padding
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black), // Border color
                              borderRadius: BorderRadius.circular(
                                  4), // Rounded corner radius
                            ),
                            child: Text(
                              userData[DatabaseHelper.columnEmail] ??
                                  "Non", // Replace with the default text if user?.email is null
                              style: TextStyle(
                                color: Colors.black, // Text color
                                fontSize: 16, // Font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: EdgeInsets.all(5), // 5px margin on all sides
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align the label to the left
                        children: [
                          const Text(
                            'Phone Number', // The label text
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey, // Label font size
                              fontWeight:
                                  FontWeight.bold, // Make the label bold
                            ),
                          ),
                          const SizedBox(
                              height:
                                  5), // Space between the label and the container
                          Container(
                            width: MediaQuery.of(context).size.width -
                                10, // Screen width minus the total horizontal padding
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black), // Border color
                              borderRadius: BorderRadius.circular(
                                  4), // Rounded corner radius
                            ),
                            child: Text(
                              userData[DatabaseHelper.columnPhoneNumber] ??
                                  "Non", // Replace with the default text if user?.email is null
                              style: TextStyle(
                                color: Colors.black, // Text color
                                fontSize: 16, // Font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: EdgeInsets.all(5), // 5px margin on all sides
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align the label to the left
                        children: [
                          const Text(
                            'Academic Level', // The label text
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey, // Label font size
                              fontWeight:
                                  FontWeight.bold, // Make the label bold
                            ),
                          ),
                          const SizedBox(
                              height:
                                  5), // Space between the label and the container
                          Container(
                            width: MediaQuery.of(context).size.width -
                                10, // Screen width minus the total horizontal padding
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black), // Border color
                              borderRadius: BorderRadius.circular(
                                  4), // Rounded corner radius
                            ),
                            child: Text(
                              userData["level"] ??
                                  "Non", // Replace with the default text if user?.email is null
                              style: TextStyle(
                                color: Colors.black, // Text color
                                fontSize: 16, // Font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    blackButtonRound(
                        text: "Update Profile",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editProfile(),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }
}
