import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  static const String baseUrl = "https://toysell.hboxdigital.website/api";

  /// Generic POST method
  static Future<http.Response> post(
      String endpoint, {
        required Map<String, dynamic> data,
        String? token
      }) async {

    // Add headers
    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final url = Uri.parse('$baseUrl/$endpoint',);
    return await http.post(url, body: data,headers: headers);
  }

  /// Generic GET method with Bearer Token
  static Future<http.Response> get(String endpoint, {String? token, Map<String, dynamic>? queryParameters}) async {
    // Build the URL with query parameters if provided
    final url = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParameters);

    // Add headers
    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return await http.get(url, headers: headers);
  }

  /// Generic PUT method
  static Future<http.Response> put(
      String endpoint, {
        required Map<String, dynamic> data,
      }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.put(url, body: data);
  }

  /// Generic DELETE method
  static Future<http.Response> delete(String endpoint,{String? token,}) async {

    // Add headers
    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.delete(url,headers: headers);
  }

  /// POST Multipart Method with Bearer Token
  static Future<http.StreamedResponse> postMultiPart(
      String endpoint, {
        required Map<String, dynamic> fields,
        List<File>? files,
        String? fileFieldName,
        String? token,
      }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // Create Multipart Request
    var request = http.MultipartRequest("POST", url);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add text fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add files
    if (files != null && files.isNotEmpty) {
      var i = 0;
      for (var file in files) {
        final mimeType = lookupMimeType(file.path) ?? "application/octet-stream";
        final mimeParts = mimeType.split('/');
        var imageName = fileFieldName;
        if(fileFieldName == null){
          if(i > 0){
            imageName = "gallery_images[${i}]";
          }
          else{
            imageName = "image";
          }
        }
        if(i == 0){
          request.files.add(await http.MultipartFile.fromPath(
            "gallery_images[0]",
            file.path,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ));
        }
        request.files.add(await http.MultipartFile.fromPath(
          imageName!,
          file.path,
          contentType: MediaType(mimeParts[0], mimeParts[1]),
        ));
        i++;
      }
    }

    // Send the request
    return await request.send();
  }
}
