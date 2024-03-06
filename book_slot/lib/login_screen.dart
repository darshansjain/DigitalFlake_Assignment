import 'package:book_slot/create_acc._screen.dart';
import 'package:book_slot/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Import the dart:io library

class Login_Scr extends StatefulWidget {
  const Login_Scr({super.key});

  @override
  State<Login_Scr> createState() => _Login_ScrState();
}

class _Login_ScrState extends State<Login_Scr> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show error message for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
      return;
    }

    // Disable certificate verification (for testing purposes only)
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    try {
      // Make the HTTP POST request
      HttpClientRequest request = await client.postUrl(
          Uri.parse('https://demo0413095.mockable.io/digitalflake/api/login'));

      // Set request headers
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      // Set request body
      request.write(jsonEncode({
        'email': email,
        'password': password,
      }));

      // Send the request and get response
      HttpClientResponse response = await request.close();

      // Handle the response...
      if (response.statusCode == 200) {
        // Request was successful
        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home_screen()),
        );
        print("Login Succesfully");
        // Show a snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromRGBO(25, 173, 30, 1),
            content: Text('Login Successful'),
          ),
        );
      } else {
        // Request failed, show error message or handle the error
        print('Failed with status code: ${response.statusCode}');
        print(
            'Response body: ${await response.transform(utf8.decoder).join()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    } finally {
      // Close the HttpClient
      client.close();
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        color: Colors.white,
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Center(child: Image.asset("images/logo.png")),
                Center(
                  child: Text(
                    "Co-working",
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Mobile number or Email",
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
                  "Password",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: "*",
                  controller: passwordController,
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
                  height: 200,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _login(context);
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 55),
                        backgroundColor: Color.fromRGBO(81, 103, 235, 1),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
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
                      "New user? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "Create an account",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.deepPurple),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Create_Acc()));
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
