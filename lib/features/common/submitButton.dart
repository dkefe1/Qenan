import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';

Widget submitButton(
    {required String text,
    required bool disable,
    required VoidCallback onInteraction}) {
  return SizedBox(
    width: double.infinity,
    child: Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF07092D), Color(0xFF0179F3)])),
      child: ElevatedButton(
        onPressed: disable ? null : onInteraction,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(whiteColor),
            // MaterialStateProperty.all(disable ? grayTextColor : whiteColor),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20))),
        child: Text(
          text,
          style: TextStyle(
              color: disable ? grayTextColor : blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ),
    ),
  );
}
