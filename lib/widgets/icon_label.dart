import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final double iconSize;
  final double spacing;
  final TextStyle? textStyle;

  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.iconSize = 16,
    this.spacing = 6,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: color ?? baseStyle?.color),
        SizedBox(width: spacing),
        Text(
          label,
          style: baseStyle?.copyWith(color: color),
        ),
      ],
    );
  }
}
