import 'dart:async';

import 'dart:io';

import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/city.dart';
import 'package:deliveryboy_multivendor/Model/zipcodeModel.dart';
import 'package:deliveryboy_multivendor/Provider/cityListProvider.dart';
import 'package:deliveryboy_multivendor/Repository/AppSettingsRepository.dart';
import 'package:deliveryboy_multivendor/Screens/Authentication/Widget/textFieldContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Helper/color.dart';

import '../../Provider/signupProvider.dart';
import '../../Provider/zipcodeListProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/dashedRect.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/setSnackbar.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import 'LoginScreen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  ScrollController controller = new ScrollController();

  Timer? _debounce;

  bool licenseImageSelected = false;

  List<Zipcode_Model> selectedZipcodeList = [];
  List<City> selectedCities = [];

  FocusNode? nameFocus,
      mobileFocus,
      emailFocus,
      passFocus,
      confirmPassFocus,
      addressFocus,
      licenseFocus;

  List<File> licenseImages = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  bool isShowPass = true;
  bool isShowConfirmPass = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.addListener(_scrollListener);
      if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
        context.read<CityListProvider>().getCities();
      } else {
        context.read<ZipcodeListProvider>().getZipcode();
      }
    });
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.8,
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
  void dispose() {
    buttonController!.dispose();
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  setStateNow() {
    setState(() {});
  }

  _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (mounted) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          context.read<CityListProvider>().getCities(isReload: false);
        } else {
          context.read<ZipcodeListProvider>().getZipcode(isReload: false);
        }
      }
    }
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState!;
    form.save();
    if (form.validate() && licenseImageSelected) {
      return true;
    } else if (!licenseImageSelected) {
      setSnackbar(
          'PLZ_SEL_DRIVING_LICENSE_IMAGES_LBL'.translate(context: context),
          context);
    }
    return false;
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      border: InputBorder.none,
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  void _imgFromGallery() async {
    List<XFile>? pickedFileList = await ImagePicker().pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    licenseImages.clear();
    if (pickedFileList.isNotEmpty) {
      if (pickedFileList.length < 2) {
        setSnackbar('PLZ_ADD_FROND_BACK_IMAGE_MSG'.translate(context: context),
            context);
      } else if (pickedFileList.length > 2) {
        setSnackbar('ADD_ONLY_TWO_IMAGES'.translate(context: context), context);
      } else {
        for (int i = 0; i < pickedFileList.length; i++) {
          licenseImages.add(File(pickedFileList[i].path));
        }

        setState(() {
          licenseImageSelected = true; // At least one image is selected.
        });
      }
    }
  }

  Widget getDrivingLicense() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 110, // Adjust the height according to your needs
              child: uploadOtherImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadOtherImage() {
    return licenseImages.isEmpty
        ? InkWell(
            onTap: () {
              _imgFromGallery();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 110,
                  width: deviceWidth! / 2.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(circularBorderRadius7),
                    color: lightWhite,
                  ),
                  child: DashedRect(
                    gap: 2.0,
                    color: lightBlack.withValues(alpha: 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            DesignConfiguration.setSvgPath(Assets.capa)),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20),
                          child: Text(
                            'FRONT_SIDE_IMAGE_LBL'.translate(context: context),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: lightBlack, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 110,
                  width: deviceWidth! / 2.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(circularBorderRadius7),
                    color: lightWhite,
                  ),
                  child: DashedRect(
                    gap: 2.0,
                    color: lightBlack.withValues(alpha: 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            DesignConfiguration.setSvgPath(Assets.capa)),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20),
                          child: Text(
                            'BACK_SIDE_IMAGE_LBL'.translate(context: context),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: lightBlack, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              _imgFromGallery();
            },
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: licenseImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: index != 0 ? 10 : 0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        licenseImages[index],
                        height: 100.0,
                        fit: BoxFit.fill,
                        width: deviceWidth! / 2.7,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  // getLogo() {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: const EdgeInsets.only(top: 10),
  //     child: SvgPicture.asset(
  //       DesignConfiguration.setNewSvg(Assets.loginLogo),
  //       alignment: Alignment.center,
  //       height: 90,
  //       width: 90,
  //       fit: BoxFit.contain,
  //     ),
  //   );
  // }

  warningMessage() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5),
      child: AppSettingsRepository.appSettings.isCityWiseDeliveribility
          ? selectedCities.isNotEmpty
              ? SizedBox.shrink()
              : Text(
                  'SELECT_CITIES_REQUIRED_LBL'.translate(context: context),
                  style: TextStyle(color: Colors.red, fontSize: 11),
                )
          : selectedZipcodeList.isNotEmpty
              ? SizedBox.shrink()
              : Text(
                  'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT'
                      .translate(context: context),
                  style: TextStyle(color: Colors.red, fontSize: 11),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 10,
          left: 23,
          right: 23,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesignConfiguration.backButton(context),
                Text(
                  'SIGN_UP_LBL'.translate(context: context),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                TextFieldContainer(
                  controller: nameController,
                  focusNode: nameFocus,
                  labelText: 'FULL_NAME_LBL'.translate(context: context),
                  isObscureText: false,
                  icon: Assets.profileInactive,
                  validator: (val) => StringValidation.validateUserName(
                    val,
                    context,
                  ),
                ),
                TextFieldContainer(
                  controller: mobileController,
                  focusNode: mobileFocus,
                  labelText: 'Mobile number'.translate(context: context),
                  isObscureText: false,
                  icon: Assets.mobileNumber,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) =>
                      StringValidation.validateMob(val, context),
                ),
                TextFieldContainer(
                  controller: emailController,
                  focusNode: emailFocus,
                  labelText: 'EMAIL_LBL'.translate(context: context),
                  isObscureText: false,
                  icon: Assets.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      StringValidation.validateEmail(val, context),
                ),
                TextFieldContainer(
                    controller: passwordController,
                    focusNode: passFocus,
                    labelText: 'Password'.translate(context: context),
                    isObscureText: isShowPass,
                    icon: Assets.password,
                    validator: (val) => StringValidation.validatePass(
                        val, context,
                        onlyRequired: false),
                    maxErrorLines: 4,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          isShowPass = !isShowPass;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        child: Icon(
                          !isShowPass
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.black.withValues(alpha: 0.4),
                          size: 22,
                        ),
                      ),
                    )),
                TextFieldContainer(
                    controller: confirmPasswordController,
                    focusNode: confirmPassFocus,
                    labelText: 'Confirm Password'.translate(context: context),
                    isObscureText: isShowConfirmPass,
                    icon: Assets.password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return CON_PASS_REQUIRED_MSG.translate(
                            context: context);
                      }
                      if (value != passwordController.text) {
                        return CON_PASS_NOT_MATCH_MSG.translate(
                            context: context);
                      } else {
                        return null;
                      }
                    },
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          isShowConfirmPass = !isShowConfirmPass;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        child: Icon(
                          !isShowConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black.withValues(alpha: 0.4),
                          size: 22,
                        ),
                      ),
                    )),
                TextFieldContainer(
                    controller: addressController,
                    focusNode: addressFocus,
                    labelText: 'ADDRESS_LBL'.translate(context: context),
                    isObscureText: false,
                    icon: Assets.address),
                setZipcodeOrCityContainer(),
                warningMessage(),
                SizedBox(height: 6),
                getDrivingLicense(),
                SizedBox(height: 5),
                Center(
                  child: AppBtn(
                    title: 'SIGN_UP_LBL'.translate(context: context),
                    btnAnim: buttonSqueezeanimation,
                    btnCntrl: buttonController,
                    onBtnSelected: () async {
                      validateAndSubmit();
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    child: RichText(
                      text: TextSpan(
                          text:
                              '${'ALREADY_HAVE_AN_ACC_TXT'.translate(context: context)} ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                          children: [
                            TextSpan(
                                text: 'Sign in'.translate(context: context),
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.normal)),
                          ]),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context) => Login()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setZipcodeOrCityContainer() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: black.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
            color: lightWhite.withValues(alpha: 0.5)),
        child: ListTile(
          title: AppSettingsRepository.appSettings.isCityWiseDeliveribility
              ? selectedCities.isNotEmpty
                  ? Text(
                      selectedCities.map((e) => e.name).toList().join(', '),
                    )
                  : Text(
                      'SELECT_CITIES_LBL'.translate(context: context),
                      style: TextStyle(
                          fontSize: 13, color: black.withValues(alpha: 0.4)),
                    )
              : selectedZipcodeList.isNotEmpty
                  ? Text(
                      selectedZipcodeList
                          .map((e) => e.zipcode)
                          .toList()
                          .join(', '),
                    )
                  : Text(
                      'SELECT_ZIPCODE_LBL'.translate(context: context),
                      style: TextStyle(
                          fontSize: 13, color: black.withValues(alpha: 0.4)),
                    ),
          trailing: Icon(Icons.chevron_right),
          onTap: () async {
            if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
              final cityProvider =
                  Provider.of<CityListProvider>(context, listen: false);
              if (cityProvider.searchString.isNotEmpty) {
                cityProvider.searchString = "";
                context.read<CityListProvider>().getCities();
              } else if (cityProvider.cityList.isEmpty) {
                context.read<CityListProvider>().getCities();
              }
            } else {
              final zipcodeProvider =
                  Provider.of<ZipcodeListProvider>(context, listen: false);
              if (zipcodeProvider.searchString.isNotEmpty) {
                zipcodeProvider.searchString = "";
                context.read<ZipcodeListProvider>().getZipcode();
              } else if (zipcodeProvider.zipcodeList.isEmpty) {
                context.read<ZipcodeListProvider>().getZipcode();
              }
            }
            await showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  scrollable: true,
                  content: Consumer<CityListProvider>(
                    builder: (context, cityData, child) {
                      return Consumer<ZipcodeListProvider>(
                        builder: (context, data, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppSettingsRepository
                                        .appSettings.isCityWiseDeliveribility
                                    ? 'SELECT_CITIES_LBL'
                                        .translate(context: context)
                                    : 'SELECT_SERVICEABLE_ZIPCODE_LBL'
                                        .translate(context: context),
                                style: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: primary),
                              ),
                              const Divider(color: lightBlack),
                              Flexible(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: SingleChildScrollView(
                                    // physics: AlwaysScrollableScrollPhysics(),
                                    controller: controller,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    circularBorderRadius5)),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: blarColor,
                                                offset: Offset(0, 0),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                            color: white,
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              isDense: true,
                                              fillColor: white,
                                              prefixIconConstraints:
                                                  const BoxConstraints(
                                                minWidth: 40,
                                                maxHeight: 20,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                              hintText: "SEARCH"
                                                  .translate(context: context),
                                              hintStyle: TextStyle(
                                                  color: black.withValues(
                                                      alpha: 0.3),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              if (_debounce?.isActive ?? false)
                                                _debounce?.cancel();
                                              data.searchString = value;
                                              cityData.searchString = value;
                                              //auto search after 1 second of typing
                                              _debounce = Timer(
                                                  const Duration(
                                                      milliseconds: 1000), () {
                                                if (AppSettingsRepository
                                                    .appSettings
                                                    .isCityWiseDeliveribility) {
                                                  context
                                                      .read<CityListProvider>()
                                                      .getCities();
                                                } else {
                                                  context
                                                      .read<
                                                          ZipcodeListProvider>()
                                                      .getZipcode();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        (AppSettingsRepository.appSettings
                                                    .isCityWiseDeliveribility
                                                ? cityData.isLoading
                                                : data.isLoading)
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 50.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  (AppSettingsRepository
                                                              .appSettings
                                                              .isCityWiseDeliveribility
                                                          ? cityData.cityList
                                                              .isNotEmpty
                                                          : data.zipcodeList
                                                              .isNotEmpty)
                                                      ? StatefulBuilder(builder:
                                                          (context, setstater) {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: () {
                                                              if (AppSettingsRepository
                                                                  .appSettings
                                                                  .isCityWiseDeliveribility) {
                                                                return cityData
                                                                    .cityList
                                                                    .asMap()
                                                                    .map((index,
                                                                            element) =>
                                                                        MapEntry(
                                                                            index,
                                                                            CheckboxListTile(
                                                                              title: Text(element.name),
                                                                              value: selectedCities.contains(element),
                                                                              onChanged: (_) {
                                                                                if (selectedCities.contains(element)) {
                                                                                  selectedCities.remove(element);
                                                                                } else {
                                                                                  selectedCities.add(element);
                                                                                }
                                                                                setState(() {});
                                                                                setstater(() {});
                                                                              },
                                                                            )))
                                                                    .values
                                                                    .toList();
                                                              }
                                                              return data
                                                                  .zipcodeList
                                                                  .asMap()
                                                                  .map((index,
                                                                          element) =>
                                                                      MapEntry(
                                                                          index,
                                                                          CheckboxListTile(
                                                                            title:
                                                                                Text(element.zipcode!),
                                                                            value:
                                                                                selectedZipcodeList.contains(element),
                                                                            //value: true,
                                                                            onChanged:
                                                                                (_) {
                                                                              if (selectedZipcodeList.contains(element)) {
                                                                                selectedZipcodeList.remove(element);
                                                                              } else {
                                                                                selectedZipcodeList.add(element);
                                                                              }
                                                                              setState(() {});
                                                                              setstater(() {});
                                                                            },
                                                                          )))
                                                                  .values
                                                                  .toList();
                                                            }(),
                                                          );
                                                        })
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      20.0),
                                                          child: Text(AppSettingsRepository
                                                                  .appSettings
                                                                  .isCityWiseDeliveribility
                                                              ? 'CITY_IS_NOT_AVAIL_LBL'
                                                                  .translate(
                                                                      context:
                                                                          context)
                                                              : 'ZIPCODE_IS_NOT_AVAIL_LBL'
                                                                  .translate(
                                                                      context:
                                                                          context)),
                                                        ),
                                                  DesignConfiguration
                                                      .showCircularProgress(
                                                    AppSettingsRepository
                                                            .appSettings
                                                            .isCityWiseDeliveribility
                                                        ? cityData.isLoadingmore
                                                        : data.isLoadingmore,
                                                    primary,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'DONE'.translate(context: context),
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: primary),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (selectedCities.isNotEmpty || selectedZipcodeList.isNotEmpty) {
        Future.delayed(Duration.zero).then(
          (value) => context
              .read<SignupAuthenticationProvider>()
              .getSignupData(
                  address: addressController.text.trim(),
                  confirmPass: confirmPasswordController.text.trim(),
                  email: emailController.text.trim(),
                  context: context,
                  licenses: licenseImages,
                  mobile: mobileController.text.trim(),
                  name: nameController.text.trim(),
                  password: passwordController.text.trim(),
                  serviceableCities:
                      selectedCities.map((e) => e.id).toList().join(','),
                  zipcodes:
                      selectedZipcodeList.map((e) => e.id).toList().join(','))
              .then(
            (
              value,
            ) async {
              print("value****$value");
              bool error = value["error"];
              String? msg = value["message"];

              await buttonController!.reverse();
              if (!error) {
                setSnackbar(msg!, context);
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              } else {
                setSnackbar(msg!, context);
              }
            },
          ),
        );
      } else {
        await buttonController!.reverse();
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          setSnackbar('SELECT_CITIES_REQUIRED_LBL'.translate(context: context),
              context);
        } else {
          setSnackbar(
              'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT'.translate(context: context),
              context);
        }
      }
    } else {
      Future.delayed(Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          setState(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }
}
