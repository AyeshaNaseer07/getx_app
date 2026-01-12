import 'package:get/state_manager.dart';

class NotificationsController extends GetxController {
  RxBool notifications = false.obs;

  setNotification(bool value) {
    notifications.value = value;
  }
}
