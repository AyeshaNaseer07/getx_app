import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Languages translation")),
      body: Column(
        children: [
          ListTile(title: Text('message'.tr), subtitle: Text('name'.tr)),
          SizedBox(height: 10.h),
          OutlinedButton(
            onPressed: () {
              Get.updateLocale(Locale('en', 'US'));
            },
            child: Text('ENGLISH'),
          ),
          SizedBox(height: 10.h),
          OutlinedButton(
            onPressed: () {
              Get.updateLocale(Locale('ur', 'PK'));
            },
            child: Text('URDU'),
          ),
          SizedBox(height: 10.h),
          OutlinedButton(
            onPressed: () {
              Get.updateLocale(Locale('hi', 'IN'));
            },
            child: Text('HINDI'),
          ),
          SizedBox(height: 10.h),
          OutlinedButton(
            onPressed: () {
              Get.updateLocale(Locale('es', 'SP'));
            },
            child: Text('SPANISH'),
          ),
        ],
      ),
    );
  }
}
