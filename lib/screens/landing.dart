import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/navBar.dart';
import 'package:project/components/routesCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("routes").get();
    final docs = querySnapshot.docs;
    final filteredDocs = docs.where((doc) {
      final riders = doc["riders"];
      final seats = doc["seats"];
      final state = doc["state"];
      return (!riders.contains(user?.email) &&
          seats > 0 &&
          state == "available");
    });
    docIDS = filteredDocs.map((doc) => doc.id).toList();
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