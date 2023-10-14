import 'dart:io';

import 'package:dio/dio.dart';
import 'package:testing_upload_download_app/service_api.dart';
import 'package:path/path.dart';

class FileService implements FeatureIndexApi {
  late Dio dio = Dio();
  @override
  Future<Response> fileUploadMultipart(String file_name, File file, OnUploadProgressCallback onUploadProgress) async {
    String uploadurl = "YOUR_API_HERE";
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path)
        //show only filename from path
      ),
      "file_name": file_name,
    });

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    Response response = await dio.post(uploadurl,
      queryParameters: queryParameters,
      options: Options(
        receiveTimeout: Duration(milliseconds: 60000),
        method: "POST",
        extra: _extra,
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {"Accept":"application/json"},
      ),
      data: formdata,
      onSendProgress: (int sent, int total) {
        if (onUploadProgress != null) {
          onUploadProgress(sent, total);
        }
      },);

    return response;
  }
}