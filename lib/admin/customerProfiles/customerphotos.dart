import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class CustomerPhotosPage extends StatefulWidget {
  const CustomerPhotosPage({Key? key}) : super(key: key);

  @override
  _CustomerPhotosPageState createState() => _CustomerPhotosPageState();
}

class _CustomerPhotosPageState extends State<CustomerPhotosPage> {
  List<dynamic> uploadedFiles = []; // List to store both images and videos

  Future<void> _uploadFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        uploadedFiles.add(File(pickedFile.path));
      });
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
            dynamic media = uploadedFiles[index];
            if (media is File) {
              // Display image if it's an image file
              return Image.file(
                media,
                fit: BoxFit.cover,
              );
            }
            return Container(); // Placeholder if not an image
          },
        ),
      ),
    );
  }
}
