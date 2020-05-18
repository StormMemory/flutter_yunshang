import 'package:dio/dio.dart';
import 'package:futures/app/ApiConfig.dart';

class APIService {
  Dio _dio;
  static APIService _apiService;
  static APIService get instance => _getInstance();
  // 超时时间
  int timeout = 10000;

  static APIService _getInstance() {
    if (_apiService == null) {
      _apiService = APIService._internal();
    }
    return _apiService;
  }

  APIService._internal() {
    if (_dio == null) {
      _dio = Dio();
      _dio.options
        ..connectTimeout = timeout
        ..sendTimeout = timeout
        ..receiveTimeout = timeout
        ..baseUrl = ApiConfig.host;
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Dio _picDio;
  static APIService _picAPIServicePic;
  static APIService get instancePic => _getPicInstance();

  static APIService _getPicInstance() {
    if (_picAPIServicePic == null) {
      _picAPIServicePic = APIService._picInternal();
    }
    return _picAPIServicePic;
  }

  APIService._picInternal() {
    if (_picDio == null) {
      _picDio = Dio();
      _picDio.options
        ..connectTimeout = timeout
        ..sendTimeout = timeout
        ..receiveTimeout = timeout
        ..baseUrl = ApiConfig.picHost;
      _picDio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Dio _lcDio;
  static APIService _lcApiService;
  static APIService get instanceLc => _getLcInstance();

  static APIService _getLcInstance() {
    if (_lcApiService == null) {
      _lcApiService = new APIService._lcInternal();
    }
    return _lcApiService;
  }

  APIService._lcInternal() {
    if (_lcDio == null) {
      _lcDio = Dio();
      _lcDio.options
        ..connectTimeout = 3000
        ..sendTimeout = 3000
        ..receiveTimeout = 3000
        ..headers = {
          "X-LC-Id": "WSII1rqO8ItftLLPnr9sXH4q-MdYXbMMI",
          "X-LC-Key": "R7fvTsHARTXk3vuH4cJKG6eq",
          "Content-Type": "application/json"
        }
        ..baseUrl = ApiConfig.lcHost;
      _lcDio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Dio _mockDio;
  static APIService _mockAPIServerPic;
  static APIService get instanceMock => _getMockInstance();

  static APIService _getMockInstance() {
    if (_mockAPIServerPic == null) {
      _mockAPIServerPic = new APIService._mockInternal();
    }
    return _mockAPIServerPic;
  }

  APIService._mockInternal() {
    if (_mockDio == null) {
      _mockDio = Dio();
      _mockDio.options
        ..connectTimeout = 3000
        ..sendTimeout = 3000
        ..receiveTimeout = 3000
        ..baseUrl = ApiConfig.mockHost;
      _mockDio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  //getMock
  Future<Response> getMock(String url) async {
    Response response = await _mockDio.get(url);
    return response;
  }

  //getLc
  Future<Response> getLc(String url) async {
    Response response = await _lcDio.get(url);
    return response;
  }

  // get请求
  Future<Response> getService(String url,
      {Map<String, dynamic> queryParameters}) async {
    Response response = await _dio.get(url, queryParameters: queryParameters);
    return response;
  }

  // post请求
  Future<Response> postService(String url,
      {Map<String, dynamic> parameters,
      Map<String, dynamic> data,
      Options options}) async {
    Response response = await _dio.post(url,
        queryParameters: parameters, data: data, options: options);
    return response;
  }

  // 发送put请求
  Future<Response> putService(String url,
      {Map<String, dynamic> parameters,
      Map<String, dynamic> data,
      Options options}) async {
    Response response = await _dio.put(url,
        queryParameters: parameters, data: data, options: options);
    return response;
  }

  // 发送post请求上传图片
  Future<Response> uploadPictureService(String url,
      {dynamic data, Options options}) async {
    Response response = await _picDio.post(url, data: data, options: options);
    return response;
  }
}
