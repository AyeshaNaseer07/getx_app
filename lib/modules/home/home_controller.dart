import 'package:get/state_manager.dart';

class CounterController extends GetxController {
  RxInt counter = 1.obs;

  incrementCounter() {
    counter.value++;
    print((counter.value));
  }
}
