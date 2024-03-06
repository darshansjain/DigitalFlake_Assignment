//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:book_slot/model_classes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
//import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class Workspace {
  final String workspaceName;
  final int workspaceId;
  final bool workspaceActive;

  Workspace({
    required this.workspaceName,
    required this.workspaceId,
    required this.workspaceActive,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      workspaceName: json['workspace_name'] ?? '',
      workspaceId: json['workspace_id'] ?? 0,
      workspaceActive: json['workspace_active'] ?? false,
    );
  }
}

class Available_Rooms_Screen extends StatefulWidget {
  final Slot? slot;
  final String? date;
  final int? flag;
  const Available_Rooms_Screen(this.date, this.slot, this.flag, {super.key});

  @override
  State<Available_Rooms_Screen> createState() =>
      _Available_Rooms_ScreenState(date!, slot!, flag!);
}

class _Available_Rooms_ScreenState extends State<Available_Rooms_Screen> {
  // List<dynamic> slot = [];
  Slot? slot;
  String? date;
  int? flag;
  _Available_Rooms_ScreenState(String? date, Slot? slot, int? flag) {
    this.date = date;
    this.slot = slot;
    this.flag = flag;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Workspace> workspaces = [];

  Future<void> fetchData() async {
    try {
      // Create a new HttpClient instance and disable SSL certificate verification
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);

      final response = await client.getUrl(Uri.parse(
          'https://demo0413095.mockable.io/digitalflake/api/get_availability?date=2023-05-01&slot_id=2&type=1'));
      final httpResponse = await response.close();

      if (httpResponse.statusCode == 200) {
        final jsonData = await httpResponse.transform(utf8.decoder).join();
        final List<dynamic> availabilityData =
            json.decode(jsonData)['availability'];
        setState(() {
          workspaces =
              availabilityData.map((json) => Workspace.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load availability');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int selectedId = -1;
  int selectedIndex = -1;
  Color slotColor(int index) {
    if (selectedIndex == index && workspaces[index].workspaceActive) {
      return const Color.fromRGBO(
          81, 103, 235, 1); // Color for clicked and active slot
    } else if (workspaces[index].workspaceActive) {
      return const Color.fromARGB(255, 210, 216, 248); // Color for active slot
    } else {
      return const Color.fromRGBO(246, 246, 246, 1); // Color for inactive slot
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(15),
        //height: double.infinity,
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
                  (flag == 1) ? "Available Desk" : "Available Room",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  date!,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  slot!.slotName,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 500,
              // padding: EdgeInsets.all(15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // number of items in each row
                    mainAxisSpacing: 8.0, // spacing between rows
                    crossAxisSpacing: 8.0,
                    mainAxisExtent: 50 // spacing between columns
                    ),
                padding: const EdgeInsets.all(8.0), // padding around the grid
                itemCount: workspaces.length, // total number of items
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedId = workspaces[index].workspaceId;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: slotColor(index),
                      ), // color of grid items
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 81,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Return the AlertDialog widget here
                      return AlertDialog(
                        title: Text(
                          'Confirm booking',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(children: [
                              Text(
                                "Room Id : 12435",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              const Spacer(),
                              Text(
                                "Room No.$selectedId",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              )
                            ]),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(children: [
                              Text(
                                "slot : ",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "$date, ",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                slot!.slotName,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              )
                            ]),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      const Color.fromRGBO(25, 173, 30, 1),
                                  content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Success",
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          (flag == 1)
                                              ? "You have successfully booked your Desk"
                                              : "You have successfully booked your Room",
                                          style: GoogleFonts.poppins(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                  duration: const Duration(
                                      seconds:
                                          2), // Adjust the duration as needed
                                ),
                              );
                              // Close the dialog
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
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
                  (flag == 1) ? "Book Desk" : "Book Room",
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
