import 'package:diplomski_rad/pages/classroom_details.dart';
import 'package:diplomski_rad/pages/home.dart';
import 'package:flutter/material.dart';

class ClassroomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Objekat> objekti = ucitajPodatke();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: objekti.length,
        itemBuilder: (BuildContext context, int index) {
          Objekat objekat = objekti[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  objekat.naziv,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: objekat.ucionice.map((ucionica) {
                  return ListTile(
                    title: Text(ucionica.broj),
                    subtitle: Text(
                        'Tip: ${ucionica.tip}, Kapacitet: ${ucionica.kapacitet}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ClassroomDetails(ucionica: ucionica),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
