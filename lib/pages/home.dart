import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diplomski_rad/pages/calendar.dart';

class Ucionica {
  String broj;
  String tip;
  int kapacitet;

  Ucionica(this.broj, this.tip, this.kapacitet);
}

class Objekat {
  String naziv;
  List<Ucionica> ucionice;

  Objekat(this.naziv, this.ucionice);
}

List<Objekat> ucitajPodatke() {
  final objekti = [
    Objekat("A", [
      Ucionica("A-P-27", "Standardna", 60),
      Ucionica("A-P-12", "Standardna", 60),
      Ucionica("A-P-14", "Standardna", 60),
      Ucionica("A-P-21", "Standardna", 60),
      Ucionica("A-I-11", "Standardna", 60),
      Ucionica("A-I-12", "Računarska", 40),
      Ucionica("A-I-13", "Standardna", 36),
      Ucionica("A-I-34", "Računarska", 40),
      Ucionica("A-I-37", "Standardna", 10),
      Ucionica("A-I-Nova", "Računarska", 20),
      Ucionica("A-II-8", "Standardna", 60),
      Ucionica("A-II-23 (Tempus)", "Računarska", 80),
      Ucionica("A-P-23 (Mali Amfiteatar)", "Standardna", 120),
    ]),
    Objekat("B", [
      Ucionica("B-II-10", "Računarska", 40),
      Ucionica("B-P-11", "Standardna", 40),
      Ucionica("B-P-23", "Standardna", 40),
      Ucionica("B-P-26", "Računarska", 40),
      Ucionica("B-I-11", "Standardna", 30),
      Ucionica("B-I-12", "Standardna", 40),
      Ucionica("B-I-18 (Svečana sala)", "Standardna", 120),
    ]),
    Objekat("C", [
      Ucionica("C-IV-2", "Računarska", 40),
      Ucionica("C62", "Standardna", 60),
      Ucionica("C68", "Standardna", 60),
      Ucionica("C71", "Standardna", 60),
      Ucionica("C82", "Računarska", 44),
      Ucionica("C85", "Standardna", 60),
    ]),
    Objekat("D", [
      Ucionica("Amfiteatar", "Standardna", 230),
      Ucionica("101", "Standardna", 36),
      Ucionica("102", "Standardna", 20),
      Ucionica("103", "Standardna", 20),
      Ucionica("104", "Standardna", 20),
      Ucionica("105", "Standardna", 20),
      Ucionica("106", "Standardna", 60),
      Ucionica("119", "Standardna", 60),
      Ucionica("201", "Standardna", 112),
      Ucionica("203", "Standardna", 20),
      Ucionica("204", "Standardna", 20),
      Ucionica("205", "Standardna", 18),
      Ucionica("206", "Standardna", 60),
      Ucionica("212", "Standardna", 72),
      Ucionica("216", "Standardna", 60),
      Ucionica("D62", "Računarska", 25),
      Ucionica("D66", "Računarska", 60),
    ]),
  ];

  return objekti;
}

List<Ucionica> filtrirajUcionice(String objekat, String tip) {
  final objekti = ucitajPodatke();

  final odabraniObjekat = objekti.firstWhere(
    (o) => o.naziv == objekat,
    orElse: () => Objekat('', []),
  );

  return odabraniObjekat.ucionice.where((u) => u.tip == tip).toList();
}

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final user = FirebaseAuth.instance.currentUser!;

// sign user out method
void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _MyHomePageState extends State<HomePage> {
  String selectedObjekat = 'A' ?? '';
  String selectedTipUcionice = 'Standardna' ?? '';

  void _prikaziDetaljeUcionice(String brojUcionice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(
          brojUcionice: brojUcionice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text('Odaberite objekat',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          DropdownButton<String>(
            value: selectedObjekat,
            items: ['A', 'B', 'C', 'D'].map((objekat) {
              return DropdownMenuItem<String>(
                value: objekat,
                child: Text(objekat),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedObjekat = value ?? '';
              });
            },
            style: TextStyle(
                fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          const Text('Odaberite tip učionice',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  )),
          DropdownButton<String>(
            value: selectedTipUcionice,
            items: ['Računarska', 'Standardna'].map((tip) {
              return DropdownMenuItem<String>(
                value: tip,
                child: Text(tip),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTipUcionice = value ?? '';
              });
            },
            style: TextStyle(
                fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          Text(
            'Odaberite učionicu',
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filtrirajUcionice(selectedObjekat, selectedTipUcionice)
                  .length,
              itemBuilder: (context, index) {
                final ucionica = filtrirajUcionice(
                    selectedObjekat, selectedTipUcionice)[index];
                return ListTile(
                  title: Text('${index + 1}) ${ucionica.broj}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600])),
                  onTap: () {
                    _prikaziDetaljeUcionice(ucionica.broj);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
