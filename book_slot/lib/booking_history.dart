import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  List<Booking> bookings = [];

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
          'https://demo0413095.mockable.io/digitalflake/api/get_bookings?user_id=1'));
      final httpResponse = await response.close();

      if (httpResponse.statusCode == 200) {
        final jsonData = await httpResponse.transform(utf8.decoder).join();
        final List<dynamic> bookingsData = json.decode(jsonData)['bookings'];
        setState(() {
          bookings =
              bookingsData.map((json) => Booking.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<String> name = ["John Smith", "Emily Johnson", "David Brown"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
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
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Booking History",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(245, 247, 255, 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Room Id   : 12456"),
                        Text("Name      : ${name[index]}"),
                        Text("Booked On : ${booking.bookingDate}"),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Booking {
  final String workspaceName;
  final int workspaceId;
  final String bookingDate;

  Booking({
    required this.workspaceName,
    required this.workspaceId,
    required this.bookingDate,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      workspaceName: json['workspace_name'],
      workspaceId: json['workspace_id'],
      bookingDate: json['booking_date'],
    );
  }
}
