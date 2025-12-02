// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:toysell_app/constant/constants.dart';
// import 'package:toysell_app/constant/navigation.dart';
// import 'package:toysell_app/data/model/user_model.dart';
// import 'package:toysell_app/screens/profile/view/profile_screen.dart';
// import 'package:toysell_app/screens/videos/view/videoreels_screen.dart';
// import 'package:toysell_app/services/app_service.dart';
// import '../../constant/flutter_toast.dart';
// import '../../constant/theme.dart';
// import '../../helper/data_storage.dart';

// // final dio = Dio();

// class AuthenticationApi extends AppService {
//   static AuthenticationApi? _instance;
//   static AuthenticationApi get getInstance => _instance ??= AuthenticationApi();

//   final _pref = DataStroge();
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   //----------------------SIGN UP ---------------
//   Future<void> authenticationApi(
//       BuildContext context, UserModel userData, int loginType) async {
//     try {
//       log('FcmToken ${DataStroge.fcmToken.value}');
//       log('UserData==>${userData.toString()}');
//       var _dio = Dio();
//       var header = {'Content-Type': 'application/json'};
//       _dio.options.headers = header;
//       var response = await _dio.post(Constants.postAuth, data: {
//         'name': userData.name,
//         'role': userData.role,
//         'phone_number': userData.phoneNumber,
//         'password': userData.password,
//         'email': userData.email,
//         'logintype': loginType,
//         'fcmToken': DataStroge.fcmToken.value,
//         'deviceID': DataStroge.DeviceID.value,
//       });

//       log("statusCode =>${response.statusCode}");
//       log('Register API done${response.data} 👌✅');

//       if (response.statusCode == 201) {
//         final json = response.data;
//         if (json['status'] == "success") {
//           var token = json['token'];
//           var role = json['data']['role'].toString();
//           print("$role Token==> $token");
//           var id = response.data['data']['id'];
//           var name = json['data']['name'].toString();
//           var email = json['data']['email'].toString();
//           var phone = json['data']['phone_number'].toString();
//           var image = json['data']['image'].toString();

//           // var role = json['data']['role'].toString();

//           log("userID $id");
//           log("userToken $token");
//           log("userName $name");
//           log("userEmail $email");
//           log("userPhone $phone");
//           log("userRole $role");
//           log("userImage $image");
//           DataStroge.getInstance.setTokenAuth(token);
//           await _pref.insertUserData(
//             id: id,
//             name: name,
//             email: email,
//             image: image,
//             role: role,
//             phone: phone,
//             token: token,
//           );

//           if (role == 'owner') {
//             Navigation.getInstance
//                 .pagePushAndReplaceNavigation(context, ProfileScreen());
//           } else {
//             Navigation.getInstance
//                 .pagePushAndReplaceNavigation(context, VideoReelsScreen());
//           }
//         } else {
//           print('Unknown Error Occurred ${(response.data)} ');
//         }
//       } else {
//         print('Unknown Error Status Occurred ${(response.data)} ');
//       }
//     } on DioError catch (e) {
//       if (e.response != null) {
//         FlutterToastDisplay.getInstance
//             .showToast("${e.response!.data['message']}");

//         print("Error msg data: ${e.response!.data['message']}");
//       } else {
//         print("Error sending data: $e");
//       }

//       print(e);
//     }
//   }
// }
