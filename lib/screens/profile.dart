import 'package:flutter/material.dart';
import 'package:project/components/blackButtonRound.dart';
import 'package:project/screens/history.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'Ziad Nasr',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Pinned Email",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: '19P****@eng.asu.edu.eg',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "01023456789",
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Senior",
                            labelText: 'Academic Level',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  blackButtonRound(text: "Confirm Changes", onPressed: () {})
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
