import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rememberme/rememberme/screens/words_screen.dart';

class ResultsScreen extends StatefulWidget {
  final double percent;

  const ResultsScreen({super.key, required this.percent});
  @override
  _AnimatedPercentIndicatorScreenState createState() => _AnimatedPercentIndicatorScreenState();
}

class _AnimatedPercentIndicatorScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isAtCenter = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Animation duration
    );

    _animation = Tween<double>(begin: 1.0, end: 0.4).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation after a slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 100, // Center horizontally
                  top: MediaQuery.of(context).size.height * _animation.value - 100, // Moves vertically
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 13.0,
                        percent: widget.percent, // Example percentage
                        center: Text(
                          '${(widget.percent * 100).toStringAsFixed(1)} %',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              color: Colors.white),
                        ),
                        progressColor: Colors.green,
                        backgroundColor: Colors.white,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Accuracy',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 75, // Center the button
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  // backgroundColor: Colors.green, // Background color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white,),
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}