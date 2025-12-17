import 'package:get/state_manager.dart';

class FavouriteController extends GetxController {
  RxList<String> fruitList = [
    'Orange',
    'Mango',
    'Banana',
    'Peach',
    'Pineapple',
    'Strawberries',
    'Apple',
  ].obs;

  RxList<String> tempFruitList = <String>[].obs;

  addToFavourite(String value) {
    tempFruitList.add(value);
  }

  removeFromFavourite(String value) {
    print(tempFruitList.remove(value));
    tempFruitList.remove(value);
  }
}
