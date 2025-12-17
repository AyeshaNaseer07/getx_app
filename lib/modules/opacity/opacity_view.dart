import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mygetx_app/modules/opacity/opacity_controller.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  final ExampleController expcontroller = Get.put(ExampleController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");
    return Scaffold(
      appBar: AppBar(title: Text("Getx Second Example")),
      body: Column(
        children: [
          Obx(() {
            print("rebuild");
            return Container(
              height: 300,
              width: 400,
              // ignore: deprecated_member_use
              color: Colors.red.withOpacity(expcontroller.opacity.value),
            );
          }),
          Obx(() {
            return Slider(
              value: expcontroller.opacity.value,
              onChanged: (value) {
                expcontroller.setOpacity(value);
              },
            );
          }),
        ],
      ),
    );
  }
}
