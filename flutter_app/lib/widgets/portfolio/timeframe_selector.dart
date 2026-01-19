import 'package:flutter/material.dart';

class TimeframeSelector extends StatelessWidget {
  const TimeframeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: const [
        DropdownMenuItem(value: '24h', child: Text('24h')),
        DropdownMenuItem(value: '7d', child: Text('7d')),
        DropdownMenuItem(value: '30d', child: Text('30d')),
      ],
      onChanged: isDisabled
          ? null
          : (v) {
        if (v == null) return;
        onChanged(v);
      },
    );
  }
}
