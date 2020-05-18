import 'package:dio/dio.dart';

import 'key_util.dart';

class MockUtil {
  Dio _mockDio;
  static MockUtil _mockUtil;
  static MockUtil get instance => _getInstance();

  static MockUtil _getInstance() {
    if (_mockUtil == null) {
      _mockUtil = MockUtil._internal();
    }
    return _mockUtil;
  }

  MockUtil._internal() {
    if (_mockDio == null) {
      _mockDio = Dio();
      _mockDio.options
        ..connectTimeout = 3000
        ..sendTimeout = 3000
        ..receiveTimeout = 3000;
      _mockDio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }
  Future<Response> getMock() async {
    Response response = await _mockDio.get(KeyUtil.mockUrl);
    return response;
  }
}
