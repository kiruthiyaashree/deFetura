import 'package:construction/models/user_models.dart';
import 'package:construction/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:construction/customer_screens/login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _showPassword  = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final userRepo = Get.put(UserRepository());
  void _signUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Perform basic validation checks
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      // If any of the fields are empty, show a snackbar indicating the user to fill in all fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return; // Exit the method
    }

    // Validate password constraints
    if (password.length < 8 || password.length > 15) {
      // Password length should be between 8 and 15 characters
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be between 8 and 15 characters.'),
        ),
      );
      return; // Exit the method
    }

    if (!password.contains(RegExp(r'\d'))) {
      // Password should contain at least one digit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must contain at least one digit.'),
        ),
      );
      return; // Exit the method
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      // Password should contain at least one symbol
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must contain at least one symbol.'),
        ),
      );
      return; // Exit the method
    }

    //  data to backend server for registration
    final user = UserModel(name: name, email: email, password: password);
    try {
      await userRepo.createUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );// Navigation to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create account'),
          backgroundColor: Colors.red.withOpacity(0.1),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SignUp',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: ()
                    {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _signUp,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF90B650)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(25, 1, 25, 1)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )
                    )
                ),
                child: Text('Signup'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Have An Account?',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 16)), // Change the text style
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change the text color
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // "Sign in with Google" button
              // ElevatedButton.icon(
              //   onPressed: () {
              //     // Add functionality to sign in with Google
              //   },
              //   icon: FaIcon(FontAwesomeIcons.google),  // Google icon
              //   label: Text('Sign up with Google'), // Button text
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Change the button color
              //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change the text color
              //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)), // Change the padding
              //     shape: MaterialStateProperty.all<OutlinedBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8), // Change the button border radius
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
