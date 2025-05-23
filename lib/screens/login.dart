// ignore_for_file: use_build_context_synchronously, unused_local_variable, deprecated_member_use, unrelated_type_equality_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app/screens/home.dart';
import 'package:task_app/screens/regestration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true, isLoading = false;
  String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";
  final _formKey = GlobalKey<FormState>();

  String email = "", password = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserCredential? userCredential;

  userLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Center(child: Text('Login Successfully')),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code != userCredential) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Center(child: Text('Incorrect Email or Password')),
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "images/login.png",
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(height: 10),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      //user email
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.blue,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email';
                          } else if (!RegExp(emailPattern).hasMatch(value)) {
                            return 'Invalid Email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.blue),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),

                      //user password
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        cursorColor: Colors.blue,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a Password';
                          } else if (value.length < 6) {
                            return 'Password Length Should be 6';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.blue),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child:
                                _obscureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                    ),
                          ),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),

                      // Regestration Btn
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * .6,
                            40,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                            userLogin();
                          }
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      // Already have acc
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Do not have an Account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegestrationScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
