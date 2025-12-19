import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygetx_app/modules/img_picker/image_picker_view.dart';
import 'package:mygetx_app/modules/fav_list/fav_list_view.dart';
import 'package:mygetx_app/modules/home/home_custom_widget.dart';
import 'package:mygetx_app/modules/increment_counter/increment_view.dart';
import 'package:mygetx_app/modules/languages_localization/language_view.dart';
import 'package:mygetx_app/modules/opacity_slider/opacity_slider_view.dart';
import 'package:mygetx_app/modules/switch_notifications/switch_notification_view.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild whole screen");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Getx Counter Example",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          customElevatedButton(
            text: 'Increment Counter Example',
            page: IncrementCounterView(),
          ),
          SizedBox(height: 10.h),
          customElevatedButton(
            text: 'Opacity Slider Example',
            page: OpacitySliderView(),
          ),
          SizedBox(height: 10.h),
          customElevatedButton(
            text: 'Switch Notifications Example',
            page: SwitchNotificationView(),
          ),
          SizedBox(height: 10.h),
          customElevatedButton(
            text: 'Fvaourite List Example',
            page: FavListView(),
          ),
          SizedBox(height: 10.h),
          customElevatedButton(
            text: 'Language Translator Example',
            page: LanguageView(),
          ),
          SizedBox(height: 10.h),
          customElevatedButton(
            text: 'Image Picker Example',
            page: ImagePickerView(),
          ),
        ],
      ),
    );
  }
}
