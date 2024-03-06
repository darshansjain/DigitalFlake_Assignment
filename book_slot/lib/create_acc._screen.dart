// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:book_slot/home_screen.dart';
import 'package:book_slot/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Create_Acc extends StatefulWidget {
  const Create_Acc({super.key});

  @override
  State<Create_Acc> createState() => _Create_AccState();
}

// ignore: camel_case_types
class _Create_AccState extends State<Create_Acc> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    mobNoController.clear();
  }

  void _createAccount(BuildContext context) async {
    String name = nameController.text.trim();
    String mobNo = mobNoController.text.trim();
    String email = emailController.text.trim();

    bool accDetailsValidated = formKey.currentState!.validate();
    if (accDetailsValidated) {
      Map<String, String> requestBody = {
        'email': email,
        'name': name,
      };

      String jsonBody = jsonEncode(requestBody);

      // Disable SSL certificate verification (for testing purposes only)
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      try {
        // Make the HTTP POST request
        HttpClientRequest request = await client.postUrl(
          Uri.parse(
              'https://demo0413095.mockable.io/digitalflake/api/create_account'),
        );

        // Set request headers
        request.headers.set('Content-Type', 'application/json; charset=UTF-8');

        // Set request body
        request.write(jsonBody);

        // Send the request and get response
        HttpClientResponse response = await request.close();

        // Handle the response...
        if (response.statusCode == 200) {
          // Account creation successful
          // Navigate to the home screen or show a success message
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home_screen()),
          );
          print("Account created successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully'),
            ),
          );
        } else {
          // Account creation failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account creation failed'),
            ),
          );
        }
      } catch (e) {
        // Exception occurred during request
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      } finally {
        // Close the HttpClient
        client.close();
      }
      clearControllers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        color: Colors.white,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Create an Account",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Full Name",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(
                      249,
                      249,
                      249,
                      1,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  minLines: 1,
                  validator: (value) {
                    print("In USERNAME VALIDATOR");
                    if (value == null || value.isEmpty) {
                      return "Please enter username";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Mobile number",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: mobNoController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(
                      249,
                      249,
                      249,
                      1,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    print("In mobile VALIDATOR");
                    if (value == null || value.isEmpty) {
                      return "Please enter username";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Email ID",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(
                      249,
                      249,
                      249,
                      1,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    print("In email VALIDATOR");
                    if (value == null || value.isEmpty) {
                      return "Please enter username";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 200,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _createAccount(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 55),
                      backgroundColor: Color.fromRGBO(81, 103, 235, 1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "Create an account",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Existing user? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "Log In ",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.deepPurple),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login_Scr()));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
