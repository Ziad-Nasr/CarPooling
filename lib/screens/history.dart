import 'package:flutter/material.dart';
import 'package:project/components/routesCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> with TickerProviderStateMixin {
  List<String> docIDS = [];

  Future getDocs() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("routes").get();
    final docs = querySnapshot.docs;
    final filteredDocs = docs.where((doc) {
      final riders = doc["riders"];
      final state = doc["state"];
      return (riders.contains(user?.email) && state == "complete");
    });
    docIDS = filteredDocs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    late TabController _tabController;
    @override
    void initState() {
      super.initState();
      _tabController = TabController(length: 2, vsync: this);
    }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    return DefaultTabController(
      length: 2,
      child: MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: const Text("Ride History"),
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Completed",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      FutureBuilder(
                          future: getDocs(),
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                itemCount: docIDS.length,
                                itemBuilder: (context, index) {
                                  return routeCard(
                                    cardType: "Reserved",
                                    Header: "Title",
                                    Details: "Trip Details",
                                    Reserve: "",
                                    Collection: "routes",
                                    docID: docIDS[index],
                                    onPressed: () {},
                                  ); // Assuming routeCard is the widget you want to display for each item
                                },
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          itemCount: docIDS.length,
                          itemBuilder: (context, index) {
                            return routeCard(
                              cardType: "New",
                              Header: "Title",
                              Details: "Trip Details",
                              Reserve: "Report",
                              Collection: "",
                              docID: docIDS[index],
                              onPressed: () {},
                            );
                          },
                        ),
                      ),
                    ]),
                  )
                ],
              ))),
    );
  }
}
