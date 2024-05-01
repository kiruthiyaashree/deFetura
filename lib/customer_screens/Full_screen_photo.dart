import 'package:flutter/material.dart';
class FullScreenPhoto extends StatelessWidget {
  final String photoURL;

  const FullScreenPhoto({required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(photoURL),
      ),
    );
  }
}
