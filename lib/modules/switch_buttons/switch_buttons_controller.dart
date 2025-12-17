import 'package:get/get.dart';

class SwitchButtonsController extends GetxController {
  RxBool notifications = false.obs;

  setNotification(bool value) {
    print(notifications.value);
    notifications.value = value;
  }
}
