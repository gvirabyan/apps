import 'dart:async';
import 'package:deliveryboy_multivendor/Cubit/loadCountryCodeCubit.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Screens/Authentication/countryCodePickerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Helper/constant.dart';
import '../../Provider/AuthProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/ContainerDesing.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/scrollBehavior.dart';
import '../../Widget/setSnackbar.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import '../Privacy policy/privacy_policy.dart';
import 'verify_otp.dart';

class SendOtp extends StatefulWidget {
  final String? title;

  SendOtp({Key? key, this.title}) : super(key: key);

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, countrycode;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  int? numberLength;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      final String countryCallingCode =
          context.read<CountryCodeCubit>().getSelectedCountryCode();

      countrycode = countryCallingCode;
      Future.delayed(Duration.zero).then(
        (value) => context
            .read<AuthenticationProvider>()
            .getVerifyUser(mobileController.text,
                countryCode: countrycode!,
                isForgotPassword: widget.title ==
                    FORGOT_PASS_TITLE.translate(context: context))
            .then(
          (
            value,
          ) async {
            bool error = value["error"];
            String? msg = value["message"];

            await buttonController!.reverse();
            if (!error) {
              if (widget.title == SEND_OTP_TITLE.translate(context: context)) {
                if (!error) {
                  setSnackbar(msg!, context);
                  Future.delayed(Duration(seconds: 1)).then(
                    (_) {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => VerifyOtp(
                            mobileNumber: mobileController.text,
                            countryCode: countrycode,
                            title: SEND_OTP_TITLE.translate(context: context),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  setSnackbar(msg!, context);
                }
              }
              if (widget.title ==
                  FORGOT_PASS_TITLE.translate(context: context)) {
                if (!error) {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => VerifyOtp(
                        mobileNumber: mobileController.text,
                        countryCode: countrycode,
                        title: FORGOT_PASS_TITLE.translate(context: context),
                      ),
                    ),
                  );
                } else {
                  setSnackbar(msg!, context);
                }
              }
            } else {
              setSnackbar(msg!, context);
            }
          },
        ),
      );
    } else {
      Future.delayed(Duration(seconds: 1)).then(
        (_) async {
          setState(
            () {
              isNetworkAvail = false;
            },
          );
          await buttonController!.reverse();
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
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

  createAccTxt() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.title == SEND_OTP_TITLE.translate(context: context)
              ? CREATE_ACC_LBL.translate(context: context)
              : FORGOT_PASSWORDTITILE.translate(context: context),
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  verifyCodeTxt() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Text(
        SEND_VERIFY_CODE_LBL.translate(context: context),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
              fontFamily: 'ubuntu',
            ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 3,
      ),
    );
  }

  setCodeWithMono() {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: black,
                        ) ??
                    TextStyle(color: black),
              ),
        ),
        child: TextFormField(
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: black, fontWeight: FontWeight.normal),
          controller: mobileController,
          enabled: true,
          decoration: InputDecoration(
            counterStyle: TextStyle(color: black),
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: black, fontWeight: FontWeight.normal),
            hintText: 'MOBILEHINT_LBL'.translate(context: context),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(circularBorderRadius7)),
            fillColor: white,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ((numberLength! < minimumMobileNumberDigit)
                      ? lightWhite
                      : (numberLength! > maximumMobileNumberDigit)
                          ? Colors.red
                          : Theme.of(context).colorScheme.onSurface)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12, bottom: 2),
              child: BlocBuilder<CountryCodeCubit, CountryCodeState>(
                builder:
                    (final BuildContext context, final CountryCodeState state) {
                  var code = '--';
                  var codeflag = "--";

                  print("countrycode status--->${state}");
                  if (state is CountryCodeFetchSuccess) {
                    code = state.selectedCountry!.callingCode;
                    codeflag = state.selectedCountry!.flag;
                  }

                  return InkWell(
                    onTap: () {
                      if (allowOnlySingleCountry) {
                        return;
                      }
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CountryCodePickerScreen(),
                        ),
                      ).then((_) =>
                          context.read<CountryCodeCubit>().fillTemporaryList());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            if (state is CountryCodeFetchSuccess) {
                              return Center(
                                  child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 25,
                                    child: Image.asset(
                                      codeflag,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(code,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: black,
                                        fontSize: 16,
                                      )),
                                ],
                              ));
                            }
                            if (state is CountryCodeFetchFail) {
                              return setSnackbar(state.error, context);
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          onChanged: (number) {
            setState(() {
              numberLength = number.length;
            });
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: black,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  setMono() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: mobileController,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: black, fontWeight: FontWeight.normal),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (val) => StringValidation.validateMob(val, context),
      onSaved: (String? value) {
        context.read<AuthenticationProvider>().setMobileNumber(value);
        mobile = value;
      },
      decoration: InputDecoration(
        hintText: MOBILEHINT_LBL.translate(context: context),
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: black, fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: primary),
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightWhite,
          ),
        ),
      ),
    );
  }

  Widget verifyBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: AppBtn(
          title: widget.title == SEND_OTP_TITLE.translate(context: context)
              ? SEND_OTP.translate(context: context)
              : GET_PASSWORD.translate(context: context),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget termAndPolicyTxt() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 3.0,
        left: 25.0,
        right: 25.0,
        top: 30.0,
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: '    ${CONTINUE_AGREE_LBL.translate(context: context)}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: black,
                  fontWeight: FontWeight.normal,
                ),
            children: [
              TextSpan(
                text: "\n${TERMS_SERVICE_LBL.translate(context: context)}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.normal),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => PrivacyPolicy(
                          title: TERM.translate(context: context),
                        ),
                      ),
                    );
                  },
              ),
              TextSpan(
                text: "  ${AND_LBL.translate(context: context)}  ",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: black, fontWeight: FontWeight.normal),
              ),
              TextSpan(
                  text: PRIVACY.translate(context: context),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => PrivacyPolicy(
                            title: PRIVACY.translate(context: context),
                          ),
                        ),
                      );
                    }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CountryCodeCubit>().loadAllCountryCode(context);
    numberLength = mobileController.text.length;
    buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.8,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      key: _scaffoldKey,
      body: isNetworkAvail
          ? SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 23),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DesignConfiguration.backButton(context),
                        signUpTxt(),
                        verifyCodeTxt(),
                        setCodeWithMono(),
                        verifyBtn(),
                        // termAndPolicyTxt()
                      ],
                    ),
                  ),
                ),
              ),
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Widget getLoginContainer() {
    return Positioned.directional(
      start: MediaQuery.of(context).size.width * 0.025,
      top: MediaQuery.of(context).size.height * 0.2, //original
      textDirection: Directionality.of(context),
      child: ClipPath(
        clipper: ContainerClipper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          color: white,
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      createAccTxt(),
                      verifyCodeTxt(),
                      setCodeWithMono(),
                      verifyBtn(),
                      termAndPolicyTxt(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Text(
        'Forgot Password'.translate(context: context),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize23,
              fontFamily: 'ubuntu',
              letterSpacing: 0.8,
            ),
      ),
    );
  }

  // Widget getLogo() {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: const EdgeInsets.only(top: 60),
  //     child: SvgPicture.asset(
  //       DesignConfiguration.setSvgPath(Assets.loginLogo),
  //       alignment: Alignment.center,
  //       height: 90,
  //       width: 90,
  //       fit: BoxFit.contain,
  //     ),
  //   );
  // }
}
