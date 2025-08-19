import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Thanks extends StatefulWidget {
  const Thanks({super.key});

  @override
  State<Thanks> createState() => _ThanksState();
}

class _ThanksState extends State<Thanks> {
  bool isPlaying = false;
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();

    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thank you'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(80.100),
        child: Column(
          children: [
            Text(
              'Thank you for your feedback, we will improve according to your feedback as fast as possible. May your day be filled with good thoughts, kind people and happy moments',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20)),
            ConfettiWidget(
              confettiController: controller,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 7,
              minBlastForce: 1,
              maxBlastForce: 100,
            ),
          ],
        ),
      ),
    );
  }
}
