import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/modules/switch_notifications/switch_notification_controller.dart';

class SwitchNotificationView extends StatefulWidget {
  const SwitchNotificationView({super.key});

  @override
  State<SwitchNotificationView> createState() => _SwitchNotificationViewState();
}

class _SwitchNotificationViewState extends State<SwitchNotificationView> {
  final NotificationsController notController = Get.put(
    NotificationsController(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");
    return Scaffold(
      appBar: AppBar(title: Text("Opacity Slider Example")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          Obx(() {
            return Switch(
              value: notController.notifications.value,
              onChanged: (value) {
                notController.setNotification(value);
              },
            );
          }),
        ],
      ),
    );
  }
}
