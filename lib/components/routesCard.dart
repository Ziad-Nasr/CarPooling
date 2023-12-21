import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class routeCard extends StatefulWidget {
  final String Reserve;
  final String Header;
  final String Details;
  final String cardType;
  final String docID;
  final String Collection;
  final Function onPressed;

  const routeCard({
    super.key,
    required this.Reserve,
    required this.Header,
    required this.Details,
    required this.cardType,
    required this.docID,
    required this.Collection,
    required this.onPressed,
  });

  @override
  State<routeCard> createState() => _routeCardState();
}

class _routeCardState extends State<routeCard> {
  Map<String, dynamic>? documentData;
  bool isLoading = true;
  String error = '';
  @override
  void initState() {
    _fetchDocumentData();
    super.initState();
  }

  Future<void> _fetchDocumentData() async {
    try {
      documentData = await _getDocumentData(widget.Collection, widget.docID);
    } catch (e) {
      error = 'Error fetching data: $e';
    }
    isLoading = false;
    setState(() {}); // Trigger a rebuild
  }

  Future<Map<String, dynamic>> _getDocumentData(
      String collectionName, String documentId) async {
    try {
      // Reference to the Firestore collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      // Get the document snapshot
      DocumentSnapshot documentSnapshot =
          await collection.doc(documentId).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Extract and return the data from the document
        Map<String, dynamic> documentData =
            documentSnapshot.data() as Map<String, dynamic>;
        return documentData;
      } else {
        // Document does not exist
        print('Document does not exist');
        return {};
      }
    } catch (e) {
      // Handle errors
      print('Error getting document: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (error.isNotEmpty) {
      return Center(child: Text(error));
    } else if (documentData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.car_rental,
              color: Colors.black,
            ),
            title: Text(
              documentData?['title'],
              style: TextStyle(
                  color: (widget.cardType == "Reserved")
                      ? Colors.teal
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            // subtitle: Text("From: " + documentData?['from']),
          ),
          Text(
            "From: " + documentData?['from'],
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "To: " + documentData?['to'],
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "Number of Seats: " + (documentData?['seats']).toString(),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "Date: " + (documentData?['date']).toString(),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            "Time: " + (documentData?['time']).toString(),
            style: TextStyle(color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text(
                  widget.Reserve,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  widget.onPressed();
                },
              ),
              const SizedBox(width: 4),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}
