# Seller App — Structure Guide

**App name:** eShop Multivendor Seller  
**Package:** `wrteam.seller.multivendor` / `eshop.seller.multivendor`  
**API base:** `https://mntom.online/seller/app/v1/api/`  
**Chat API:** `https://mntom.online/seller/app/v1/Chat_Api/`  
**Framework:** Flutter · State: Provider  
**Локальный бэкенд (актуальный):** `C:\laragon\www\mntom\application\controllers\seller\app\v1\Api.php` (старый путь `D:\backendLive` устарел)

---

## lib/ — Top-level layout

```
lib/
├── appConstants.dart        ← baseUrl, chatBaseUrl, wafeqApiKey
├── main.dart
├── Helper/                  ← утилиты, расширения
├── Localization/            ← JSON-файлы языков
├── Model/                   ← data-классы
├── Provider/                ← ChangeNotifier (бизнес-логика)
├── Repository/              ← HTTP-запросы
├── Screen/                  ← все экраны + Widget/ подпапки
├── Widget/                  ← переиспользуемые виджеты и утилиты
├── cubits/                  ← Cubit (чат, заказы, почта)
└── Services/                ← Wafeq e-Invoicing сервис
```

---

## Helper/

| Файл | Что внутри |
|------|------------|
| `Constant.dart` | Глобальные переменные, `baseUrl` (импорт из `appConstants`) |
| `ApiBaseHelper.dart` | Dio-клиент: `postAPICall(Uri, Map)` с авторизацией через `headers` |
| `curlLoggerInterceptor.dart` | Логирование запросов как cURL |
| `extensions/` | Dart-расширения (`.translate()` для локализации и пр.) |

---

## Model/

| Папка / Файл | Модель |
|-------------|--------|
| `ProductModel/Product.dart` | Товар — все поля из API |
| `order/` | Модели заказов, статусов |
| `FAQModel/Faqs_Model.dart` | FAQ запись (`id`, `question`, `answer`, `ansBy`) |
| `CategoryModel/` | Категория |
| `BrandModel/` | Бренд |
| `Attribute Models/` | Атрибуты / наборы / значения |
| `TaxesModel/` | Налоги |
| `ZipCodesModel/` | Индексы |
| `CityModel/` | Города |
| `Country/` | Страны |
| `Customer/` | Данные покупателей |
| `MediaModel/` | Медиафайлы |
| `RattingModel/` | Оценки/отзывы |
| `SalesReportModel/` | Отчёт о продажах |
| `PickUpLocationModel/` | Пункты самовывоза |
| `Person/` | Базовая персона (продавец) |
| `getWithdrawelRequest/` | Запрос на вывод |
| `wafeq/` | Wafeq-накладная |

---

## Provider/ (ChangeNotifier)

| Провайдер | Ответственность |
|-----------|----------------|
| `settingProvider.dart` | Токен, userId (`CUR_USERID`), настройки приложения |
| `loginProvider.dart` | Авторизация продавца |
| `homeProvider.dart` | Статистика дашборда (выручка, заказы, товары) |
| `ProductListProvider.dart` | Список товаров продавца, пагинация, фильтры |
| `addProductProvider.dart` | Многошаговая форма добавления товара |
| `editProductProvider.dart` | Редактирование товара |
| `faqProvider.dart` | Добавление FAQ (`addTagAPI`), редактирование ответа (`editProductFaqAPI`), список |
| `categoryProvider.dart` | Дерево категорий |
| `attributeSetProvider.dart` | Наборы атрибутов |
| `brandProvider.dart` | Бренды |
| `taxProvider.dart` | Налоги |
| `cityProvider.dart` | Города |
| `countryProvider.dart` | Страны |
| `zipcodeProvider.dart` | Индексы |
| `mediaProvider.dart` | Загрузка медиа на сервер |
| `ProfileProvider.dart` | Профиль продавца, обновление данных |
| `reviewListProvider.dart` | Список отзывов |
| `salesReportProvider.dart` | Отчёт о продажах |
| `searchProvider.dart` | Поиск |
| `walletProvider.dart` | Кошелёк / история выводов |
| `stockmanagementProvider.dart` | Управление складом |
| `pickUpLocationProvider.dart` | Список пунктов самовывоза |
| `addPickUpLocationProvider.dart` | Добавление пункта самовывоза |
| `pushNotificationProvider.dart` | FCM-токен |
| `privacyProvider.dart` | Политика конфиденциальности |

---

## Repository/

| Файл | Эндпоинт(ы) |
|------|------------|
| `faqRepositry.dart` | `add_product_faqs`, `get_product_faqs`, `delete_product_faq`, `edit_product_faq` |
| `ordeListRepositry.dart` | `get_orders`, `update_order_item_status` |
| `productListRepositry.dart` | `get_products`, `add_products`, `update_products`, `delete_product` |
| `profileRepositry.dart` | `get_seller_details`, `update_user` |
| `reviewListRepositry.dart` | `get_product_rating` |
| `salesReportRepositry.dart` | `get_sales_list` |
| `mediaRepositry.dart` | `upload_media`, `get_media` |
| `taxRepositry.dart` | `get_taxes` |
| `zipcodeRepositry.dart` | `get_zipcodes` |
| `cityListRepository.dart` | `get_cities` |
| `countryRepositry.dart` | `get_countries_data` |
| `categoryRepositry.dart` | `get_categories_list` |
| `brandRepository.dart` | `get_brands_data` |
| `attributeSetRepositry.dart` | `get_attribute_set`, `get_attributes`, `get_attribute_values` |
| `getWithdrawellRepositry.dart` | `send_withdrawal_request`, `get_withdrawal_request` |
| `pickUpLocationRepository.dart` | `add_pickup_location`, `get_pickup_locations` |
| `deliveryboy_repository.dart` | `get_delivery_boys` |
| `shiprocket_repository.dart` | Shiprocket API |
| `consignment_repository.dart` | Consignment (Shiprocket) |
| `homeRepositry.dart` | `get_statistics` |
| `chatRepository.dart` | Chat API |
| `email_repository.dart` | `send_digital_product_mail` |
| `appSettingsRepository.dart` | `get_settings` |
| `hiveRepository.dart` | Локальное хранилище Hive |
| `wafeq_invoice_repository.dart` | Wafeq e-Invoicing |

---

## cubits/

| Cubit | Назначение |
|-------|-----------|
| `cubits/order/` | Обновление статуса заказа |
| `cubits/deliveryboy/` | Назначение курьера |
| `cubits/mail/` | Отправка email покупателю (цифровой товар) |

---

## Screen/ — Экраны

| Экран | Что делает |
|-------|-----------|
| `SplashScreen/` | Загрузка, проверка токена |
| `Authentication/` | Вход по телефону/email, регистрация продавца (`SellerRegistration.dart`) |
| `DeshBord/` | BottomNavigationBar: главная + заказы + товары + профиль |
| `HomePage/` | Дашборд: выручка, графики (`Charts/`), топ-товары |
| `ProductList/` | Список товаров продавца + кнопки FAQ/редактировать |
| `AddProduct/` | Многошаговая форма (4 шага): данные, атрибуты, изображения, цены |
| `EditProduct/` | То же, что AddProduct, но для редактирования |
| `FAQ/faq.dart` | FAQ для конкретного товара: добавить вопрос+ответ, редактировать ответ |
| `FAQ/widget/getFaQIteams.dart` | Карточка FAQ с кнопками удалить |
| `OrderList/` | Список заказов: фильтрация по статусу |
| `OrderList/consignment/` | Shiprocket consignment |
| `Profile/` | Профиль, банковские данные, документы |
| `ReviewList/` | Отзывы на товары |
| `ReviewPreview/` | Просмотр одного отзыва |
| `ReviewGallery/` | Фото из отзывов |
| `SalesReport/` | Отчёт о продажах |
| `StockManageMentScreen/` | Управление остатками |
| `PickUpLocation/` | Список точек самовывоза |
| `AddPickUpLocation/` | Форма добавления точки |
| `MediaUpload/` | Загрузка медиафайлов |
| `WalletHistory/` | История выводов |
| `Serach/` | Поиск по товарам |
| `Map/` | Карта для выбора точки самовывоза |
| `ProductPreview/` | Предпросмотр товара |
| `groupInfo/` | Информация о группе чата |
| `EmailSend/` | Отправка письма покупателю |
| `TermFeed/` | Условия / политика |

---

## Widget/ (общие)

| Файл | Назначение |
|------|-----------|
| `api.dart` | **Все URI** эндпоинтов (`addProductFaqsApi`, `editProductFaqApi`, `getOrdersApi`, …) |
| `parameterString.dart` | Константы ключей параметров (`ProductId`, `QUESTION`, `ANSWER`, `Id`, …) |
| `security.dart` | `Map<String, String> get headers` → `Bearer $token` |
| `sharedPreferances.dart` | Обёртка SharedPreferences (`getPrefrence`, `setPrefrence`) |
| `snackbar.dart` | `setSnackbar(msg, context)` |
| `routes.dart` | Навигация |
| `appBar.dart` | `GradientAppBar` |
| `bottomsheet.dart` | `CustomBottomSheet` |
| `validation.dart` | Валидаторы форм |
| `networkAvailablity.dart` | Проверка сети |
| `desing.dart` | `DesignConfiguration` (заглушки, лоадеры) |

---

## Ключевой файл: Widget/api.dart

Здесь объявлены **все URI** как `final Uri`:

```dart
final Uri getUserLoginApi      = Uri.parse('${baseUrl}login');
final Uri getOrdersApi         = Uri.parse('${baseUrl}get_orders');
final Uri addProductFaqsApi    = Uri.parse('${baseUrl}add_product_faqs');
final Uri getProductFaqsApi    = Uri.parse('${baseUrl}get_product_faqs');
final Uri deleteProductFaqApi  = Uri.parse('${baseUrl}delete_product_faq');
final Uri editProductFaqApi    = Uri.parse('${baseUrl}edit_product_faq');
// ...и ещё ~50 URI
```

---

## Добавление нового API-вызова (чеклист)

1. Добавить `Uri` в `Widget/api.dart`
2. Добавить метод в нужный `Repository/`
3. Добавить метод в нужный `Provider/`
4. Вызвать из `Screen/` через `context.read<Provider>()`

---

## Order Flow — подробный разбор

### Статусы заказа (`OrderStatus` enum)

Определён в `lib/Repository/ordeListRepositry.dart`:

```
orders → received → processed → assigned → shipped → delivered
                                                    ↓
                                           cancelled / returned / awaiting
```

| Значение enum | `.apiValue` | Смысл |
|---------------|------------|-------|
| `orders` | `null` (не передаётся) | Все заказы |
| `received` | `'received'` | Принят |
| `processed` | `'processed'` | Собран |
| `assigned` | `'assigned'` | Назначен курьер |
| `shipped` | `'shipped'` | В доставке |
| `delivered` | `'delivered'` | Доставлен |
| `cancelled` | `'cancelled'` | Отменён |
| `returned` | `'returned'` | Возврат |
| `awaiting` | `'awaiting'` | Ожидание оплаты |

---

### Навигация по экранам заказов

```
DeshBord (BottomNav)
  └── OrdersScreen  (orders_screen.dart)
        ├── горизонтальный список вкладок-статусов (OrderStatusCardWithCount)
        ├── список OrderCard → тап → OrderDetailsScreen (order_details_screen.dart)
        │     └── вкладки товара → ConsignmentScreen (consignment_screen.dart)
        │           └── тап на отгрузку → ConsignmentDetails (consignment_details.dart)
        │                 ├── StatusUpdateBottomBar   ← выбор статуса + курьера
        │                 └── ShiprocketBottomBar     ← только для Shiprocket-заказов
        └── (pull-to-refresh → _fetchOrders())
```

---

### State management: получение заказов

**Cubit:** `FetchOrdersCubit` (`cubits/order/fetch_orders_cubit.dart`)  
**Repository:** `OrdersRepository` (`Repository/ordeListRepositry.dart`)  
**API:** `POST get_orders` с параметром `active_status`

```
OrdersScreen.initState()
  → _fetchOrders(activeStatus: currentOrderStatus.apiValue)
    → FetchOrdersCubit.fetch(activeStatus: 'processed')
      → OrdersRepository.fetchOrders(activeStatus: 'processed')
        → POST /get_orders {active_status: 'processed', offset: '0', limit: '10'}
          → FetchOrdersSuccess(result, statusData, activeStatus: 'processed')
```

`FetchOrdersSuccess` хранит в себе:
- `result.orders` — список заказов текущей вкладки
- `result.statusData` — счётчики всех вкладок (received: N, processed: N, assigned: N, …)
- `activeStatus` — фильтр, с которым был последний запрос (используется в `refreshOrderList()`)

Смена вкладки → `_fetchOrders()` с новым `activeStatus` → `FetchOrdersCubit.fetch(...)`.

---

### State management: получение отгрузок

**Cubit:** `FetchConsignmentsCubit` (`cubits/order/fetch_consignments_cubit.dart`)  
**Repository:** `ConsignmentRepository` (`Repository/consignment_repository.dart`)  
**API:** `POST get_all_consignments` с `order_id` и `in_detail=1`

Запускается при открытии `ConsignmentScreen`. Хранит список `ConsignmentModel` для конкретного заказа.

---

### State management: обновление статуса отгрузки

**Cubit:** `UpdateConsignmentStatusCubit` (`cubits/order/update_consignment_status_cubit.dart`)  
**Repository:** `ConsignmentRepository.updateStatus()`  
**API:** `POST update_consignment_order_status`

POST-тело:
```
consignment_id: <id>
status:         'assigned'          ← строка, один из статусов выше
deliver_by:     <delivery_boy_id>   ← обязателен при assigned
otp:            ''                  ← обязателен при delivered (если OTP включён)
```

После успеха (`UpdateConsignmentStatusInSuccess`), в `ConsignmentDetails`:
```dart
context.read<FetchConsignmentsCubit>().updateConsignment(state.result);  // обновить объект в памяти
context.read<FetchOrdersCubit>().refreshOrderList();                      // перезапросить список
```

`refreshOrderList()` повторяет fetch с тем же `activeStatus`, что был сохранён в `FetchOrdersSuccess`. Заказ исчезнет из текущей вкладки (если статус изменился), а новая вкладка покажет его при следующем тапе.

---

### State management: обновление статуса обычного заказа (не consignment)

**Repository:** `OrdersRepository.updateDigitalOrderItemStatus()` (для digital)  
**API:** `POST digital_order_status_update` / `update_order_item_status`

---

### Выбор курьера (DeliveryBoy)

В `StatusUpdateBottomBar` (`consignment/widgets/status_update_bottom_bar.dart`):
- Показывает выпадающий список только при `status = 'assigned'`
- `selectedDeliveryBoy` поднимается через `onStatusChanged(status, deliveryBoy)` в `ConsignmentDetails`
- При тапе «Обновить» вызывается `_onTapUpdateStatus()`:
  - Проверяет: если `assigned` и `selectedDeliveryBoy == null` → показать snackbar, не отправлять

---

### Ключевые файлы order flow (чеклист при изменении)

| Файл | Зачем трогать |
|------|--------------|
| `Repository/ordeListRepositry.dart` | `OrderStatus` enum, `fetchOrders()` |
| `Repository/consignment_repository.dart` | `updateStatus()`, `getConsignments()` |
| `cubits/order/fetch_orders_cubit.dart` | Состояние списка заказов, `refreshOrderList()` |
| `cubits/order/update_consignment_status_cubit.dart` | Обновление статуса отгрузки |
| `cubits/order/fetch_consignments_cubit.dart` | Список отгрузок заказа |
| `Screen/OrderList/orders_screen.dart` | Вкладки статусов, список карточек |
| `Screen/OrderList/consignment/consignment_details.dart` | Вся логика кнопки «Обновить статус» |
| `Screen/OrderList/consignment/widgets/status_update_bottom_bar.dart` | UI выбора статуса + курьера |
| `Widget/api.dart` | URI всех эндпоинтов |

---

### Правило: добавление нового статуса

1. Добавить значение в `OrderStatus` enum (`ordeListRepositry.dart`)
2. Добавить `case` в `apiValue` getter того же enum
3. Добавить иконку в `Assets` (`Helper/assetsConstant.dart`) и SVG в `assets/`
4. Добавить счётчик в `fetchOrders()` → `statusData` список (`ordeListRepositry.dart`)
5. **Бэкенд** — добавить `elseif ($_POST['status'] == 'новый_статус')` в **оба** блока уведомлений в `update_consignment_order_status` (строки ~5553 и ~5724 в `Api.php`) и в `update_order_item_status` (строка ~689)
