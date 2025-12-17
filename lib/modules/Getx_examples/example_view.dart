import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/modules/Getx_examples/example_controller.dart';
import 'package:mygetx_app/modules/fav_screen/fav_view.dart';
import 'package:mygetx_app/image_picker/image_picker_view.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  final CounterController controller = Get.put(CounterController());
  final ExampleController expcontroller = Get.put(ExampleController());
  final SwitchButtonsController switchController = Get.put(
    SwitchButtonsController(),
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
                  controller.counter.toString(),
                  style: TextStyle(fontSize: 60, color: Colors.black),
                ),

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
                ElevatedButton(
                  onPressed: () {
                    Get.to(() {
                      return ExpView();
                    });
                  },
                  child: const Text("Another Example"),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Get.to(() {
                //       return ImagePickerView();
                //     });
                //   },
                //   child: const Text("Image Picker"),
                // ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.incrementCounter();
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
