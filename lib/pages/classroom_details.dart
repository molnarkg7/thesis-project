import 'package:diplomski_rad/pages/calendar.dart';
import 'package:diplomski_rad/pages/home.dart';
import 'package:flutter/material.dart';

class ClassroomDetails extends StatelessWidget {
  final Ucionica ucionica;

  ClassroomDetails({required this.ucionica});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'lib/images/amfi.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ucionica.broj,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tip: ${ucionica.tip}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Kapacitet: ${ucionica.kapacitet}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CalendarPage(brojUcionice: ucionica.broj),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Rezerviši ovu salu',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
