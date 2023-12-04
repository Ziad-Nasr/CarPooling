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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<String> docIDS = [];

  Future getDocs() async {
    // QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance
        .collection("routes")
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((doc) {
                docIDS.add(doc.reference.id);
              })
            });
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
                            Reserve: docIDS[index],
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
