import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customElevatedButton({required String text, required Widget page}) {
  return Center(
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => page);
        },
        child: Text(text),
      ),
    ),
  );
}
