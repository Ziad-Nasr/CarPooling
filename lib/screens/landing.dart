import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/navBar.dart';
import 'package:project/components/routesCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<String> docIDS = [];

  Future getDocs() async {
    DateTime now = DateTime.now();
    print(now.hour);
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("routes").get();
    final docs = querySnapshot.docs;
    final filteredDocs1 = docs.where((doc) {
      final riders = doc["riders"];
      final seats = doc["seats"];
      final state = doc["state"];
      final firestoreTime = (doc["time"] as Timestamp)
          .toDate(); // Convert Firestore Timestamp to DateTime
      final durationDifference =
          firestoreTime.difference(now); // Calculate the difference

      // Define the target duration of 9 hours and 30 minutes
      final targetDuration = Duration(hours: 9, minutes: 30);

      // Check if the time difference is more than 9:30 hours away
      bool isMoreThanNineThirtyAway = durationDifference > targetDuration;
      bool is730 = firestoreTime.hour == 7 && firestoreTime.minute == 30;
      return (!riders.contains(user?.email) &&
          seats > 0 &&
          state == "available" &&
          isMoreThanNineThirtyAway &&
          is730); // Add the new time condition
    });

    final filteredDocs2 = docs.where((doc) {
      final riders = doc["riders"];
      final seats = doc["seats"];
      final state = doc["state"];
      final firestoreTime = (doc["time"] as Timestamp)
          .toDate(); // Convert Firestore Timestamp to DateTime
      final durationDifference =
          firestoreTime.difference(now); // Calculate the difference

      // Define the target duration of 9 hours and 30 minutes
      final targetDuration = Duration(hours: 4, minutes: 30);

      // Check if the time difference is more than 9:30 hours away
      bool isMoreThanFourThirtyAway = durationDifference > targetDuration;
      bool is530 = firestoreTime.hour == 5 && firestoreTime.minute == 15;
      return (!riders.contains(user?.email) &&
          seats > 0 &&
          state == "available" &&
          isMoreThanFourThirtyAway &&
          is530); // Add the new time condition
    });
    List<String> docIDs1 = filteredDocs1.map((doc) => doc.id).toList();
    List<String> docIDs2 = filteredDocs2.map((doc) => doc.id).toList();
    docIDS = List.from(docIDs1)..addAll(docIDs2);

  }

  void addUserToRoute(String docuID) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("routes").doc(docuID);
    documentReference.update({
      "riders": FieldValue.arrayUnion([user?.email])
    });
    try {
      // Retrieve the document
      DocumentSnapshot documentSnapshot = await documentReference.get();

      // Check if the document exists and has data
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        // Document data as Map
        Map<String, dynamic> documentData =
            documentSnapshot.data() as Map<String, dynamic>;

        // You can use documentData here if needed
        // For example: print(documentData['someFieldName']);

        // Update riders and seats
        documentReference.update({
          "riders": FieldValue.arrayUnion([user?.email])
        });
        documentReference.update({"seats": FieldValue.increment(-1)});

        CollectionReference requests =
            FirebaseFirestore.instance.collection('requests');
        await requests.add({
          'docID': docuID,
          'driver': documentData[
              'driver'], // Assuming 'driver' is a field in the document
          'user': user?.email ?? 'Unknown user',
          'from': documentData['from'],
          'to': documentData['to'],
          'time': documentData['time'],
          'seats': documentData['seats'] - 1,
          'state': "requested",
          'title': documentData['title'],
          'name': user?.displayName ?? 'Unknown user',
          // Fallback to 'Unknown user' if email is null
        });

        // Navigate to navBar
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => navBar(),
          ),
        );
      } else {
        print("Document does not exist or is empty");
        // Handle the case where the document doesn't exist or is empty
      }
    } catch (e) {
      print("Error retrieving document: $e");
      // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Landing"),
          actions: [
            IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
          ],
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: getDocs(),
            builder: (context, snapshot) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: docIDS.length,
                        itemBuilder: (context, index) {
                          return routeCard(
                            cardType: "New",
                            Details: "Details",
                            Header: "Header",
                            Collection: "routes",
                            docID: docIDS[index],
                            Reserve: "Reserve",
                            onPressed: () {
                              addUserToRoute(docIDS[index]);
                            },
                            //To Do Next
                            //Zabat el cart eno momken ysheil nafso mn el riders w y increment seats
                            //7ot condition en el ride te25tfy mn el routes law seats = 0
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
