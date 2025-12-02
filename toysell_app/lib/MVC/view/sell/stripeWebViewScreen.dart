// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:toysell_app/MVC/view/home/homeScreen.dart';
// import 'package:toysell_app/components/BottomNav.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

// class StripeWebViewScreen extends StatefulWidget {
//   final String url;

//   const StripeWebViewScreen({super.key, required this.url});

//   @override
//   State<StripeWebViewScreen> createState() => _StripeWebViewScreenState();
// }

// class _StripeWebViewScreenState extends State<StripeWebViewScreen> {
//   late WebViewControllerPlus _controler;

//   @override
//   void initState() {
//     _controler = WebViewControllerPlus()
//       // ..setNavigationDelegate(
//       //   // NavigationDelegate(
//       //   //   onPageFinished: (url) async {
//       //   //     double height = await _controler.webViewHeight;
//       //   //
//       //   //     if (height != _height) {
//       //   //       if (kDebugMode) {
//       //   //         print("Height is: $height");
//       //   //       }
//       //   //       setState(() {
//       //   //         _height = height;
//       //   //       });
//       //   //     }
//       //   //   },
//       //   // ),
//       // )
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..loadRequest(Uri.parse(widget.url));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stripe Onboarding"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Get.offAll(() => BottomNavBar());
//           },
//         ),
//       ),
//       body: WebViewWidget(
//         controller: _controler,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeWebViewScreen extends StatelessWidget {
  final String url;
  RxBool loading = false.obs;
  StripeWebViewScreen({super.key, required this.url});
 Future<void> _launchUrl() async {
  try {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // ✅ Add actual delay
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    print('Launch error: $e');
    // You can show a snackbar or alert here
  } finally {
    loading.value = false;
  }
}


  @override
  Widget build(BuildContext context) {
    _launchUrl(); // immediately launch
    return Scaffold(
      body: Center(
          child: Obx(
            () =>  Visibility(
                    visible: loading.value == true,
                    child: CircularProgressIndicator(),
                    replacement: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpringWidget(
                onTap: () {
                    Get.offAll(() => BottomNavBar());
                },
                child: Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(20.sp),
                  child: Text("Back of Home"),
                ),
              )
            ],
                    ),
                  ),
          )),
    );
  }
}
