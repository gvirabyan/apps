# Customer App — Structure Guide

**App name:** Mntom  
**Package:** `com.turki.mntom`  
**API base:** `https://mntom.online/app/v1/api/`  
**Chat API:** `https://mntom.online/app/v1/Chat_Api/`  
**Framework:** Flutter · State: Provider (primary) + Cubit/Bloc

---

## lib/ — Top-level layout

```
lib/
├── appConstants.dart        ← единственный файл с baseUrl, packageName, appName
├── main.dart
├── Helper/                  ← утилиты, константы, роутинг
├── Model/                   ← data-классы (fromJson/toJson)
├── Provider/                ← ChangeNotifier провайдеры (бизнес-логика + состояние UI)
├── repository/              ← HTTP-запросы через ApiBaseHelper
├── Screen/                  ← все экраны + их Widget/ подпапки
├── cubits/                  ← Cubit/Bloc (чат, настройки, поиск)
└── widgets/                 ← переиспользуемые общие виджеты
```

---

## Helper/

| Файл | Что внутри |
|------|------------|
| `Constant.dart` | Импортирует из `appConstants.dart`; глобальные переменные (`deviceWidth`, `headers`, etc.) |
| `String.dart` | Все строковые константы для ключей API-параметров (`ORDERID`, `STATUS`, `RETURN_REASON`, …) и URI (`addProductFaqsApi`, `updateOrderItemApi`, …) |
| `ApiBaseHelper.dart` | Dio-клиент: `postAPICall(Uri, Map)` — все POST-запросы к бэкенду |
| `routes.dart` | Навигация: `Routes.navigateTo*` — CupertinoPageRoute-переходы |
| `Color.dart` | Цветовая схема, расширения `ColorScheme` |
| `assetsConstant.dart` | Пути к локальным ассетам (картинки, анимации) |
| `sessionManager.dart` | SharedPreferences: токен, userId, имя и пр. |
| `curlLoggerInterceptor.dart` | Логирует каждый запрос как cURL команду |

---

## Model/

| Файл | Модель |
|------|--------|
| `Model.dart` | `Product`, `Variant`, `ProductImage`, категории, `Category` |
| `Order_Model.dart` | `OrderItem` — поля статуса, `returnRequestRemark`, etc. |
| `Section_Model.dart` | `Section` + вложенные продукты для главной страницы |
| `User.dart` | `UserModel` — профиль пользователя |
| `Faqs_Model.dart` | `FaqModel` — вопрос/ответ |
| `Transaction_Model.dart` | Транзакции кошелька |
| `Notification_Model.dart` | FCM-уведомление |
| `appSettingsModel.dart` | Настройки магазина с бэкенда |
| `appLanguageModel.dart` | Локализация |
| `brandModel.dart` | Бренд |
| `predefinedReturnReasonModel.dart` | Предустановленные причины возврата |
| `message.dart`, `groupDetails.dart`, `personalChatHistory.dart` | Чат |
| `getWithdrawelRequest/` | Модель запроса на вывод средств |

---

## Provider/ (ChangeNotifier)

### Основные
| Провайдер | Ответственность |
|-----------|----------------|
| `SettingProvider.dart` | Настройки приложения, токен, userId, язык, тема |
| `UserProvider.dart` | Профиль пользователя, обновление |
| `CartProvider.dart` | Корзина: добавить/удалить/очистить |
| `ProductProvider.dart` | Список продуктов, фильтры, пагинация |
| `productDetailProvider.dart` | Детали товара, варианты, FAQ-форма |
| `homePageProvider.dart` | Данные главной страницы (секции, слайдер) |
| `CategoryProvider.dart` | Дерево категорий |
| `authenticationProvider.dart` | Вход/регистрация/OTP |
| `paymentProvider.dart` | Оплата заказа, обработка шлюзов |
| `addressProvider.dart` | Адреса доставки |
| `ManageAddressProvider.dart` | CRUD адресов |

### Заказы
| Провайдер | Ответственность |
|-----------|----------------|
| `Order/UpdateOrderProvider.dart` | Отмена/возврат товара (`cancelOrder()`), мультипарт запрос с файлами |

### Прочие
| Провайдер | Ответственность |
|-----------|----------------|
| `faqProvider.dart` | Отправка вопроса покупателя к продавцу |
| `FaqsProvider.dart` | Список FAQ магазина |
| `ReviewGallleryProvider.dart` | Галерея отзывов |
| `promoCodeProvider.dart` | Промо-коды |
| `myWalletProvider.dart` | Кошелёк |
| `notificationProvider.dart` (через `NotificationProvider.dart`) | Уведомления |
| `sellerDetailProvider.dart` | Страница продавца |
| `systemProvider.dart` | Системные настройки (интернет, тема) |
| `chatProvider.dart` | Чат с продавцом |
| `customerSupportProvider.dart` | Тикеты поддержки |
| `explore_provider.dart` | ExploreSection |
| `writeReviewProvider.dart` | Написание отзыва |
| `pushNotificationProvider.dart` | Подписка на пуши |

---

## repository/

Каждый файл = один вызов или группа вызовов к бэкенду через `ApiBaseHelper`.

| Файл | API-методы |
|------|------------|
| `authRepository.dart` | login, register, verify OTP |
| `userRepository.dart` | update_user, delete_user |
| `homeRepository.dart` | get_sections, get_slider_images |
| `productListRespository.dart` | get_products, get_categories |
| `cartRepository.dart` | manage_cart, get_user_cart, clear_cart |
| `Order/UpdateOrderRepository.dart` | update_order_item_status, download_link_hash |
| `addressRepositry.dart` | add/update/delete/get address |
| `faqRepository.dart` | add_product_faqs (покупатель задаёт вопрос) |
| `faqsRepository.dart` | get_faqs (FAQ магазина) |
| `paymentMethodRepository.dart` | Stripe, Razorpay, Paytabs и пр. |
| `chatRepository.dart` | send_message, get_messages |
| `predefinedReturnReasonRepository.dart` | get_predefined_reasons |
| `promoCodeRepository.dart` | validate_promo_code |
| `hiveRepository.dart` | локальное хранилище Hive |

---

## cubits/

| Cubit | Назначение |
|-------|-----------|
| `appSettingsCubit.dart` | Загрузка настроек при старте |
| `languageCubit.dart` | Смена языка |
| `personalConverstationsCubit.dart` | Личный чат |
| `converstationCubit.dart` | Групповой чат |
| `sendMessageCubit.dart` | Отправка сообщения |
| `readMessagesCubit.dart` | Прочитать сообщения |
| `makeMeOnlineCubit.dart` | Онлайн-статус в чате |
| `searchSellerCubit.dart` | Поиск продавца |
| `brandsListCubit.dart` | Список брендов |
| `downloadFileCubit.dart` | Скачивание цифровых товаров |
| `predefinesReturnReasonCubit.dart` | Причины возврата |
| `loadCountryCodeCubit.dart` | Коды стран |

---

## Screen/ — Экраны

| Экран | Файл входа | Что делает |
|-------|-----------|-----------|
| `SplashScreen/` | `SplashScreen.dart` | Загрузка, редирект на Login или Home |
| `IntroSlider/` | `IntroSlider.dart` | Онбординг |
| `Auth/` | `Login.dart`, `SignUp.dart`, `Verify_Otp.dart` | Авторизация (телефон/email/соцсети) |
| `Dashboard/` | `Dashboard.dart` | BottomNavigationBar — обёртка главных табов |
| `homePage/` | `homePage.dart` | Главная: секции, слайдер, категории |
| `AllCategory/` | — | Все категории |
| `SubCategory/` | — | Подкатегории |
| `ProductList&SectionView/` | — | Список товаров + секция |
| `Product_Detail/` | `productDetail.dart` | Детали товара, варианты, FAQ, отзывы, чат с продавцом |
| `Product_Detail/Widget/postFaq.dart` | — | Кнопка «Post Your Question» → отправка вопроса продавцу |
| `FAQsProduct/` | — | Список FAQ товара (просмотр) |
| `FAQsList/` | — | Общие FAQ магазина |
| `Cart/` | `Cart.dart` | Корзина |
| `Payment/` | `Payment.dart` | Выбор адреса, промокод, оплата |
| `OrderSuccess/` | — | Экран успешного заказа |
| `MyOrder/` | — | Список заказов |
| `OrderDetail/` | `orderDetail.dart` | Детали заказа |
| `OrderDetail/Widget/ProductItemdata.dart` | — | **Кнопка возврата** (`submitReturnReasonButton`) |
| `OrderDetail/Widget/OrderStatusData.dart` | — | Таймлайн статусов + статус возврата |
| `AddAddress/` | — | Форма добавления адреса |
| `Manage_Address/` | — | Список адресов |
| `Map/` | — | Выбор адреса на карте |
| `Favourite/` | — | Избранное |
| `Search/` | — | Поиск товаров |
| `SellerDetail/` | — | Страница продавца |
| `Profile/` | — | Профиль пользователя |
| `Transaction/` | — | История транзакций |
| `My_Wallet/` | — | Кошелёк |
| `PromoCode/` | — | Применение промо-кода |
| `ReferAndEarn/` | — | Реферальная программа |
| `WriteReview/` | — | Написать отзыв |
| `ReviewPreview/` | — | Просмотр отзыва |
| `ReviewGallary/` | — | Галерея фото из отзывов |
| `Notification/` | — | Push-уведомления |
| `Chat/` + `converstationScreen.dart` | — | Чат покупатель ↔ продавец |
| `CustomerSupport/` | — | Тикеты поддержки |
| `Language/` | — | Смена языка |
| `PrivacyPolicy/` | — | Политика конфиденциальности |
| `WebView/` | — | Встроенный браузер (оплата и пр.) |
| `ExploreSection/` | — | Исследование секций |
| `CompareList/` | — | Сравнение товаров |
| `ProductPreview/` | — | Предпросмотр товара |
| `VimeoPlayer/` | — | Видео Vimeo |
| `SQLiteData/` | — | Просмотр локальной БД (дебаг) |

---

## widgets/ (общие)

`ButtonDesing.dart`, `GridViewProduct.dart`, `ListViewProdusct.dart`, `appBar.dart`, `snackbar.dart`, `simmerEffect.dart`, `networkAvailablity.dart`, `security.dart` (заголовки авторизации)

---

## Ключевые связи при добавлении фичи

```
Экран (Screen/) 
  → читает/меняет Provider (context.read / Consumer)
      → вызывает Repository
          → ApiBaseHelper.postAPICall(Uri, Map)
              → PHP бэкенд /app/v1/api/{endpoint}
```

Ответ: `{ "error": bool, "message": string, "data": [...] }`

---

## Платёжные шлюзы

| Шлюз | Где настраивается |
|------|------------------|
| Stripe | `paymentProvider.dart` + `StripeService/` |
| Razorpay | `paymentProvider.dart` |
| Paytabs | WebView → `paytabs_webview` |
| PhonePe | `phonepe_app` |
| MyFatoorah | `my_fatoorah_payment_intent` |
| Paystack | `paystack_webhook` |
| Paytm | `generate_paytm_txn_token` |
| COD | локально |

---

## Локализация

`assets/languages/*.json` — 9 языков: `en`, `ar`, `de`, `es`, `fr`, `hi`, `ja`, `ru`, `zh`.  
Использование: `'KEY'.translate(context: context)`  
RTL: арабский поддерживается.
