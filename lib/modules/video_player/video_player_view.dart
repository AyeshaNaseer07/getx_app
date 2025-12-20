import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygetx_app/modules/video_player/video_player_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPickerView extends StatelessWidget {
  VideoPickerView({super.key});

  final controller = Get.put(VideoPickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Picker')),
      body: GetBuilder<VideoPickerController>(
        builder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => controller.pickVideo(ImageSource.gallery),
                  child: const Text('Pick Video'),
                ),
                ElevatedButton(
                  onPressed: () => controller.pickVideo(ImageSource.camera),
                  child: const Text('Record Video'),
                ),
                if (controller.videoPlayerController != null &&
                    controller.videoPlayerController!.value.isInitialized)
                  SizedBox(
                    height: 600.h,
                    width: 350.w,
                    child: AspectRatio(
                      aspectRatio:
                          controller.videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(controller.videoPlayerController!),
                    ),
                  )
                else
                  Text('No video selected'),
              ],
            ),
          );
        },
      ),
    );
  }
}
