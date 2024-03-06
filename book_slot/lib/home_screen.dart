// ignore_for_file: camel_case_types

import 'package:book_slot/available_desk_screen.dart';
import 'package:book_slot/booking_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Row(
              children: [
                Image.asset("images/logo.png"),
                Text(
                  "Co-working",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookingHistory()));
                  },
                  style: ElevatedButton.styleFrom(
                    //minimumSize: const Size(300, 55),
                    backgroundColor: const Color.fromRGBO(81, 103, 235, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    "Booking History",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 65,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Available_Desk_Screen(
                                  flag: 1,
                                )));
                  },
                  child: Container(
                    height: 145,
                    width: 145,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(77, 96, 209, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Image.asset("images/Group.png"),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Available_Desk_Screen(
                                  flag: 2,
                                )));
                  },
                  child: Container(
                    height: 145,
                    width: 145,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(199, 207, 252, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Image.asset("images/meeting_room.png"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
