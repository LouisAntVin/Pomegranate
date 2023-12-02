import 'package:flutter/material.dart';

showMsg(BuildContext context, String msg, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: isError ? Colors.red : Colors.green,
  ));
}