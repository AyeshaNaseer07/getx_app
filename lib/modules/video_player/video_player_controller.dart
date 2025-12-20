import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> videoFile = Rx<File?>(null);
  VideoPlayerController? videoPlayerController;

  Future<void> pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 5),
    );

    if (video != null) {
      videoFile.value = File(video.path);

      videoPlayerController?.dispose();
      videoPlayerController = VideoPlayerController.file(videoFile.value!)
        ..initialize().then((_) {
          videoPlayerController!.play();
          update();
        });
    }
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }
}
