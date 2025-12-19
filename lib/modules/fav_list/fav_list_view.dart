import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:mygetx_app/modules/fav_list/fav_list_controller.dart';

class FavListView extends StatelessWidget {
  FavListView({super.key});

  final FavouriteController favcontroller = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");

    return Scaffold(
      appBar: AppBar(title: const Text("Getx Favourite Example")),
      body: ListView.builder(
        itemCount: favcontroller.fruitList.length,
        itemBuilder: (_, index) {
          final friut = favcontroller.fruitList[index].toString();
          return Card(
            child: ListTile(
              onTap: () {
                if (favcontroller.tempFruitList.contains(friut)) {
                  favcontroller.removeFromFavourite(friut);
                } else {
                  favcontroller.addToFavourite(friut);
                }
              },
              title: Text(friut),
              trailing: Obx(
                () => Icon(
                  favcontroller.tempFruitList.contains(friut)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
