import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CancellationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ReservationList(),
    );
  }
}

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('rezervacije').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        var reservations = snapshot.data?.docs;

        if (reservations == null || reservations.isEmpty) {
          return Center(child: Text('Nema rezervacija.'));
        }

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            var reservation = reservations[index];

            var dateFormat = DateFormat.yMd();
            var timeFormat = DateFormat.Hm();

            return ListTile(
              title: Text('Učionica: ${reservation['brojUcionice']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Datum: ${dateFormat.format(reservation['datum'].toDate())}'),
                  Text(
                      'Termin: ${timeFormat.format(reservation['pocetniTermin'].toDate())} '
                      '- ${timeFormat.format(reservation['krajnjiTermin'].toDate())}'),
                  Text('Trajanje: ${reservation['selectedNumberOfHours']}č'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('rezervacije')
                      .doc(reservation.id)
                      .delete()
                      .then((value) {
                    setState(() {});
                  }).catchError((error) {
                    print('Greška prilikom brisanja rezervacije: $error');
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
