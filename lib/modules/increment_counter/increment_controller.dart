import 'package:get/state_manager.dart';

class CounterController extends GetxController {
  RxInt counter = 1.obs;

  setIncrementcounter() {
    print((counter.value));
    counter.value++;
  }
}
