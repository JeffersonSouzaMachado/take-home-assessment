import 'package:flutter/material.dart';

class TimeframeButton extends StatelessWidget {
  const TimeframeButton({super.key,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white24,
            ),
            color: selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}