import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/image_picker/image_picker_controller.dart';

class ImagePickerView extends StatelessWidget {
  ImagePickerView({super.key});

  final ImagePickerController imgcontroller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");

    return Scaffold(
      appBar: AppBar(title: const Text("IMAGE PICKER")),
      body: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 180,
                backgroundImage: imgcontroller.imagePath.isNotEmpty
                    ? FileImage(File(imgcontroller.imagePath.toString()))
                    : null,
              ),
            ),
            TextButton(
              onPressed: () {
                imgcontroller.getImage();
              },
              child: Text('Pick Image'),
            ),
          ],
        );
      }),
    );
  }
}
