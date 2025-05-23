// ignore_for_file: avoid_unnecessary_containers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task_app/screens/login.dart';
import 'package:task_app/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('LOGOUT'),
                      content: Text('Are You Sure You Want to Logout!'),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.blue,
                            ),
                          ),
                          onPressed: () async {
                            Center(child: CircularProgressIndicator());
                            await AuthMethods().logOut().then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            });
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width * .6,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white),
                    SizedBox(width: 40),
                    Text(
                      'LOGOUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
