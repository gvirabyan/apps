import 'dart:core';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/Constant.dart';

class NotificationRepository {
  static void addChatNotification({required String message}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    List<String> notificationMessages = sharedPreferences
            .getStringList(queueNotificationOfChatMessagesSharedPrefKey) ??
        List.from([]);

    notificationMessages.add(message);

    await sharedPreferences.setStringList(
        queueNotificationOfChatMessagesSharedPrefKey, notificationMessages);
  }

  static void clearChatNotifications() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    sharedPreferences
        .setStringList(queueNotificationOfChatMessagesSharedPrefKey, []);
  }

  static Future<List<String>> getChatNotifications() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    List<String> notificationMessages = sharedPreferences
            .getStringList(queueNotificationOfChatMessagesSharedPrefKey) ??
        List.from([]);
    return notificationMessages;
  }

  static Future<Map<String, dynamic>> updateFcmID({
    required var parameter,
  }) async {
    try {
      print(parameter);
      var responseData = await ApiBaseHelper().postAPICall(
        updateFcmApi,
        parameter,
      );

      print(responseData);

      return responseData;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  // static Future<void> updateFcmId(
  //     {required String fcmId,
  //     required String deviceType,
  //     required String isLogout}) async {
  //   var parameter = {
  //     FCMID: fcmId,
  //     'device_type': deviceType,
  //     'is_logout': isLogout
  //   };
  //   ApiBaseHelper().postAPICall(updateFcmApi, parameter).then(
  //         (getdata) async {},
  //         onError: (error) {},
  //       );
  // }
}
