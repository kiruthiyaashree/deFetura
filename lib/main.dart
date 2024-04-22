import 'dart:async';

import 'package:construction/customer_screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      home: const GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage("assets/GetStartedImage.png"),
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Image(
              image: AssetImage('assets/logo.jpg'),
              width: 100,
              height: 60,
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(60, 70, 90, 40),
        padding: EdgeInsets.all(25),
        child: MaterialButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            // Navigate to another page or perform other actions on button press.
          },
          color: Color(0xFF90B650),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Get started',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
