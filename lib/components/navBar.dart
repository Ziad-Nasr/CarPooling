import 'package:project/screens/landing.dart';
import 'package:project/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/profile.dart';

class navBar extends StatefulWidget {
  @override
  _navBarState createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  int SelectedIdx = 0;
  List<Widget> myWidgets = [Landing(), cart(), profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myWidgets[SelectedIdx],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              SelectedIdx = index;
            });
          },
          currentIndex: SelectedIdx,
          items: const [
            BottomNavigationBarItem(
              label: "Trips",
              icon: Icon(Icons.airport_shuttle),
            ),
            BottomNavigationBarItem(
              label: "Cart",
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.badge),
            )
          ],
          selectedItemColor: Colors.teal, // Set the color for the selected tab
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
