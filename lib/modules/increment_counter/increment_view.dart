import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/modules/increment_counter/increment_controller.dart';

class IncrementCounterView extends StatefulWidget {
  const IncrementCounterView({super.key});

  @override
  State<IncrementCounterView> createState() => _IncrementCounterViewState();
}

class _IncrementCounterViewState extends State<IncrementCounterView> {
  final CounterController countcontroller = Get.put(CounterController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");
    return Scaffold(
      appBar: AppBar(title: Text("Increment Counter Example")),
      body: Center(
        child: Obx(() {
          debugPrint("rebuild");
          return Center(
            child: Text(
              countcontroller.counter.toString(),
              style: TextStyle(fontSize: 60, color: Colors.black),
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
