import 'dart:async';

import 'package:flutter/material.dart';

class MyStopwatch extends StatefulWidget {
  const MyStopwatch({super.key});

  @override
  _MyStopwatchState createState() => _MyStopwatchState();
}

class _MyStopwatchState extends State<MyStopwatch> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _elapsedTime = '00:00';

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    // Set up a timer to update the stopwatch every second
    _timer = Timer.periodic(const Duration(seconds: 1), _updateStopwatch);
  }

  void _updateStopwatch(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        _elapsedTime = _formatDuration(_stopwatch.elapsed);
      });
    }
  }

  String _formatDuration(Duration duration) {
    return 
        '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _elapsedTime,
              style: const TextStyle(fontSize: 15),
            ),
            // SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if (_stopwatch.isRunning) {
            //             _stopwatch.stop();
            //           } else {
            //             _stopwatch.start();
            //           }
            //         });
            //       },
            //       child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
            //     ),
            //     SizedBox(width: 20),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           _stopwatch.reset();
            //           _elapsedTime = '00:00:00';
            //         });
            //       },
            //       child: Text('Reset'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }
}
