import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/img_pic/image_picker_view.dart';
import 'package:mygetx_app/languages_localization/language_view.dart';
import 'package:mygetx_app/modules/Getx_examples/example_controller.dart';
import 'package:mygetx_app/modules/fav_screen/fav_view.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  final CounterController countcontroller = Get.put(CounterController());
  final OpacityController opcontroller = Get.put(OpacityController());
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
      appBar: AppBar(title: Text("Getx Counter Example")),
      body: Center(
        child: Obx(() {
          debugPrint("rebuild");
          return Center(
            child: Column(
              children: [
                Text(
                  countcontroller.counter.toString(),
                  style: TextStyle(fontSize: 60, color: Colors.black),
                ),

                Obx(() {
                  print("rebuild");
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
                Row(
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
                ElevatedButton(
                  onPressed: () {
                    Get.to(() {
                      return ImagePickerView();
                    });
                  },
                  child: const Text("Image Picker"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() {
                      return ExpView();
                    });
                  },
                  child: const Text("Another Example"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() {
                      return LanguageView();
                    });
                  },
                  child: const Text("Languages Translator"),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          countcontroller.setIncrementcounter();
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
