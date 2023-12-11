import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      return (!riders.contains(user?.email) && seats > 0);
    });
    docIDS = filteredDocs.map((doc) => doc.id).toList();
  }

  void addUserToRoute(String docuID) {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("routes").doc(docuID);
    documentReference.update({
      "riders": FieldValue.arrayUnion([user?.email])
    });
    documentReference.update({"seats": FieldValue.increment(-1)});
    setState(() {});
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
