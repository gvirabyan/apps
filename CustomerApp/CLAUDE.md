eto# CustomerApp — Claude Code Context

## Project
Flutter eShop Multivendor Customer App (Android/iOS).
Backend: PHP on Hostinger — `https://mntom.online/app/v1/api/`

## Architecture
- **State**: Hybrid — Provider (primary, 29 providers) + Cubit/Bloc (12 cubits for chat/settings/search)
- **Data**: Repository pattern (27 repositories) → Dio HTTP client → PHP backend
- **Nav**: Manual Flutter Navigator with `CupertinoPageRoute` via `lib/Helper/routes.dart`
- **Local storage**: Hive + SharedPreferences + SQLite

## Key paths
| What | Where |
|------|-------|
| Screens | `lib/Screen/` |
| Providers | `lib/Provider/` |
| Cubits | `lib/cubits/` |
| Repositories | `lib/repository/` |
| Models | `lib/Model/` |
| API client | `lib/Helper/ApiBaseHelper.dart` |
| Constants / base URL | `lib/Helper/Constant.dart` |
| Routes | `lib/Helper/routes.dart` |
| Assets constants | `lib/Helper/assetsConstant.dart` |
| String helpers | `lib/Helper/String.dart` |
| Localization files | `assets/languages/*.json` (en, ar, de, es, fr, hi, ja, ru, zh) |

## API conventions
- All calls via `ApiBaseHelper` using Dio
- POST with form encoding: `postAPICall(Uri url, Map? param)`
- HTTP 401/103 → force logout; 400 → BadRequest; 403 → Unauthorized; 500 → FetchData
- Timeout: 50s

## Payment gateways integrated
Razorpay, Stripe, Paytm, Paystack, PhonePe, MyFatoorah, COD, PayTabs (in progress)

## Firebase
Auth (Google, Apple, Phone, Email), FCM push notifications, Dynamic links via `app_links`

## Localization
JSON-based, 9 languages, RTL support for Arabic. Keys added to all 9 files when adding strings.

## Backend (PHP)
- **Framework:** CodeIgniter 3.1.13 — local copy at `D:\backendLive`
- **Main API:** `application/controllers/app/v1/Api.php`
- **Payment libs:** `application/libraries/Paytabs.php`, `Stripe.php`, etc.
- **Auth:** JWT Bearer token; public callbacks in `$excluded_routes[]`

## Response preferences
- Terse responses, no trailing summaries
- Reference file paths with line numbers when relevant
- Don't add comments, docstrings, or type annotations to unchanged code
- Don't refactor beyond what's asked
