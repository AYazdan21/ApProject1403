import 'package:ap_flutter/layers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: loginPage())) ;
}

class loginPage extends StatelessWidget {
  const loginPage({super.key});
  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double heightOfScreen = MediaQuery.of(context).size.height;
    print("*******     $widthOfScreen      *********");
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.indigoAccent),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 55,
                left: widthOfScreen * 0.3,
                child: const Text(
                  "SBU CONNECTED!",
                  style: TextStyle(fontSize: 21, color: Colors.white),
                )),
            Positioned(
                top: 100,
                left: widthOfScreen * 0.5 - 100,
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('images/studentLogo.png'))),
            Positioned(top: 275, right: 0, left: 0, child: LayerOne()),
          ],
        ),
      ),
    );
  }
}
