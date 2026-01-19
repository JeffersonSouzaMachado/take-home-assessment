import 'package:flutter/material.dart';

class JsonCard extends StatelessWidget {
  const JsonCard({super.key, required this.data});

  final Object? data;

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No data available.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          data.toString(),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      ),
    );
  }
}
