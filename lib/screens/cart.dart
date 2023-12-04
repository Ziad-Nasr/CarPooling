import 'package:flutter/material.dart';
import 'package:project/components/routesCard.dart';
import 'package:project/components/blackButtonRound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
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
        backgroundColor: Colors.black,
        title: Text("Reserved Seats"),
      ),
      body: FutureBuilder(
          future: getDocs(),
          builder: (context, snapshot) {
            return Center(
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
                            Reserve: "Reserve",
                            Collection: "cart",
                            docID: docIDS[index],
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
