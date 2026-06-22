// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:chewie/chewie.dart';
// import 'package:plants_spotify/view/widgets/video_player/video_controller.dart';
//
// class CustomVideoPlayer extends StatelessWidget {
//   final String url;
//   final String tag;
//
//   const CustomVideoPlayer({
//     super.key,
//     required this.url,
//     required this.tag,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(VideoController(url), tag: tag);
//
//     return Obx(() {
//       return controller.isInitialized.value
//           ? SizedBox(
//         width: double.infinity,
//         height: 250,
//         child: Chewie(controller: controller.chewieController!,),
//       )
//           : const Center(child: CircularProgressIndicator());
//     });
//   }
// }
//
