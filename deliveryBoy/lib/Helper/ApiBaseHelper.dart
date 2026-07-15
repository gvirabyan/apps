import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../Widget/security.dart';
import 'constant.dart';
import 'curlLoggerInterceptor.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}

class ApiBaseHelper {
  Future<dynamic> postAPICall(Uri url, Map param) async {
    var responseJson;
    try {
      final Dio dio = Dio();
      dio.interceptors.add(CurlLoggerInterceptor());

      // Configure Dio options
      dio.options.headers = headers ?? {};
      dio.options.connectTimeout = Duration(seconds: timeOut);
      dio.options.receiveTimeout = Duration(seconds: timeOut);

      // Convert Map to FormData
      final formData = FormData.fromMap(
        param.isNotEmpty ? param.cast<String, dynamic>() : {},
      );

      final response = await dio.post(url.toString(), data: formData);

      print(
        'response api*********$url**********$headers********param:$param*********${response.statusCode}*********${response.data}',
      );

      responseJson = _responseDio(response);
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Something went wrong, Server not Responding');
      } else if (e.type == DioExceptionType.connectionError) {
        throw ApiException('No Internet connection');
      } else if (e.response != null) {
        responseJson = _responseDio(e.response!);
      } else {
        throw ApiException('Something Went wrong with ${e.toString()}');
      }
    } on Exception catch (e) {
      throw ApiException('Something Went wrong with ${e.toString()}');
    }
    return responseJson;
  }

  dynamic _responseDio(Response response) {
    switch (response.statusCode) {
      case 200:
        // Dio already parses JSON, so check if data is already parsed
        if (response.data is String) {
          var responseJson = json.decode(response.data.toString());
          return responseJson;
        }
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        var data = response.data;
        var message = (data is Map && data.containsKey('message'))
            ? data['message'] ?? ""
            : "";
        throw ApiException(message);
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
  final message;
  final prefix;

  CustomException([this.message, this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
    : super(message, 'Error During Communication: ');
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, 'Unauthorised: ');
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, 'Invalid Input: ');
}
