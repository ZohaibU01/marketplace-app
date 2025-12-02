import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GetxControllersProvider extends GetxController {
  RxString imagePath = ''.obs;
  RxString AddimagePath = ''.obs;
  RxString AddvideoPath = ''.obs;
  RxString KYCFrontimagePath = ''.obs;

  var defaultImagePath = 'assets/images/default.jpg';
  Future getImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imagePath.value = image.path;
      update();
      return imagePath.value;
    } else {
      imagePath.value = '';
      return null;
    }
  }

  Future getFromCameraImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      imagePath.value = image.path.toString();
      update();
      return imagePath.value;
    } else {
      imagePath.value = '';
      return null;
    }
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }
}
