import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';

Widget logoutButton(
    {required String text,
    required bool disable,
    required VoidCallback onInteraction}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: disable ? null : onInteraction,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              disable ? loadingLogoutBtnColor : logoutColor),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20))),
      child: Text(
        text,
        style: TextStyle(
            color: whiteColor, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
