import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/modules/opacity_slider/opacity_slider_controller.dart';

class OpacitySliderView extends StatefulWidget {
  const OpacitySliderView({super.key});

  @override
  State<OpacitySliderView> createState() => _OpacitySliderViewState();
}

class _OpacitySliderViewState extends State<OpacitySliderView> {
  final OpacityController opcontroller = Get.put(OpacityController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");
    return Scaffold(
      appBar: AppBar(title: Text("Opacity Slider Example")),
      body: Column(
        children: [
          Obx(() {
            debugPrint("rebuild");
            return Container(
              height: 300,
              width: 400,
              // ignore: deprecated_member_use
              color: Colors.red.withOpacity(opcontroller.opacity.value),
            );
          }),
          Obx(() {
            return Slider(
              value: opcontroller.opacity.value,
              onChanged: (value) {
                opcontroller.setOpacity(value);
              },
            );
          }),
        ],
      ),
    );
  }
}
