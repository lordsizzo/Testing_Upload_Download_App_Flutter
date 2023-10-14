
import 'dart:io';

import 'package:dio/dio.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
abstract class FeatureIndexApi {
  Future<Response> fileUploadMultipart(String file_name, File file, OnUploadProgressCallback onUploadProgress);
}