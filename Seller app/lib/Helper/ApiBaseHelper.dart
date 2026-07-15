import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sellermultivendor/Helper/curlLoggerInterceptor.dart';
import '../Widget/security.dart';
import 'Constant.dart';
import 'package:dio/dio.dart' as dio_;

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;
  //
  @override
  String toString() {
    return errorMessage;
  }
}

class ApiBaseHelper {
  /// Convert `Map<dynamic, dynamic>` to `Map<String, dynamic>`
  /// This ensures Dio can properly encode the data
  Map<String, dynamic>? _convertToStringDynamicMap(Map? map) {
    if (map == null) return null;
    if (map.isEmpty) return <String, dynamic>{};

    return map.map((key, value) => MapEntry(key.toString(), value));
  }

  Future<void> downloadFile({
    required String url,
    required dio_.CancelToken cancelToken,
    required String savePath,
    required Function updateDownloadedPercentage,
  }) async {
    try {
      final dio_.Dio dio = dio_.Dio();
      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: ((count, total) {
          updateDownloadedPercentage((count / total) * 100);
        }),
      );
    } on dio_.DioException catch (e) {
      if (e.type == dio_.DioExceptionType.connectionError) {
        throw ApiException('No Internet connection');
      }
      throw ApiException('Failed to download file');
    } catch (e) {
      throw Exception('Failed to download file');
    }
  }

  Future<dynamic> postAPICall(
    Uri url,
    Map parameter, {
    bool skipAuth = false,
  }) async {
    var responseJson;
    try {
      final Dio dio = Dio();
      dio.interceptors.add(CurlLoggerInterceptor());

      // Prepare headers with Content-Type for form data
      final requestHeaders = {
        if (!skipAuth) ...headers,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      // Convert param to Map<String, dynamic> to ensure Dio can encode it properly
      final convertedParam = _convertToStringDynamicMap(parameter);

      final response = await dio.post(
        url.toString(),
        data: convertedParam?.isEmpty ?? true ? null : convertedParam,
        options: Options(
          headers: requestHeaders,
          contentType: Headers.formUrlEncodedContentType,
          sendTimeout: const Duration(seconds: timeOut),
          receiveTimeout: const Duration(seconds: timeOut),
        ),
      );

      print(
        "Parameter = $parameter, API = $url, responseCode : ${response.statusCode}, header : $headers response : ${response.data.toString()}",
      );
      responseJson = _responseDio(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw ApiException('No Internet connection');
      } else if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Something went wrong, Server not Responding');
      } else {
        throw ApiException('Something Went wrong with ${e.message}');
      }
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on Exception catch (e) {
      throw ApiException('Something Went wrong with ${e.toString()}');
    }
    return responseJson;
  }

  dynamic _responseDio(dio_.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode: ${response.statusCode}',
        );
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
    : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
