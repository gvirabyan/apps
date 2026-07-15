import 'dart:io';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Repository/NotificationRepository.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';

class PushNotificationProvider extends ChangeNotifier {
  void registerToken(String? token, BuildContext context) async {
    print("registerToken------>${token}");
    if (token == null) return;

    final settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    // Всегда отправляем токен на сервер: локальный кэш может расходиться с БД
    // (логаут стирает токен на сервере, но не сбрасывает локальный fcmId).
    var parameter = {
      FCMID: token,
      'device_type': Platform.isAndroid ? 'android' : 'ios'
    };

    final response =
        await NotificationRepository.updateFcmID(parameter: parameter);
    log('🔔 [PushInit] updateFcmID backend response = $response');
    if (response['error'] == false) {
      await settingsProvider.setFcmId(token);
      log('🔔 [PushInit] FCM token saved to backend ✅');
    } else {
      log('🔔 [PushInit] backend rejected FCM token ❌');
    }
  }
}
