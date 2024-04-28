import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerPhotosPage extends StatefulWidget {
  final String customerName;
  const CustomerPhotosPage({required this.customerName, Key? key}) : super(key: key);

  @override
  _CustomerPhotosPageState createState() => _CustomerPhotosPageState();
}

class _CustomerPhotosPageState extends State<CustomerPhotosPage> {
  List<String> uploadedFiles = []; // List to store photo URLs

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  Future<void> _fetchFiles() async {
    try {
      // Fetch photos from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customerDetails')
          .doc(widget.customerName)
          .collection('photos')
          .get();

      List<String> urls = [];
      // Extract URLs from documents
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('photoURL')) {
          String? url = data['photoURL'] as String?;
          if (url != null) {
            urls.add(url);
          }
        }
      }

      setState(() {
        uploadedFiles = urls;
      });
    } catch (error) {
      print("Error fetching files: $error");
    }
  }

  Future<void> _uploadFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      // Upload image to Firebase Storage
      File file = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('customerDetails/${widget.customerName}/photos/$fileName');
      await ref.putFile(file);

      // Get the download URL for the image
      String downloadURL = await ref.getDownloadURL();

      // Add download URL to Firestore
      try {
        await FirebaseFirestore.instance
            .collection('customerDetails')
            .doc(widget.customerName)
            .collection('photos')
            .add({'photoURL': downloadURL});

        // Fetch files again to update the UI
        await _fetchFiles();
      } catch (error) {
        print("Error uploading file: $error");
      }
    }
  }

  void _viewFullPhoto(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPhotoView(url: url),
      ),
    );
  }

  Future<void> _deletePhoto(String url) async {
    // Confirm deletion
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this photo?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        // Delete photo from Firebase Storage
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.refFromURL(url);
        await ref.delete();

        // Delete photo record from Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('customerDetails')
            .doc(widget.customerName)
            .collection('photos')
            .where('photoURL', isEqualTo: url)
            .get();
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });

        // Fetch files again to update the UI
        await _fetchFiles();
      } catch (error) {
        print("Error deleting file: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        tooltip: 'Upload Media',
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
          ),
          itemCount: uploadedFiles.length,
          itemBuilder: (context, index) {
            String url = uploadedFiles[index];
            return GestureDetector(
              onTap: () => _viewFullPhoto(url),
              child: Stack(
                children: [
                  Hero(
                    tag: url, // Unique tag for Hero animation
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deletePhoto(url),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullPhotoView extends StatelessWidget {
  final String url;

  const FullPhotoView({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: url, // Same tag as in the thumbnail
          child: Image.network(url), // Display full-size image
        ),
      ),
    );
  }
}
