// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoController extends GetxController {
//   late VideoPlayerController videoPlayerController;
//   ChewieController? chewieController;
//
//   RxBool isInitialized = false.obs;
//   final String videoUrl;
//     VideoController(this.videoUrl);
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     initPlayer();
//   }
//
//   void initPlayer() async {
//     videoPlayerController = VideoPlayerController.networkUrl(
//       Uri.parse(videoUrl),
//     );
//
//     await videoPlayerController.initialize();
//
//     chewieController = ChewieController(
//       videoPlayerController: videoPlayerController,
//       autoPlay: false,
//       looping: false,
//       showControls: true,
//       allowedScreenSleep: false,
//       allowFullScreen: true,
//       allowPlaybackSpeedChanging: true,
//       allowMuting: true,
//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.blue,
//         bufferedColor: Colors.grey,
//         handleColor: Colors.white,
//         backgroundColor: Colors.black45,
//       ),
//     );
//
//     isInitialized.value = true;
//   }
//
//   @override
//   void onClose() {
//     videoPlayerController.dispose();
//     chewieController?.dispose();
//     super.onClose();
//   }
// }
