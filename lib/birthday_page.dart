import 'dart:io';
import 'dart:math';
import 'package:ap_flutter/info.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class BirthdaysTab extends StatefulWidget {
  @override
  _BirthdaysTabState createState() => _BirthdaysTabState();
}

class _BirthdaysTabState extends State<BirthdaysTab> {
  final List<String> _birthdays = [];
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 10));
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
    _receiveBirthdaysFromServer();
  }

  @override
  void dispose() {
    _isMounted = false;
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _receiveBirthdaysFromServer() async {
    try {
      final socket = await Socket.connect("192.168.131.93", 8412);
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.write('birthday~$stuID_info\u0000');
      // await socket.flush();
      // print('Data sent to server: $birthday\u0000');
      socket.listen((data) {
        final response = String.fromCharCodes(data).trim();
        print('Response from server: $response');

        if (_isMounted) {
          setState(() {
            _birthdays.clear();
            if (response.isNotEmpty) {
              _birthdays.addAll(response.split(','));
            }
          });
        }
      });
    } catch (e) {
      print('Error: $e');
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Today\'s Birthdays',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFF2F1E9D),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _birthdays.isEmpty
                    ? Center(
                  child: Text(
                    "No birthdays today",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _birthdays.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color(0xFFFBF2FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.cake, color: Color(0xFF2F1E9D)),
                        title: Center(
                          child: Text(
                            _birthdays[index],
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.purple[900],
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Shoot straight up
              emissionFrequency: 0.05, // How often it should emit
              numberOfParticles: 20, // Number of particles to emit
              gravity: 0.1, // fall speed
              shouldLoop: false, // Ensure it stops after the duration
              colors: const [Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.yellow, Colors.purpleAccent, Colors.deepPurpleAccent, Colors.deepPurple],
            ),
          ),
        ],
      ),
    );
  }
}
