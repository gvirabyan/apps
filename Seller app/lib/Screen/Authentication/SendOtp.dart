import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/Authentication/countryCodePickerScreen.dart';
import 'package:sellermultivendor/cubits/loadCountryCodeCubit.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';
import '../../Provider/privacyProvider.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import '../TermFeed/policys.dart';
import 'VerifyOTP.dart';

class SendOtp extends StatefulWidget {
  final String? title;

  const SendOtp({super.key, this.title});

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, countrycode;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  int? numberLength;

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      final String countryCallingCode =
          context.read<CountryCodeCubit>().getSelectedCountryCode();

      countrycode = countryCallingCode;
      getVerifyUser();
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

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(color: fontColor),
        ),
        backgroundColor: lightWhite,
        elevation: 1.0,
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

  Future<void> getVerifyUser() async {
    var data = {
      Mobile: mobileController.text.replaceAll(' ', ''),
      'country_code': countrycode,
      "is_forgot_password":
          widget.title == "FORGOT_PASS_TITLE".translate(context: context)
              ? "1"
              : "0"
    };
    apiBaseHelper.postAPICall(verifyUserApi, data).then(
      (getdata) async {
        bool error = getdata["error"];

        String? msg = getdata["message"];
        await buttonController!.reverse();
        if (widget.title == "SEND_OTP_TITLE".translate(context: context)) {
          if (!error) {
            print("-------$msg");
            setSnackbar(msg!);

            setPrefrence(Mobile, mobileController.text);
            setPrefrence(COUNTRY_CODE, countrycode!);
            Future.delayed(const Duration(seconds: 1)).then(
              (_) {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => VerifyOtp(
                      mobileNumber: mobileController.text,
                      countryCode: countrycode,
                      title: "SEND_OTP_TITLE".translate(context: context),
                    ),
                  ),
                );
              },
            );
          } else {
            setSnackbar(msg!);
          }
        }
        if (widget.title == "FORGOT_PASS_TITLE".translate(context: context)) {
          if (!error) {
            setSnackbar(msg!);
            setPrefrence(Mobile, mobileController.text);
            setPrefrence(COUNTRY_CODE, countrycode!);

            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => VerifyOtp(
                  mobileNumber: mobileController.text,
                  countryCode: countrycode,
                  title: "FORGOT_PASS_TITLE".translate(context: context),
                ),
              ),
            );
          } else {
            setSnackbar(msg!);
          }
        }
      },
      onError: (error) async {
        await buttonController!.reverse();
      },
    );
  }

  verifyCodeTxt() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Text(
        'SEND_VERIFY_CODE_LBL'.translate(context: context),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black,
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
                    const TextStyle(color: black),
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
            counterStyle: const TextStyle(color: black),
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

                  print("countrycode status--->$state");
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
                          builder: (context) => const CountryCodePickerScreen(),
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: black,
                                        fontSize: 16,
                                      )),
                                ],
                              ));
                            }
                            if (state is CountryCodeFetchFail) {
                              return setSnackbar(
                                state.error,
                              );
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

  setContryCode() {
    return IntlPhoneField(
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: black, fontWeight: FontWeight.normal),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      dropdownIconPosition: IconPosition.trailing,
      showCountryFlag: true,
      pickerDialogStyle: PickerDialogStyle(),
      initialCountryCode: AppSettingsRepository.appSettings.defaultCountryCode,
      controller: mobileController,
      onTap: () {},
      onSaved: (phoneNumber) {
        print("phone number2222****${phoneNumber!.countryCode}");
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        alignLabelWithHint: true,
        fillColor: lightWhite,
        filled: true,
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: black, fontWeight: FontWeight.normal),
        hintText: 'MOBILEHINT_LBL'.translate(context: context),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (phone) {
        print(
            "phone***${phone.countryCode}****${phone.number}****${phone.completeNumber}***${phone.countryISOCode}");
        print(phone.completeNumber);
      },
      onCountryChanged: (country) {
        print('Country changed to: ${country.name}');
      },
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
      validator: (val) => StringValidation.validateMob(val!, context),
      onSaved: (String? value) {
        mobile = value;
      },
      decoration: InputDecoration(
        hintText: 'MOBILEHINT_LBL'.translate(context: context),
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: black, fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: primary),
          borderRadius: BorderRadius.circular(circularBorderRadius7),
        ),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightWhite,
          ),
        ),
      ),
    );
  }

  verifyBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: AppBtn(
          title: widget.title == "SEND_OTP_TITLE".translate(context: context)
              ? "Send OTP".translate(context: context)
              : "GET_PASSWORD".translate(context: context),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  termAndPolicyTxt() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 3.0,
        left: 25.0,
        right: 25.0,
        top: 40.0,
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: '    ${"CONTINUE_AGREE_LBL".translate(context: context)}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: black,
                  fontWeight: FontWeight.normal,
                ),
            children: [
              TextSpan(
                text: "\n${'TERMS_SERVICE_LBL'.translate(context: context)}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.normal),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<SystemProvider>(
                          create: (context) => SystemProvider(),
                          child: Policy(
                            title:
                                "TERM_CONDITIONS".translate(context: context),
                          ),
                        ),
                      ),
                    );
                  },
              ),
              TextSpan(
                text: "  ${'AND_LBL'.translate(context: context)}  ",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: black, fontWeight: FontWeight.normal),
              ),
              TextSpan(
                  text: "PRIVACYPOLICY".translate(context: context),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<SystemProvider>(
                            create: (context) => SystemProvider(),
                            child: Policy(
                              title:
                                  "PRIVACYPOLICY".translate(context: context),
                            ),
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
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                        // getLogo(),
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

  Widget verifyCodeTxt1() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "SEND_VERIFY_CODE_LBL".translate(context: context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 1,
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
        widget.title == 'SEND_OTP_TITLE'.translate(context: context)
            ? 'SIGN_UP_LBL'.translate(context: context)
            : 'FORGOT_PASSWORDTITILE'.translate(context: context),
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
}
