import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';

class passwordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onInteraction;
  const passwordFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.onInteraction});

  @override
  State<passwordFormField> createState() => _passwordFormFieldState();
}

class _passwordFormFieldState extends State<passwordFormField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onInteraction();
      },
      obscureText: hidePassword,
      style: const TextStyle(color: blackColor),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                hidePassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: visibilityColor,
              ),
            )),
        labelText: widget.labelText,
        labelStyle: TextStyle(
            color: hintColor, fontSize: 14, fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: textFormBorderColor, width: 1),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
