// ignore_for_file: no_logic_in_create_state, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:book_slot/available_rooms_screen.dart';
import 'package:book_slot/model_classes.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//import 'package:http/http.dart' as http;

class Available_Desk_Screen extends StatefulWidget {
  final int? flag;
  const Available_Desk_Screen({super.key, required this.flag});

  @override
  State<Available_Desk_Screen> createState() =>
      _Available_Desk_ScreenState(flag);
}

class _Available_Desk_ScreenState extends State<Available_Desk_Screen> {
  int? flag;

  _Available_Desk_ScreenState(int? flag) {
    this.flag = flag;
  }
  int click = 0;
  List<Slot> slots = [];
  DateTime selectedDate = DateTime.now();
  Slot? slot1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Create a new HttpClient instance and disable SSL certificate verification
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);

      final response = await client.getUrl(Uri.parse(
          'https://demo0413095.mockable.io/digitalflake/api/get_slots?date=2023-05-01'));
      final httpResponse = await response.close();

      if (httpResponse.statusCode == 200) {
        final jsonData = await httpResponse.transform(utf8.decoder).join();
        final List<dynamic> slotsData = json.decode(jsonData)['slots'];
        setState(() {
          slots = slotsData.map((slot) => Slot.fromJson(slot)).toList();
        });
      } else {
        throw Exception('Failed to load slots');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int selectedIndex = -1;
  Color slotColor(int index) {
    if (click == 1 && selectedIndex == index && slots[index].slotActive) {
      return const Color.fromRGBO(81, 103, 235, 1); // Color for clicked slot
    } else if (slots[index].slotActive) {
      return const Color.fromARGB(255, 210, 216, 248); // Color for active slot
    } else {
      return const Color.fromRGBO(246, 246, 246, 1); // Color for inactive slot
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('E dd MMM').format(selectedDate);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back)),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Select Date & Slot",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: const Color.fromRGBO(77, 96, 209, 1),
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                    print(date);
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 350,
              padding: const EdgeInsets.all(15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  mainAxisExtent: 50,
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        click = 1;
                        selectedIndex = index;
                        slot1 = slots[index];
                      });
                      print('Slot clicked: ${slot.slotName}');
                    },

                    // Handle slot click

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: slotColor(
                          index,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          slot.slotName,
                          style: GoogleFonts.poppins(
                              fontSize: 13.0, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 145,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Available_Rooms_Screen(formattedDate, slot1!, flag),
                    ),
                  );
                  print("print navi");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 55),
                  backgroundColor: const Color.fromRGBO(81, 103, 235, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
