import 'package:get/state_manager.dart';

class CounterController extends GetxController {
  RxInt counter = 1.obs;

  incrementCounter() {
    counter.value++;
    print((counter.value));
  }
}

class ExampleController extends GetxController {
  RxDouble opacity = .3.obs;

  setOpacity(double value) {
    opacity.value = value;
  }
}

class SwitchButtonsController extends GetxController {
  RxBool notifications = false.obs;

  setNotification(bool value) {
    print(notifications.value);
    notifications.value = value;
  }
}
