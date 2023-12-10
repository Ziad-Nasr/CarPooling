import 'package:flutter/material.dart';
import 'package:project/components/routesCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> with TickerProviderStateMixin {
  List<String> docIDS = [];

  Future getDocs(collection) async {
    // QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance
        .collection(collection)
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((doc) {
                docIDS.add(doc.reference.id);
              })
            });
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
                  TabBar(
                    tabs: [
                      Tab(
                          child: Text(
                        "Completed",
                        style: TextStyle(color: Colors.black),
                      )),
                      Tab(
                          child: Text(
                        "Canceled",
                        style: TextStyle(color: Colors.black),
                      )),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      FutureBuilder(
                          future: getDocs("completed"),
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
                                    Reserve: "Rate",
                                    Collection: "completed",
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
