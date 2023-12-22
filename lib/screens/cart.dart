import 'package:flutter/material.dart';
import 'package:project/components/navBar.dart';
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
      return (riders.contains(user?.email) && state != "completed");
    });
    docIDS = filteredDocs.map((doc) => doc.id).toList();
    if (mounted) {
      setState(() {});
    }
  }

  void removeUserFromRoute(String docuID) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the route document in the 'routes' collection
    DocumentReference routeDocumentReference =
        firestore.collection("routes").doc(docuID);
    try {
      // Get the title from the route document
      DocumentSnapshot routeSnapshot = await routeDocumentReference.get();
      var routeData = routeSnapshot.data() as Map<String, dynamic>;
      if (routeData['state'] != "available") {
        return;
      }

      String? routeTitle = routeData['title'];

      if (user?.email != null && routeTitle != null) {
        // Update the route document - remove the user and increment seats
        await routeDocumentReference.update({
          "riders": FieldValue.arrayRemove([user!.email])
        });
        await routeDocumentReference.update({"seats": FieldValue.increment(1)});

        // Query the 'requests' collection for documents with the matching user email and title
        QuerySnapshot requestSnapshot = await firestore
            .collection("requests")
            .where("user", isEqualTo: user.email)
            .where("title", isEqualTo: routeTitle)
            .get();

        // Loop through the matching documents and delete each one
        for (DocumentSnapshot doc in requestSnapshot.docs) {
          await doc.reference.delete();
          print("Deleted request with ID: ${doc.id}");
        }

        // Navigate to navBar with current set to 1
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => navBar(current: 1),
          ),
        );
      } else {
        // Handle the case where email or title is null
        print("Error: User email or Route title is null.");
      }
    } catch (e) {
      // Handle any errors here
      print("Error removing user from route or fetching/deleting requests: $e");
    }
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
