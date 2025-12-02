import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:toysell_app/MVC/view/loginScreen/splashScreen.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import 'package:toysell_app/services/notification_service.dart';
import 'package:toysell_app/services/local_storage.dart';
import 'package:toysell_app/services/localization_service.dart';
import 'constant/constants.dart';
import 'helper/data_storage.dart';

void main() async {
  Stripe.publishableKey = "pk_test_51R7irtFABAzbMj7BratMWzaf6FWoVKDdd2TleJ2xlKkpS5VbiHspoBR3LG8A9w8DXSWE0P1tDnXtPXu3URLKy0xW00CsetSgLP";

  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationService().initializeFirebase();

  await LocalDataStorage.getInstance.loadLang();

  await Stripe.instance.applySettings();

  DataStroge.loadOnboarding();

  // FirebaseDB.init();

  loadConfig();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());

  Get.put(ThemeHelper());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
          ),
          translations: LocalizationService(),
          locale: Locale(LocalDataStorage.lang.value),
          fallbackLocale: LocalizationService.fallbackLocale,
          home: child,
        );
      },
      child: Splashscreen(),
    );
  }
}

Future<void> loadConfig() async {
  try {
    String configString = await rootBundle.loadString('config/config.json');
    Map<String, dynamic> configJson = json.decode(configString);
    Constants.API_HOST = configJson['api_host'];
  } catch (e) {
    print(e);
    print("Configuration file does not exists or is not valid");
    exit(0);
  }
}
