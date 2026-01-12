import 'package:get/state_manager.dart';

class OpacityController extends GetxController {
  RxDouble opacity = .3.obs;
  setOpacity(double value) {
    opacity.value = value;
  }
}
