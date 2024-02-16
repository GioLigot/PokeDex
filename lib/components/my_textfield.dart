import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String? hintText;
  final Function(String)? onChanged;
  final double? height;


  const MyTextField({
    super.key,

    required this.controller,
    this.hintText,
    this.onChanged,
    this.height

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
            // Optional border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
        ),

      ),
    );
  }
}
