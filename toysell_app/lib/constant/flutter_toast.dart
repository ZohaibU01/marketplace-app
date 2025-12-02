import 'package:fluttertoast/fluttertoast.dart';
import 'package:toysell_app/constant/theme.dart';

class FlutterToastDisplay {
  static FlutterToastDisplay? _instance;
  static FlutterToastDisplay get getInstance =>
      _instance ??= FlutterToastDisplay();

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ThemeHelper.colortoast,
        textColor: ThemeHelper.colortoasttext,
        fontSize: 14.0);
  }
}
