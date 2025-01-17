import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API{
  // It is used to create a common dio instance which can be used anywhere
  final Dio _dio = Dio();

  API(){
    _dio.options.baseUrl="https://jsonplaceholder.typicode.com";
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    //     print("REQUEST [${options.method}] => PATH: ${options.path}");
    //     print("Headers: ${options.headers}");
    //     if (options.data != null) {
    //       print("Request Body: ${options.data}");
    //     }
    //     handler.next(options); // continue
    //   },
    //   onResponse: (Response response, ResponseInterceptorHandler handler) {
    //     print("RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}");
    //     print("Response Data: ${response.data}");
    //     handler.resolve(response);
    //     handler.next(response); // continue
    //   },
    //   onError: (DioException error, ErrorInterceptorHandler handler) {
    //     print("ERROR [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}");
    //     print("Error Message: ${error.message}");
    //     if (error.response != null) {
    //       print("Error Data: ${error.response?.data}");
    //     }
    //     handler.next(error); // continue
    //   },
    //   ),
    // );
  }

  Dio get sendRequest => _dio;
}