import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qenan/core/constants.dart';

Widget phoneFormField(
    {required TextEditingController controller,
    required String hintText,
    required VoidCallback onInteraction}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: blackColor),
    onChanged: (value) {
      onInteraction();
    },
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      LengthLimitingTextInputFormatter(10)
    ],
    keyboardType: TextInputType.phone,
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
