import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';

Widget textFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: blackColor),
    onChanged: (value) {
      onInteraction();
    },
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
      labelText: hintText,
      labelStyle: TextStyle(
          color: hintColor, fontSize: 14, fontWeight: FontWeight.w400),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: textFormBorderColor, width: 1),
          borderRadius: BorderRadius.circular(20)),
    ),
  );
}
