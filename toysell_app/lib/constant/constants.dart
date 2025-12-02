import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  static const double screenPadding = 10;
  static const String currency = '\$';
  static var API_HOST = "";
  static var socket_host = "https://admin.carryconnectinc.com";

  static const String mapApiKey = "AIzaSyAcC8RkFxv3vKg0mEXtqSrZnL32imnLm30";

  static const String PlaceApi =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  //----DRIVER APP API'S
  static final RegisterApi = "$API_HOST/auth/register";
  static final RegisterdriverwithtokenApi = "$API_HOST/auth/registerwithtoken";

  static final CheckOtp_Api = "$API_HOST/auth/check-otp";
  static final forgetPassword_Api = "$API_HOST/auth/forgot-password";
  static final resendOtp_driver = "$API_HOST/auth/resend-otp";
  static final loginApi = "$API_HOST/auth/login";
  static final driver_forgot_password = "$API_HOST/driver/forgot-password";
  static final uploadProfilepictureApi = "$API_HOST/upload/profile";
  static final uploadprofileimage_Api = "$API_HOST/upload/profile";
  static final uploadNationalId_Api = "$API_HOST/upload/national-id";
  static final switchroleApi = "$API_HOST/switch-role";
  static final becomedriverApi = "$API_HOST/auth/register-driver";
  static final vehicleinfoApi = "$API_HOST/vehicle-info";
  static final vehiclelicenseApi = "$API_HOST/upload/vehicle-license";
  static final uploadcriminalclearancecertificateApi =
      "$API_HOST/upload/criminal-clearance-certificate";
  static final uploaddrivingtraningcertificatesApi =
      "$API_HOST/upload/driving-traning-certificates";
  static final editprofile_Api = "$API_HOST/edit-profile";
  static final getvehilcePrics_Api = "$API_HOST/vehicle-price";
  static final AddRating_Api = "$API_HOST/driver/rate-driver";
  static final Addbankdetails_Api = "$API_HOST/bank/bank";
  static final changepassword_Api = "$API_HOST/auth/change-password";
}
