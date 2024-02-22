import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TypeChoice extends StatelessWidget {
  IconData icon;
  String label;
  Color color;
  bool isSelected;

  TypeChoice({
    super.key,
    required this.icon,
    required this.label,
    this.color = Colors.grey,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            icon,
            size: 40,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
