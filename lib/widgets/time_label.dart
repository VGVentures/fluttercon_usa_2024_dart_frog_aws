import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({
    required this.time,
    super.key,
  });

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        DateFormat('MMM dd hh:mm:a').format(time.toLocal()),
      ),
    );
  }
}
