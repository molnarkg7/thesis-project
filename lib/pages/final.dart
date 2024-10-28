import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

void main() {
  runApp(Final());
}

class Final extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FinalPage(),
    );
  }
}

class FinalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 382,
                height: 510,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/amfi.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Uspešno ste rezervisali termin!',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
