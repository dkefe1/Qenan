import 'package:flutter/material.dart';

Widget errorText({required String text}) {
  return SizedBox(
    width: double.infinity,
    child: Text(
      text,
      style: TextStyle(
          color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
      textAlign: TextAlign.start,
    ),
  );
}
