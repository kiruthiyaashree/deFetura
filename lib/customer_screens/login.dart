import 'package:flutter/material.dart';
import 'package:construction/customer_screens/SignUp.dart';
import 'package:construction/customer_screens/home.dart';
import 'package:construction/admin/adminHome.dart';
import 'package:construction/models/user_models.dart';
import 'package:construction/repositories/user_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  void _login() async {
    String email = _usernameController.text;
    String password = _passwordController.text;

    try {
      // Call the loginUser method from UserRepository to authenticate the user
      UserModel? user = await UserRepository.instance.loginUser(email, password);
      if (email == "admin@gmail.com") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
      }
      if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(userName: user.name)),
          );
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password. Please try again.'),
          ),
        );
      }
    } catch (error) {
      // Handle any errors that occur during login
      print("Login error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while logging in. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Login to get started!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add functionality to handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _login,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF90B650)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(25, 1, 25, 1)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New Register?',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 16)), // Change the text style
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change the text color
                    ),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // "Sign in with Google" button
              ElevatedButton.icon(
                onPressed: () {
                  // Add functionality to sign in with Google
                },
                icon: FaIcon(FontAwesomeIcons.google),  // Google icon
                // Google icon
                label: Text('Sign in with Google'), // Button text
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Change the button color
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change the text color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)), // Change the padding
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Change the button border radius
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}