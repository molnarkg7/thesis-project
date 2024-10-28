import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/square_button.dart';
import 'package:diplomski_rad/components/button.dart';
import 'package:diplomski_rad/pages/validation.dart';

class CalendarPage extends StatefulWidget {
  final String brojUcionice;

  CalendarPage({required this.brojUcionice});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime date;
  late TimeOfDay time;

  int selectedNumberOfHours = 1;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 19,
                  ),
                  children: [
                    TextSpan(
                      text: 'Odabrali ste učionicu: ',
                    ),
                    TextSpan(
                      text: '${widget.brojUcionice}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Odaberite broj časova:',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 100,
                child: DropdownButtonFormField<int>(
                  value: selectedNumberOfHours,
                  items: [1, 2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedNumberOfHours = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Odaberite datum i vreme:',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 30),
              SquareBtn(
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    selectableDayPredicate: (DateTime day) {
                      return day.weekday != DateTime.sunday;
                    },
                  );

                  if (newDate == null) return;

                  setState(() {
                    date = newDate;
                  });
                },
                imagePath: 'lib/images/calendar.png',
              ),
              SizedBox(height: 30),
              SquareBtn(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.blue,
                            colorScheme:
                                ColorScheme.light(primary: Colors.blue),
                            buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        ),
                      );
                    },
                  );

                  if (newTime == null) return;

                  final int hour = newTime.hour;
                  final int minute = newTime.minute;

                  if (hour >= 8 && hour <= 20 && minute == 0) {
                    setState(() {
                      time = newTime;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Greška'),
                          content: Text(
                              'Molimo Vas da izaberete pun sat između 8h i 20h.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                imagePath: 'lib/images/clock.png',
              ),
              SizedBox(height: 30),
              Text(
                'Vaš termin: '
                '${date.day}/${date.month}/${date.year} u ${time.hour}č',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Trajanje: ${selectedNumberOfHours * 60} minuta (${selectedNumberOfHours}č)',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              MyButton2(
                onTap: () {
                  final int hour = time.hour;
                  final int minute = time.minute;

                  if (hour >= 8 && hour <= 20 && minute % 15 == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ValidationPage(
                          brojUcionice: widget.brojUcionice,
                          datum: date,
                          vreme: time,
                          selectedNumberOfHours: selectedNumberOfHours,
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Greška'),
                          content: Text(
                              'Molimo Vas da izaberete vreme između 8h i 20h'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
