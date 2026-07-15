import 'dart:async';
import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/routes.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../widgets/security.dart';

class PaytabsWebview extends StatefulWidget {
  final String? url, from, orderId;

  const PaytabsWebview({super.key, this.url, this.from, this.orderId});

  @override
  State<StatefulWidget> createState() => _PaytabsWebviewState();
}

class _PaytabsWebviewState extends State<PaytabsWebview> {
  bool isloading = true;
  late final WebViewController _controller;
  DateTime? currentBackPressTime;
  late UserProvider userProvider;

  @override
  void initState() {
    _initWebView();
    super.initState();
  }

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..loadRequest(Uri.parse(widget.url!))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) async {
          setState(() => isloading = false);
          debugPrint('[PAYTABS] onPageFinished url=$url');

          if (url.contains('paytabs_payment_response')) {
            // Backend returns raw JSON — read it via JS
            try {
              final raw = await _controller.runJavaScriptReturningResult(
                'document.body.innerText',
              );
              // runJavaScriptReturningResult wraps strings in quotes
              final rawStr = raw.toString();
              debugPrint('[PAYTABS] raw body=$rawStr');
              final jsonStr = rawStr.startsWith('"') && rawStr.endsWith('"')
                  ? rawStr.substring(1, rawStr.length - 1).replaceAll(r'\"', '"')
                  : rawStr;
              final data = jsonDecode(jsonStr);
              final status = data['status']?.toString() ?? '';
              final tranRef = data['transaction_id']?.toString() ?? '';
              debugPrint('[PAYTABS] status=$status tranRef=$tranRef');
              if (status == 'successful') {
                _handleSuccess(tranRef);
              } else {
                _handleFailure();
              }
            } catch (e) {
              debugPrint('[PAYTABS] exception=$e');
              _handleFailure();
            }
          }
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('[PAYTABS] webResourceError=${error.description}');
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  void _handleSuccess(String url) {
    String tranId = '';
    try {
      final uri = Uri.parse(url);
      tranId = uri.queryParameters['tran_ref'] ??
          uri.queryParameters['transaction_id'] ??
          widget.orderId ??
          '';
    } catch (_) {
      tranId = widget.orderId ?? '';
    }

    if (widget.from == 'order') {
      addTransaction(
        tranId,
        widget.orderId!,
        SUCCESS,
        'Order placed successfully',
        true,
      );
      userProvider.setCartCount('0');
    } else if (widget.from == 'wallet') {
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context, 'true');
      });
    }
  }

  void _handleFailure() {
    if (widget.from == 'order' && widget.orderId != null) {
      deleteOrder();
    }
    Timer(const Duration(seconds: 1), () {
      Routes.pop(context);
    });
  }

  Future<void> deleteOrder() async {
    try {
      await post(
        deleteOrderApi,
        body: {ORDER_ID: widget.orderId},
        headers: headers,
      ).timeout(const Duration(seconds: timeOut));
    } on TimeoutException catch (_) {
      if (mounted) {
        setSnackbar('somethingMSg'.translate(context: context), context);
      }
    }
  }

  Future<void> addTransaction(
    String tranId,
    String orderID,
    String status,
    String? msg,
    bool redirect,
  ) async {
    try {
      var parameter = {
        ORDER_ID: orderID,
        TYPE: context.read<CartProvider>().payMethod,
        TXNID: tranId,
        AMOUNT: context.read<CartProvider>().totalPrice.toString(),
        STATUS: status,
        MSG: msg,
      };

      Response response =
          await post(addTransactionApi, body: parameter, headers: headers)
              .timeout(const Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      bool error = getdata['error'];
      String? msg1 = getdata['message'];

      if (!error) {
        if (redirect && mounted) {
          userProvider.setCartCount('0');
          context.read<CartProvider>().totalPrice = 0;
          context.read<CartProvider>().oriPrice = 0;
          context.read<CartProvider>().taxPer = 0;
          context.read<CartProvider>().deliveryCharge = 0;
          context.read<CartProvider>().addressList.clear();
          context.read<CartProvider>().setCartlist([]);
          context.read<CartProvider>().setProgress(false);
          context.read<CartProvider>().promoAmt = 0;
          context.read<CartProvider>().remWalBal = 0;
          context.read<CartProvider>().usedBalance = 0;
          context.read<CartProvider>().payMethod = null;
          context.read<CartProvider>().isPromoValid = false;
          context.read<CartProvider>().isUseWallet = false;
          context.read<CartProvider>().isPayLayShow = true;
          context.read<CartProvider>().selectedMethod = null;
          context.read<CartProvider>().deliverable = false;
          context.read<CartProvider>().codDeliverChargesOfShipRocket = 0.0;
          context.read<CartProvider>().prePaidDeliverChargesOfShipRocket = 0.0;
          context.read<CartProvider>().isLocalDelCharge = null;
          context.read<CartProvider>().isShippingDeliveryChargeApplied = false;
          context.read<CartProvider>().shipRocketDeliverableDate = '';
          context.read<CartProvider>().isAddressChange = null;
          context.read<CartProvider>().noteController.clear();
          context.read<CartProvider>().promoC.clear();
          context.read<CartProvider>().promocode = null;
          Routes.navigateToOrderSuccessScreen(context);
        }
      } else {
        if (mounted) setSnackbar(msg1!, context);
      }
    } on TimeoutException catch (_) {
      if (mounted) {
        setSnackbar('somethingMSg'.translate(context: context), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: 0,
        leading: Builder(builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  DateTime now = DateTime.now();
                  if (currentBackPressTime == null ||
                      now.difference(currentBackPressTime!) >
                          const Duration(seconds: 2)) {
                    currentBackPressTime = now;
                    setSnackbar(
                      "Don't press back while doing payment!\n ${'EXIT_WR'.translate(context: context)}",
                      context,
                    );
                  } else {
                    if (widget.from == 'order' && widget.orderId != null) {
                      deleteOrder();
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Center(
                  child: Icon(Icons.keyboard_arrow_left, color: colors.primary),
                ),
              ),
            ),
          );
        }),
        title: Text(
          appName,
          style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            setSnackbar(
              "${"Don't press back while doing payment!".translate(context: context)}\n ${'EXIT_WR'.translate(context: context)}",
              context,
            );
          } else {
            if (widget.from == 'order' && widget.orderId != null) {
              deleteOrder();
            }
            if (!didPop) Navigator.pop(context, 'true');
          }
        },
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isloading)
              const Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
