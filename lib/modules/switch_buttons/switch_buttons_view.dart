import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:mygetx_app/modules/switch_buttons/switch_buttons_controller.dart';

class SwitchButtonsView extends StatefulWidget {
  const SwitchButtonsView({super.key});

  @override
  State<SwitchButtonsView> createState() => _SwitchButtonsViewState();
}

class _SwitchButtonsViewState extends State<SwitchButtonsView> {
  final SwitchButtonsController switchController = Get.put(
    SwitchButtonsController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Switch Notifications ")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Obx(() {
                return Switch(
                  value: switchController.notifications.value,
                  onChanged: (value) {
                    switchController.setNotification(value);
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
