import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/yes_btn.dart';
import 'package:diplomski_rad/pages/final.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ValidationPage extends StatelessWidget {
  final String brojUcionice;
  final DateTime datum;
  final TimeOfDay vreme;
  final int selectedNumberOfHours;

  ValidationPage({
    required this.brojUcionice,
    required this.datum,
    required this.vreme,
    required this.selectedNumberOfHours,
  });

  Future<bool> proveriDostupnostTermina(String brojUcionice, DateTime datum,
      TimeOfDay vreme, int selectedNumberOfHours) async {
    DateTime pocetniTermin =
        DateTime(datum.year, datum.month, datum.day, vreme.hour, vreme.minute);
    DateTime krajnjiTermin =
        pocetniTermin.add(Duration(minutes: selectedNumberOfHours * 60));

    QuerySnapshot rezervacije = await FirebaseFirestore.instance
        .collection('rezervacije')
        .where('brojUcionice', isEqualTo: brojUcionice)
        .where('datum', isEqualTo: datum)
        .get();

    for (QueryDocumentSnapshot rezervacija in rezervacije.docs) {
      DateTime rezervacijaPocetak =
          (rezervacija['pocetniTermin'] as Timestamp).toDate();
      DateTime rezervacijaKraj =
          (rezervacija['krajnjiTermin'] as Timestamp).toDate();

      if ((pocetniTermin.isBefore(rezervacijaKraj) &&
              krajnjiTermin.isAfter(rezervacijaPocetak)) ||
          (pocetniTermin.isAfter(rezervacijaPocetak) &&
              pocetniTermin.isBefore(rezervacijaKraj))) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Odabrali ste:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 19,
                    ),
                    children: [
                      TextSpan(
                        text: 'Učionica: ',
                      ),
                      TextSpan(
                        text: '${brojUcionice}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 19,
                    ),
                    children: [
                      TextSpan(
                        text: 'Datum: ',
                      ),
                      TextSpan(
                        text: '${datum.day}/${datum.month}/${datum.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 19,
                    ),
                    children: [
                      TextSpan(
                        text: 'Vreme: ',
                      ),
                      TextSpan(
                        text: '${vreme.hour}č',
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 19,
                    ),
                    children: [
                      TextSpan(
                        text: 'Trajanje: ',
                      ),
                      TextSpan(
                        text:
                            '${selectedNumberOfHours * 60} minuta (${selectedNumberOfHours}č)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Da li želite da rezervišete termin?',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          YesBtn(
            onTap: () async {
              bool dostupanTermin = await proveriDostupnostTermina(
                  brojUcionice, datum, vreme, selectedNumberOfHours);

              if (dostupanTermin) {
                DateTime pocetniTermin = DateTime(datum.year, datum.month,
                    datum.day, vreme.hour, vreme.minute);

                FirebaseFirestore.instance.collection('rezervacije').add({
                  'brojUcionice': brojUcionice,
                  'datum': Timestamp.fromDate(datum),
                  'pocetniTermin': Timestamp.fromDate(pocetniTermin),
                  'krajnjiTermin': Timestamp.fromDate(pocetniTermin
                      .add(Duration(minutes: selectedNumberOfHours * 60))),
                  'selectedNumberOfHours': selectedNumberOfHours,
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinalPage(),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Greška'),
                      content: Text(
                          'Termin za odabranu učionicu je već rezervisan.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
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
    );
  }
}
