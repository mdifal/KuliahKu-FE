import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildEditableFormField({
  required TextEditingController controller,
  required String labelText,
  IconData? prefixIcon,
  required Function(String) onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Stack(
      children: [
        prefixIcon != null ?
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: labelText,
            prefixIcon: Icon(prefixIcon),
          ),
        )
        : TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: labelText,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement edit functionality here
            },
          ),
        ),
      ],
    ),
  );
}