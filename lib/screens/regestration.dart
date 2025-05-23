// ignore_for_file: unused_field, prefer_final_fields, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app/screens/home.dart';
import 'package:task_app/screens/login.dart';
import 'package:task_app/services/databse.dart';

class RegestrationScreen extends StatefulWidget {
  const RegestrationScreen({super.key});

  @override
  State<RegestrationScreen> createState() => _RegestrationScreenState();
}

class _RegestrationScreenState extends State<RegestrationScreen> {
  bool _obscureText = true, isLoading = false;
  String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";
  final _formKey = GlobalKey<FormState>();

  String? username, email, phone, password;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  registration() async {
    setState(() {
      isLoading = true;
    });

    if (username != null &&
        email != null &&
        phone != null &&
        password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        Map<String, dynamic> userDetails = {
          'Name': nameController.text,
          'Email': emailController.text,
          'Phone': phoneController.text,
          'Password': passwordController.text,
        };

        await DatabaseMethods().addUserDetails(
          userDetails,
          userCredential.user!.uid,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Center(child: Text('Registered Successfully')),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Center(child: Text('Account Already Exist')),
            ),
          );
        }
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
                        "Registration",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      //username
                      SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        cursorColor: Colors.blue,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.blue),
                          hintText: 'Full Name',
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

                      //user phone number
                      SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Phone Number';
                          } else if (value.length < 10) {
                            return 'Phone Number Invalid';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.blue),
                          hintText: 'Phone Number',
                          counterText: '',
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
                              username = nameController.text;
                              email = emailController.text;
                              phone = phoneController.text;
                              password = passwordController.text;
                            });
                          }
                          registration();
                        },
                        child: Text(
                          'REGISTER',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      // Already have acc
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an Account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'SIGN IN',
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
