import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/modules/opacity/opacity_view.dart';
import 'package:mygetx_app/modules/home/home_controller.dart';
import 'package:mygetx_app/modules/switch_buttons/switch_buttons_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CounterController controller = Get.put(CounterController());

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
                ElevatedButton(
                  onPressed: () {
                    Get.to(() {
                      return ExampleView();
                    });
                  },
                  child: const Text(
                    "Opacity Example",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() {
                      return SwitchButtonsView();
                    });
                  },
                  child: const Text(
                    "Switch Button Example",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
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
