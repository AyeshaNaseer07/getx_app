import 'package:get/get.dart';

class ExampleController extends GetxController {
  RxDouble opacity = .3.obs;

  setOpacity(double value) {
    opacity.value = value;
  }
}
