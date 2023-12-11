import 'package:flutter/material.dart';
import 'package:project/components/routesCard.dart';
import 'package:project/components/blackButtonRound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  List<String> docIDS = [];

  Future getDocs() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("routes").get();
    final docs = querySnapshot.docs;
    final filteredDocs = docs.where((doc) {
      final riders = doc["riders"];
      final state = doc["state"];
      return (riders.contains(user?.email) && state != "complete");
    });
    docIDS = filteredDocs.map((doc) => doc.id).toList();
    if (mounted) {
      setState(() {});
    }
  }

  void removeUserFromRoute(String docuID) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("routes").doc(docuID);

    documentReference.update({
      "riders": FieldValue.arrayRemove([user?.email])
    });
    documentReference.update({"seats": FieldValue.increment(1)});
    getDocs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Reserved Seats"),
      ),
      body: FutureBuilder(
          future: getDocs(),
          builder: (context, snapshot) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    "lib/assets/cart.png",
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(height: 20),
                  Text("Have a look at your reserved seats!"),
                  SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: docIDS.length,
                        itemBuilder: (context, index) {
                          return routeCard(
                            cardType: "Reserved",
                            Header: "Title",
                            Details: "Trip Details",
                            Reserve: "Remove",
                            Collection: "routes",
                            docID: docIDS[index],
                            onPressed: () {
                              removeUserFromRoute(docIDS[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  blackButtonRound(
                      text: "Confirm Reservations", onPressed: () {}),
                  SizedBox(height: 20),
                ],
              ),
            );
          }),
    ));
  }
}
