import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Constant.dart';
import '../../Provider/privacyProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';

class Policy extends StatefulWidget {
  final String? title;

  const Policy({
    super.key,
    this.title,
  });
  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
//==============================================================================
//============================= Variables Declaration ==========================

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String? contactUs;
  String? termCondition;
  String? privacyPolicy;
  String? returnPolicy;
  String? shippingPolicy;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

//==============================================================================
//============================= initState Method ===============================

  @override
  void initState() {
    super.initState();
    getSystemPolicy();
  }

  @override
  void dispose() {
    if (buttonController != null) {
      buttonController!.dispose();
    }
    super.dispose();
  }

  Future<void> getSystemPolicy() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      String type = '';
      if (widget.title == 'PRIVACYPOLICY'.translate(context: context)) {
        type = "privacy_policy";
      } else if (widget.title ==
          'TERM_CONDITIONS'.translate(context: context)) {
        type = "terms_conditions";
      } else if (widget.title == 'CONTACTUS'.translate(context: context)) {
        type = "contact_us";
      } else if (widget.title ==
          'Shipping Policy'.translate(context: context)) {
        type = "shipping_policy";
      } else if (widget.title == 'Return Policy'.translate(context: context)) {
        type = "return_policy";
      } else {
        Future.delayed(const Duration(seconds: 2)).then(
          (_) async {
            setState(() {
              isNetworkAvail = false;
            });
            await buttonController!.reverse();
          },
        );
      }

      await Future.delayed(Duration.zero);
      await context.read<SystemProvider>().getSystemPolicies(type);
    }
  }
//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GradientAppBar(
        widget.title!,
      ),
      body: isNetworkAvail
          ? Consumer<SystemProvider>(
              builder: (context, value, child) {
                if (value.getCurrentStatus ==
                    SystemProviderPolicyStatus.isSuccsess) {
                  if (value.policy.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: HtmlWidget(
                              value.policy,
                              onErrorBuilder: (context, element, error) =>
                                  Text('$element error: $error'),
                              onLoadingBuilder:
                                  (context, element, loadingProgress) =>
                                      const CircularProgressIndicator(),

                              onTapUrl: (url) {
                                launchUrl(Uri.parse(url));
                                return true;
                              },

                              renderMode: RenderMode.column,

                              // set the default styling for text
                              textStyle:
                                  const TextStyle(fontSize: textFontSize14),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Center(
                      child: Text('No Data Found'.translate(context: context)),
                    );
                  }
                } else if (value.getCurrentStatus ==
                    SystemProviderPolicyStatus.isFailure) {
                  return Center(
                    child: Text('Something went wrong:- ${value.errorMessage}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }
}
