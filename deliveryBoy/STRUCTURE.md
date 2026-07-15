# Delivery Boy App — Structure Guide

**App name:** eShop Multivendor Delivery Boy  
**API base:** `https://mntom.online/delivery_boy/app/v1/api/`  
**Framework:** Flutter · State: Provider + Cubit  
**Локальный бэкенд:** `D:\backendLive\application\controllers\delivery_boy\app\v1\Api.php`

---

## lib/ — Top-level layout

```
lib/
├── appConstants.dart        ← baseUrl, appName
├── main.dart
├── Helper/                  ← утилиты, константы
├── Localization/            ← JSON-файлы языков
├── Model/                   ← data-классы
├── Provider/                ← ChangeNotifier (бизнес-логика)
├── Repository/              ← HTTP-запросы
├── Screens/                 ← все экраны + Widget/ подпапки
├── Cubit/                   ← Cubit (язык, страны, возвраты)
└── Widget/                  ← переиспользуемые виджеты
```

---

## Helper/

| Файл | Что внутри |
|------|------------|
| `constant.dart` | Глобальные переменные, `baseUrl` |
| `ApiBaseHelper.dart` | Dio-клиент: `postAPICall(Uri, Map)` |
| `assetsConstant.dart` | Пути к локальным ассетам |
| `color.dart` | Цветовая схема |
| `curlLoggerInterceptor.dart` | Логирование как cURL |
| `firebase_notification.dart` | Firebase FCM хелпер |
| `push_notification_service.dart` | Инициализация FCM |
| `extensions/` | Dart-расширения |

---

## Model/

| Файл | Модель |
|------|--------|
| `orderModel.dart` | Заказ (для главного списка) |
| `order_model.dart` | Детали заказа / позиции |
| `ReturnOrderModel.dart` | Возвратный заказ |
| `cash_collection_model.dart` | Инкассация наличных |
| `notification_model.dart` | Уведомление |
| `transaction_model.dart` | Транзакция кошелька |
| `city.dart` | Город |
| `area.dart` | Район |
| `zipcodeModel.dart` | Индекс |
| `countryCodeModel.dart` | Код страны |
| `appSettingsModel.dart` | Настройки приложения |
| `appLanguageModel.dart` | Локализация |

---

## Provider/ (ChangeNotifier)

| Провайдер | Ответственность |
|-----------|----------------|
| `SettingsProvider.dart` | Токен, userId, настройки приложения, FCM |
| `AuthProvider.dart` | Вход, OTP, регистрация курьера |
| `UserProvider.dart` | Профиль курьера, обновление данных |
| `SystemProvider.dart` | Системные настройки (интернет, тема) |
| `homeProvider.dart` | Список заказов на главной, фильтрация |
| `orderDetailProvider.dart` | Детали заказа + обновление статуса |
| `WalletProvider.dart` | Кошелёк курьера |
| `cashCollectionProvider.dart` | Инкассация наличных по заказам |
| `notificationListProvider.dart` | Список push-уведомлений |
| `signupProvider.dart` | Форма регистрации нового курьера |
| `areaListProvider.dart` | Список районов |
| `cityListProvider.dart` | Список городов |
| `zipcodeListProvider.dart` | Список индексов |

---

## Repository/

| Файл | Эндпоинт(ы) |
|------|------------|
| `AuthRepository.dart` | `login`, `register`, `verify_user`, `verify_otp` |
| `UserRepository.dart` | `update_user`, `get_delivery_boy_details` |
| `homeRepositry.dart` | `get_orders` |
| `orderDetailRepositry.dart` | `update_order_consignment_status` |
| `returnOrderRepositry.dart` | `view_return_order_items` |
| `cashCollectionRepositry.dart` | `get_delivery_boy_cash_collection` |
| `WalletRepository.dart` | `send_withdrawal_request`, `get_withdrawal_request` |
| `NotificationRepository.dart` | `get_notifications` |
| `SystemRepository.dart` | `get_settings` |
| `AppSettingsRepository.dart` | `get_settings` |
| `cityRepository.dart` | `get_cities` |
| `areaRepository.dart` | `get_areas` |
| `zipcodeRepository.dart` | `get_zipcodes` |
| `countryCodeRepository.dart` | Коды стран |
| `hiveRepository.dart` | Локальное хранилище Hive |
| `orders/` | Дополнительные запросы к заказам |

---

## Cubit/

| Cubit | Назначение |
|-------|-----------|
| `languageCubit.dart` | Смена языка интерфейса |
| `loadCountryCodeCubit.dart` | Загрузка кодов стран для телефона |
| `returnOrderCubit.dart` | Загрузка возвратных заказов |
| `UpdateStatusReturnOrderCubit.dart` | Обновление статуса возврата |

---

## Screens/ — Экраны

| Экран | Что делает |
|-------|-----------|
| `Splash/` | Загрузка приложения, проверка токена |
| `Authentication/` | Вход по номеру телефона + OTP; форма регистрации нового курьера |
| `DeshBord/` | Главная обёртка с навигацией |
| `Home/` | Список заказов: новые / в пути / доставленные (фильтрация по статусу) |
| `Home/Widget/` | Карточки заказов, фильтр-чипы |
| `OrderDetail/` | Детали заказа: адрес, товары, обновление статуса (принять → забрать → доставить) |
| `OrderDetail/Widget/` | Виджеты карты маршрута, статус-кнопки, информация о покупателе |
| `Return/` | Список возвратных заказов |
| `Return/Widget/` | Карточки возвратов |
| `CashCollection/` | Сводка инкассации (сколько наличных получено от покупателей) |
| `CashCollection/Widget/` | Карточки по заказам |
| `WalletHistory/` | История транзакций кошелька |
| `WalletHistory/Widget/` | Карточки транзакций |
| `NotificationList/` | Список push-уведомлений |
| `NotificationList/Widget/` | Карточка уведомления |
| `Profile/` | Профиль курьера: имя, фото, телефон, обновление данных |
| `getDrawer/` | Боковое меню (кошелёк, профиль, выход) |
| `Privacy policy/` | Политика конфиденциальности |

---

## Widget/ (общие)

Переиспользуемые виджеты: кнопки, snackbar, shimmer-эффект, индикаторы сети, appBar.

---

## API-эндпоинты бэкенда (delivery_boy/app/v1/Api.php)

| Метод | Назначение |
|-------|-----------|
| `login` | Авторизация курьера |
| `register` | Регистрация нового курьера |
| `verify_user` / `verify_otp` | OTP-верификация |
| `get_orders` | Список заказов (с фильтрами) |
| `update_order_consignment_status` | Обновить статус доставки |
| `get_delivery_boy_details` | Данные профиля |
| `update_user` | Обновить профиль |
| `update_fcm` | Обновить FCM-токен |
| `get_notifications` | Уведомления |
| `get_delivery_boy_cash_collection` | Инкассация наличных |
| `send_withdrawal_request` | Запрос на вывод средств |
| `get_withdrawal_request` | История выводов |
| `reset_password` | Смена пароля |
| `get_settings` | Настройки приложения |
| `get_cities` / `get_zipcodes` | Справочники |
| `view_return_order_items` | Возвратные заказы |
| `delete_delivery_boy` | Удаление аккаунта |

---

## Поток обновления статуса заказа

```
Home → нажать на заказ
  → OrderDetail экран
    → кнопка (принять / в пути / доставлен)
      → orderDetailProvider.updateStatus()
        → orderDetailRepositry → update_order_consignment_status
          → бэкенд обновляет статус + отправляет push покупателю
```
