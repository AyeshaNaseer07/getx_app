import 'package:get/state_manager.dart';

class CounterController extends GetxController {
  RxInt counter = 1.obs;

  setIncrementcounter() {
    print((counter.value));
    counter.value++;
  }
}

class OpacityController extends GetxController {
  RxDouble opacity = .3.obs;
  setOpacity(double value) {
    opacity.value = value;
  }
}

class NotificationsController extends GetxController {
  RxBool notifications = false.obs;

  setNotification(bool value) {
    notifications.value = value;
  }
}
