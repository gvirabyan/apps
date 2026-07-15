import 'dart:async';
import 'dart:io';
import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Provider/UserProvider.dart';
import 'package:deliveryboy_multivendor/Widget/ButtonDesing.dart';
import 'package:deliveryboy_multivendor/Widget/bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Helper/constant.dart';
import '../../Provider/SettingsProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/dashedRect.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/setSnackbar.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateProfile();
}

String? lat, long;

class StateProfile extends State<Profile> with TickerProviderStateMixin {
  String? name, email, mobile, curPass, newPass, confPass;

  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _passKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final mobileC = TextEditingController();
  final curPassC = TextEditingController();
  final newPassC = TextEditingController();
  final confPassC = TextEditingController();
  bool _showCurPassword = true, _showPassword = true, _showCmPassword = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  SettingProvider? settingProvider;
  List<File> licenseImages = [];
  List<String> licenseGetImages = [];
  FocusNode? nameFocus,
      mobileFocus,
      currPassFocus,
      newPassFocusC,
      newConfFocusC;

  @override
  void initState() {
    super.initState();
    settingProvider = Provider.of<SettingProvider>(context, listen: false);

    getUserDetails();

    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    mobileC.dispose();
    nameC.dispose();
    newPassC.dispose();
    curPassC.dispose();
    confPassC.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  getUserDetails() async {
    CUR_USERID = await settingProvider!.getPrefrence(ID);
    mobile = await settingProvider!.getPrefrence(MOBILE);
    name = await settingProvider!.getPrefrence(USERNAME);

    email = await settingProvider!.getPrefrence(EMAIL);
    mobileC.text = mobile!;
    nameC.text = name!;
    licenseGetImages =
        await settingProvider!.getListPrefrence(DRIVING_LICENSE) ?? [];
    setState(
      () {},
    );
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) => context
            .read<UserProvider>()
            .updateUserProfile(
                username: nameC.text.trim(),
                userEmail: email,
                licenses: licenseImages,
                newPassword: newPass != null && newPass != ""
                    ? newPassC.text.trim()
                    : null,
                oldPassword: curPass != null && curPass != ""
                    ? curPassC.text.trim()
                    : null)
            .then(
          (
            value,
          ) async {
            bool error = value["error"];
            String? msg = value["message"];
            await buttonController!.reverse();
            if (!error) {
              setSnackbar(msg!, context);
              CUR_USERNAME = name;
              await settingProvider!.saveUserDetail(
                  value[TOKEN], CUR_USERID!, name!, email!, mobile!, context);
              CUR_DRIVING_LICENSE = value['driving_license'];
              settingProvider!
                  .setListPrefrence(DRIVING_LICENSE, CUR_DRIVING_LICENSE);

              curPassC.text = '';
              newPassC.text = '';
              confPassC.text = '';
            } else {
              setSnackbar(msg!, context);
            }
          },
        ),
      );
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  changePass() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 50,
        width: deviceWidth,
        child: Card(
          color: black.withValues(alpha: 0.8),
          elevation: 0,
          child: InkWell(
            child: Center(
              child: Text(
                CHANGE_PASS_LBL.translate(context: context),
                style: Theme.of(this.context).textTheme.titleMedium!.copyWith(
                      color: white,
                    ),
              ),
            ),
            onTap: () {
              _showBottomSheet();
            },
          ),
        ),
      ),
    );
  }

  _showBottomSheet() async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                  start: 10,
                  end: 10),
              child: Form(
                key: _passKey,
                child: Column(
                  children: [
                    CustomBottomSheet.bottomSheetHandle(context),
                    CustomBottomSheet.bottomSheetLabel(
                      context,
                      CHANGE_PASS_LBL.translate(context: context),
                    ),
                    Divider(),
                    buildTextField(
                      curPassC,
                      currPassFocus,
                      CUR_PASS_LBL.translate(context: context),
                      _showCurPassword,
                      Assets.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showCurPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 20,
                        color: lightBlack,
                        onPressed: () {
                          setStater(
                            () {
                              _showCurPassword = !_showCurPassword;
                            },
                          );
                        },
                      ),
                      onchanged: (v) => setState(
                        () {
                          curPass = v;
                        },
                      ),
                    ),
                    buildTextField(
                      newPassC,
                      newPassFocusC,
                      NEW_PASS_LBL.translate(context: context),
                      _showPassword,
                      Assets.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 20,
                        color: lightBlack,
                        onPressed: () {
                          setStater(
                            () {
                              _showPassword = !_showPassword;
                            },
                          );
                        },
                      ),
                      onchanged: (v) => setState(
                        () {
                          newPass = v;
                        },
                      ),
                    ),
                    buildTextField(
                      confPassC,
                      newConfFocusC,
                      CONFIRMPASSHINT_LBL.translate(context: context),
                      _showCmPassword,
                      Assets.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 20,
                        color: lightBlack,
                        onPressed: () {
                          setStater(
                            () {
                              _showCmPassword = !_showCmPassword;
                            },
                          );
                        },
                      ),
                      onchanged: (v) => setState(
                        () {
                          confPass = v;
                        },
                      ),
                    ),
                    AppBtn(
                      title: 'Save'.translate(context: context),
                      btnAnim: buttonSqueezeanimation,
                      btnCntrl: buttonController,
                      onBtnSelected: () async {
                        final form = _passKey.currentState!;
                        if (form.validate()) {
                          form.save();
                          setState(
                            () {
                              Navigator.pop(context);
                              if (newPass != confPass) {
                                setSnackbar(
                                  CON_PASS_NOT_MATCH_MSG.translate(
                                      context: context),
                                  context,
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: Platform.isIOS
                          ? EdgeInsets.only(bottom: 50)
                          : EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 10),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
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
        licenseGetImages.clear();
        for (int i = 0; i < pickedFileList.length; i++) {
          licenseImages.add(File(pickedFileList[i].path));
        }
        // await setDrivingLicense(licenseImages);

        setState(() {});
      }
    }
  }

  Widget getDrivingLicense() {
    print("license get images*****${licenseGetImages.length}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15.0),
                SizedBox(
                  height: 110, // Adjust the height according to your needs
                  child: licenseGetImages.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: licenseGetImages.length,
                          itemBuilder: (context, index) {
                            // Build your list item widgets here
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: index != 0 ? 25 : 0),
                              child: InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FadeInImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 150),
                                      image:
                                          NetworkImage(licenseGetImages[index]),
                                      height: 100.0,
                                      fit: BoxFit.fill,
                                      width: deviceWidth! / 2.7,
                                      placeholder:
                                          DesignConfiguration.placeHolder(90),
                                      imageErrorBuilder:
                                          ((context, error, stackTrace) {
                                        return Image.asset(
                                          DesignConfiguration.setPngPath(
                                              Assets.placeholder),
                                          height: 90,
                                          width: 90,
                                        );
                                      }),
                                      placeholderErrorBuilder:
                                          ((context, error, stackTrace) {
                                        return Image.asset(
                                          DesignConfiguration.setPngPath(
                                              Assets.placeholder),
                                          height: 90,
                                          width: 90,
                                        );
                                      })),
                                ),
                                onTap: () {
                                  _imgFromGallery();
                                },
                              ),
                            ); // Widget for each list item
                          },
                        )
                      : uploadOtherImage(),
                ),
              ],
            ),
          ),
        ],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          start: index != 0 ? 10 : 0),
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
                )),
          );
  }

  profileImage() {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 30.0,
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: primary,
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(circularBorderRadius100),
            border: Border.all(color: primary),
          ),
          child: Icon(Icons.account_circle, size: 100),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController? controller, FocusNode? focusNode,
      String? labelText, bool isObscureText, String icon,
      {TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      Widget? suffixIcon,
      bool? isEnabled,
      Function(String)? onchanged,
      String? Function(String?)? validator,
      int? maxErrorLines}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: isObscureText,
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setSvgPath(icon),
              fit: BoxFit.scaleDown,
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
            hintText: labelText,
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withValues(alpha: 0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            errorMaxLines: maxErrorLines,
            suffixIcon: suffixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        enabled: isEnabled,
        validator: validator == null
            ? (val) {
                if (val == null || val.isEmpty) {
                  return '${'PLZ_ENTER_LBL'.translate(context: context)} ${labelText?.trim()}';
                }
                // You can add custom validation here if needed
                return null;
              }
            : validator,
        onChanged: onchanged,
      ),
    );
  }

  _showContent1() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: isNetworkAvail
          ? Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 0,
                      left: 10,
                      right: 10,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: <Widget>[
                        profileImage(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 55,
                        ),
                        buildTextField(
                          nameC,
                          nameFocus,
                          name,
                          false,
                          Assets.profileInactive,
                          validator: (val) => StringValidation.validateUserName(
                            val,
                            context,
                          ),
                          onchanged: (v) => setState(
                            () {
                              name = v;
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 55,
                        ),
                        buildTextField(mobileC, nameFocus, name, false,
                            Assets.mobileNumber,
                            isEnabled: false),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 55,
                        ),
                        getDrivingLicense(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 55,
                        ),
                        changePass(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 8,
                        ),
                      ],
                    ),
                  ),
                ],
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

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GradientAppBar(
        EDIT_PROFILE_LBL.translate(context: context),
        customback: true,
      ),
      key: _scaffoldKey,
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          _showContent1(),
          DesignConfiguration.showCircularProgress(_isLoading, primary)
        ],
      ),
      bottomNavigationBar: Padding(
        padding: Platform.isIOS
            ? EdgeInsetsDirectional.only(
                start: 20, end: 20, top: 20, bottom: 20)
            : EdgeInsetsDirectional.only(
                start: 20,
                end: 20,
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom + 10),
        child: AppBtn(
          title: 'Save'.translate(context: context),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }
}
