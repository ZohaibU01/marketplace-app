// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter_native_image/flutter_native_image.dart';


// class NativeCompressor {
  
//   static Future<File?> compressImage(File file) async {
//     try {
//       final compressedFile = await FlutterNativeImage.compressImage(file.path,
//           quality: 70, percentage: 70);
//       return File(compressedFile.path);
//     } catch (e) {
//       return null; //If any error occurs during compression, the process is stopped.
//     }
//   }

//   // static Future<File?> compressVideo(File file) async {
//   //   MediaInfo? mediaInfo = await VideoCompress.compressVideo(
//   //     file.path,
//   //     quality: VideoQuality.DefaultQuality,
//   //     includeAudio: true,
//   //     deleteOrigin: false, // It's false by default
//   //   );
//   //   var videoFile = mediaInfo!.file;
//   //   return videoFile;
//   // }
// }
