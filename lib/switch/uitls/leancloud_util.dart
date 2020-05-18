import 'package:dio/dio.dart';

import 'key_util.dart';

class LeancloudUtil {
  Dio _lcDio;
  static LeancloudUtil _leancloudUtil;
  static LeancloudUtil get instance => _getInstance();

  static LeancloudUtil _getInstance() {
    if (_leancloudUtil == null) {
      _leancloudUtil = LeancloudUtil._internal();
    }
    return _leancloudUtil;
  }

  LeancloudUtil._internal() {
    if (_lcDio == null) {
      _lcDio = Dio();
      _lcDio.options
            ..connectTimeout = 10000
            ..sendTimeout = 10000
            ..receiveTimeout = 10000
            ..headers = {
              "X-LC-Id": KeyUtil.leancloudappId,
              "X-LC-Key": KeyUtil.leancloudappKey,
              "Content-Type": "application/json"
            }
          ;
      _lcDio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  //获取leancloud的信息
  Future<Response> getLC() async {
    Response response = await _lcDio.get(KeyUtil.getUrl());
    return response;
  }


}
