import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mygetx_app/modules/languages_localization/language_controller.dart';
import 'package:mygetx_app/modules/home/home_view.dart';

void main() {
  runApp(const MyGetxApp());
}

class MyGetxApp extends StatelessWidget {
  const MyGetxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: const ExampleView(),
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale('en', 'US'),
          fallbackLocale: Locale('en', 'US'),
          translations: Languages(),
          title: 'First Method',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
    );
  }
}
