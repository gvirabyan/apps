import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/CategoryModel/categoryModel.dart';
import 'package:sellermultivendor/Model/ZipCodesModel/ZipCodeModel.dart';
import 'package:sellermultivendor/Model/ZipCodesModel/ZipcodeGroupModel.dart';
import 'package:sellermultivendor/Model/city.dart';
import 'package:sellermultivendor/Model/CityModel/CityGroupModel.dart';
import 'package:sellermultivendor/Provider/categoryProvider.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Provider/zipcodeProvider.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Widget/deliverableTypeHelpDialog.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/security.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/overylay.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import 'Widget/common_text_form_field.dart';

class SellerRegister extends StatefulWidget {
  const SellerRegister({super.key});

  @override
  State<SellerRegister> createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister>
    with TickerProviderStateMixin {
  //==============================================================================
  //============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController storeUrlController = TextEditingController();
  TextEditingController storeDescriptionController = TextEditingController();
  TextEditingController lowStockLimitController = TextEditingController();
  TextEditingController taxNameController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  FocusNode? nameFocus,
      emailFocus,
      passFocus,
      confirmPassFocus,
      addressFocus,
      storeFocus,
      storeUrlFocus,
      storeDescriptionFocus,
      lowStockLimitFocus,
      taxNameFocus,
      taxNumberFocus,
      panNumberFocus,
      accountNumberFocus,
      accountNameFocus,
      bankCodeFocus,
      bankNameFocus,
      monumberFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  ScrollController controller = ScrollController();
  ScrollController controller1 = ScrollController();

  final mobileController = TextEditingController();
  var addressProfFile,
      nationalIdentityCardFile,
      storeLogoFile,
      authorizedSignFile;
  String? mobile,
      name,
      email,
      password,
      confirmpassword,
      address,
      addressproof,
      authorizedSign,
      nationalidentitycard,
      storename,
      storelogo,
      storeurl,
      storedescription,
      taxname,
      taxnumber,
      pannumber,
      accountnumber,
      accountname,
      bankcode,
      bankname,
      lowStockLimit;
  String? deliverabletypesValue = "";
  List<ZipCodeModel> selectedZipcodeList = [];
  List<CityModel> selectedCities = [];
  // Group-wise delivery variables
  String? deliverableGroupType = "";
  String? deliverableCityGroupType = "";
  List<ZipcodeGroupModel> selectedZipcodeGroups = [];
  List<CityGroupModel> selectedCityGroups = [];
  Timer? _debounce;
  Timer? _debounce1;
  Timer? _debounce2;
  ScrollController groupController = ScrollController();
  List<CategoryModel> selectedCategoriesList = [];
  //==============================================================================
  //============================= INIT Method ====================================

  _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (mounted) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          context.read<CityProvider>().getCities(isReload: false);
        } else {
          context.read<ZipcodeProvider>().setZipCode(ProductAction.signup);
        }
      }
    }
  }

  _scrollListener1() async {
    if (controller1.offset >= controller1.position.maxScrollExtent &&
        !controller1.position.outOfRange) {
      if (mounted) {
        context.read<CategoryProvider>().setCategoryList(isRefresh: false);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      controller.addListener(_scrollListener);

      if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
        context.read<CityProvider>().getCities(isReload: true);
      } else {
        context.read<ZipcodeProvider>().setZipCode(
          ProductAction.signup,
          isRefresh: true,
        );
      }
    });
    Future.delayed(Duration.zero, () {
      controller1.addListener(_scrollListener1);

      context.read<CategoryProvider>().setCategoryList(isRefresh: true);
    });
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    buttonSqueezeanimation = Tween(begin: width * 0.7, end: 50.0).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(0.0, 0.150),
      ),
    );
  }

  //==============================================================================
  //============================= For API Call ==================================

  Future<void> sellerRegisterAPI() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", registerApi);
        request.headers.addAll(headers);
        request.fields[Name] = name!;
        request.fields[Mobile] = mobile!;
        request.fields[Password] = password!;
        request.fields[EmailText] = email!;
        request.fields[ConfirmPassword] = confirmpassword!;
        request.fields[Address] = address!;

        if (authorizedSignFile != null) {
          final mimeType = lookupMimeType(authorizedSignFile.path);
          var extension = mimeType!.split("/");
          var authSign = await http.MultipartFile.fromPath(
            AuthSign,
            authorizedSignFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(authSign);
        }
        request.fields['category_ids'] = selectedCategoriesList
            .map((e) => e.id)
            .toList()
            .join(',');

        // Check if group-wise delivery is enabled
        if (AppSettingsRepository.appSettings.productDeliverabilityType ==
            "group_wise") {
          // Group-wise delivery parameters
          if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
            request.fields['deliverable_city_group_type'] =
                deliverableCityGroupType ?? "1";
            request.fields['deliverable_cities_group_ids[]'] =
                selectedCityGroups.isEmpty
                ? ""
                : selectedCityGroups.map((e) => e.id).toList().join(',');
          } else {
            request.fields['deliverable_group_type'] =
                deliverableGroupType ?? "1";
            request.fields['deliverable_zipcodes_group_ids[]'] =
                selectedZipcodeGroups.isEmpty
                ? ""
                : selectedZipcodeGroups.map((e) => e.id).toList().join(',');
          }
        } else {
          // Standard delivery parameters
          if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
            request.fields[DeliverableCityType] = deliverabletypesValue!;
            request.fields['serviceable_cities[]'] = selectedCities
                .map((e) => e.id)
                .toList()
                .join(',');
          } else {
            request.fields[DeliverableZipcodesType] = deliverabletypesValue!;
            request.fields['serviceable_zipcodes[]'] = selectedZipcodeList
                .map((e) => e.id)
                .toList()
                .join(',');
          }
        }
        if (storeLogoFile != null) {
          final mimeType = lookupMimeType(storeLogoFile.path);
          var extension = mimeType!.split("/");
          var storelogo = await http.MultipartFile.fromPath(
            "store_logo",
            storeLogoFile.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(storelogo);
        }

        if (storeurl != null) {
          request.fields[Storeurl] = storeurl!;
        }

        request.fields[StoreName] = storename!;

        request.fields[storeDescription] = storedescription!;
        request.fields[tax_name] = taxname!;
        request.fields[tax_number] = taxnumber!;
        request.fields[LOW_STOCK_LIMIT] = lowStockLimit!;
        print("Register seller--${request.fields}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String? msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          showMsgDialog(msg!, true);
        } else {
          print("api error: $msg");
          await buttonController!.reverse();
          showMsgDialog(msg!, false);
        }
      } on TimeoutException catch (_) {
        showOverlay('somethingMSg'.translate(context: context), context);
      }
    } else {
      if (mounted) {
        setState(() {
          isNetworkAvail = false;
        });
      }
    }
  }

  showMsgDialog(String msg, bool goBack) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            msg,
                            style: Theme.of(
                              this.context,
                            ).textTheme.titleMedium!.copyWith(color: fontColor),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (goBack == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  //==============================================================================
  //============================= For Animation ==================================

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

  //==============================================================================
  //============================= Network Checking ===============================

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      // Check if categories are selected
      if (selectedCategoriesList.isEmpty) {
        await buttonController!.reverse();
        setSnackbar(
          'SELECT_CATEGORY_REQUIRED'.translate(context: context),
          context,
        );
        return;
      }

      // Validate delivery selection based on delivery type
      bool isDeliveryValid = false;
      String errorMessage = '';

      if (AppSettingsRepository.appSettings.productDeliverabilityType ==
          "group_wise") {
        // Group-wise delivery validation
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          // For city groups: All (1) is valid, Include/Exclude (2/3) requires selection
          if (deliverableCityGroupType == "1") {
            isDeliveryValid = true;
          } else if ((deliverableCityGroupType == "2" ||
                  deliverableCityGroupType == "3") &&
              selectedCityGroups.isNotEmpty) {
            isDeliveryValid = true;
          } else {
            errorMessage = 'SELECT_CITY_GROUP_REQUIRED'.translate(
              context: context,
            );
          }
        } else {
          // For zipcode groups: All (1) is valid, Include/Exclude (2/3) requires selection
          if (deliverableGroupType == "1") {
            isDeliveryValid = true;
          } else if ((deliverableGroupType == "2" ||
                  deliverableGroupType == "3") &&
              selectedZipcodeGroups.isNotEmpty) {
            isDeliveryValid = true;
          } else {
            errorMessage = 'SELECT_ZIPCODE_GROUP_REQUIRED'.translate(
              context: context,
            );
          }
        }
      } else {
        // Standard delivery validation
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          if (deliverabletypesValue == "1" || selectedCities.isNotEmpty) {
            isDeliveryValid = true;
          } else {
            errorMessage = 'SELECT_CITIES_REQUIRED_LBL'.translate(
              context: context,
            );
          }
        } else {
          if (deliverabletypesValue == "1" || selectedZipcodeList.isNotEmpty) {
            isDeliveryValid = true;
          } else {
            errorMessage = 'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT'.translate(
              context: context,
            );
          }
        }
      }

      if (isDeliveryValid) {
        sellerRegisterAPI();
      } else {
        await buttonController!.reverse();
        setSnackbar(errorMessage, context);
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        await buttonController!.reverse();
        setState(() {
          isNetworkAvail = false;
        });
      });
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

  //==============================================================================
  //============================= Dispose Method =================================

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  //==============================================================================
  //============================= No Internet Widget =============================
  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then((_) async {
      isNetworkAvail = await isNetworkAvailable();
      if (isNetworkAvail) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (BuildContext context) => super.widget),
        );
      } else {
        await buttonController!.reverse();
        setState(() {});
      }
    });
  }

  //==============================================================================
  //============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: white,
        key: _scaffoldKey,
        body: isNetworkAvail
            ? getLoginContainer()
            : noInternet(
                context,
                setStateNoInternate,
                buttonSqueezeanimation,
                buttonController,
              ),
      ),
    );
  }

  signInTxt() {
    return Text(
      "SIGNUP_LBL".translate(context: context),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        color: black,
        fontWeight: FontWeight.bold,
        fontSize: textFontSize20,
        letterSpacing: 0.8,
        fontFamily: 'ubuntu',
      ),
    );
  }

  signInSubTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 13.0),
      child: Text(
        'JOIN_US_AND_START_SELLING'.translate(context: context),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: black,
          fontWeight: FontWeight.normal,
          fontFamily: 'ubuntu',
        ),
      ),
    );
  }

  detailText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 23.0),
      child: Text(
        'OWNER_DETAILS'.translate(context: context),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: black,
          fontWeight: FontWeight.normal,
          fontFamily: 'ubuntu',
          fontSize: textFontSize16,
        ),
      ),
    );
  }

  storeText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 23.0),
      child: Text(
        'STORE_DETAILS'.translate(context: context),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: black,
          fontWeight: FontWeight.normal,
          fontFamily: 'ubuntu',
          fontSize: textFontSize16,
        ),
      ),
    );
  }

  setHaveAcc() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "ALREADY_HAVE_AN_ACCOUNT".translate(context: context),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black,
              fontWeight: FontWeight.normal,
              fontFamily: 'ubuntu',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'SIGNIN_LBL'.translate(context: context),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.normal,
                fontFamily: 'ubuntu',
              ),
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================================
  //============================= Login Container widget =========================

  getLoginContainer() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 23),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DesignConfiguration.backButton(context),
                  signInTxt(),
                  signInSubTxt(),
                  detailText(),
                  setName(),
                  setEmail(),
                  setMobileNo(),
                  setPass(),
                  confirmPassword(),
                  storeText(),
                  storeName(),
                  storeUrl(),
                  setStoreCategories(),
                  // Show different widgets based on delivery type
                  if (AppSettingsRepository
                          .appSettings
                          .productDeliverabilityType ==
                      "group_wise") ...[
                    // Group-wise delivery widgets
                    getDeliverableGroupType(),
                    if (AppSettingsRepository
                            .appSettings
                            .isCityWiseDeliveribility
                        ? (deliverableCityGroupType == "2" ||
                              deliverableCityGroupType == "3")
                        : (deliverableGroupType == "2" ||
                              deliverableGroupType == "3"))
                      getDeliverableGroupSelection(),
                  ] else ...[
                    // Standard delivery widgets
                    getZipCodeOrCityType(),
                    if (deliverabletypesValue == "2" ||
                        deliverabletypesValue == "3")
                      getZipCodeOrCityContainer(),
                    if (deliverabletypesValue == "2" ||
                        deliverabletypesValue == "3")
                      warningMessage(),
                  ],
                  const SizedBox(height: 6),
                  setStoreDescription(),
                  setaddress(),
                  taxName(),
                  taxNumber(),
                  setLowStockLimit(),
                  uploadStoreLogo("Store Logo".translate(context: context)),
                  selectedMainImageShow(
                    storeLogoFile,
                    "Store Logo".translate(context: context),
                    1,
                  ),
                  uploadStoreLogo(
                    "Authorized Signature".translate(context: context),
                  ),
                  selectedMainImageShow(
                    authorizedSignFile,
                    "Authorized Signature".translate(context: context),
                    4,
                  ),
                  loginBtn(),
                  setHaveAcc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  warningMessage() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5),
      child: AppSettingsRepository.appSettings.isCityWiseDeliveribility
          ? selectedCities.isNotEmpty
                ? const SizedBox.shrink()
                : Text(
                    'SELECT_CITIES_REQUIRED_LBL'.translate(context: context),
                    style: const TextStyle(color: Colors.red, fontSize: 11),
                  )
          : selectedZipcodeList.isNotEmpty
          ? const SizedBox.shrink()
          : Text(
              'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT'.translate(context: context),
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
    );
  }

  uploadStoreLogo(String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 30.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: black,
          fontWeight: FontWeight.normal,
          fontFamily: 'ubuntu',
          fontSize: textFontSize16,
        ),
      ),
    );
  }

  mainImageFromGallery(int number) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);

      setState(() {
        if (number == 1) {
          storeLogoFile = image;
        }
        if (number == 2) {
          nationalIdentityCardFile = image;
        }
        if (number == 3) {
          addressProfFile = image;
        }
        if (number == 4) {
          authorizedSignFile = image;
        }
      });
    } else {
      // User canceled the picker
      return 'Required this filed';
    }
  }

  selectedMainImageShow(File? name, String title, int number) {
    return name == null
        ? GestureDetector(
            child: Container(
              margin: const EdgeInsetsDirectional.only(top: 15),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                border: Border.all(color: black.withValues(alpha: 0.3)),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    DesignConfiguration.setNewSvgPath(Assets.capa),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      'Enter Your $title Here',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: lightBlack,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              mainImageFromGallery(number);
            },
          )
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.file(
                    name,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: InkWell(
                    child: const Icon(Icons.close, color: white, size: 20),
                    onTap: () {
                      setState(() {
                        if (number == 1) {
                          storeLogoFile = null;
                          selectedMainImageShow(storeLogoFile, title, number);
                        } else if (number == 4) {
                          authorizedSignFile = null;
                          selectedMainImageShow(
                            authorizedSignFile,
                            title,
                            number,
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget setSignInLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Seller Registration".translate(context: context),
          style: const TextStyle(
            color: primary,
            fontSize: textFontSize30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  setName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 20.0),
      child: CommonTextFormField(
        controller: nameController,
        focusNode: nameFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nameFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          name = value;
        },
        hintText: "Name".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.profile),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  taxName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 20.0),
      child: CommonTextFormField(
        controller: taxNameController,
        focusNode: taxNameFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(taxNameFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          taxname = value;
        },
        hintText: "TaxName".translate(context: context),
        prefixIcon: const Icon(Icons.person, color: lightBlack2, size: 20),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  taxNumber() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 20.0),
      child: CommonTextFormField(
        controller: taxNumberController,
        focusNode: taxNumberFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(taxNumberFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          taxnumber = value;
        },
        hintText: "TaxNumber".translate(context: context),
        prefixIcon: const Icon(
          Icons.format_list_numbered_outlined,
          color: lightBlack2,
          size: 20,
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  setStoreDescription() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: storeDescriptionController,
        focusNode: storeDescriptionFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeDescriptionFocus);
        },
        keyboardType: TextInputType.multiline,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          storedescription = value;
        },
        hintText: "Store Description".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.description),
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
        maxLines: 1,
      ),
    );
  }

  setLowStockLimit() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: lowStockLimitController,
        focusNode: lowStockLimitFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(lowStockLimitFocus);
        },
        keyboardType: TextInputType.multiline,
        onSaved: (String? value) {
          lowStockLimit = value;
        },
        hintText: "PRODUCT_LOW_STOCK_LIMIT".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.lowStock),
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
        maxLines: 1,
      ),
    );
  }

  Widget setStoreCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          border: Border.all(color: black.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(circularBorderRadius7),
          color: lightWhite.withValues(alpha: 0.5),
        ),
        child: ListTile(
          title: selectedCategoriesList.isNotEmpty
              ? Text(
                  selectedCategoriesList.map((e) => e.name).toList().join(', '),
                )
              : Text(
                  'Select Category'.translate(context: context),
                  style: TextStyle(
                    fontSize: 13,
                    color: black.withValues(alpha: 0.4),
                  ),
                ),
          trailing: const Icon(Icons.chevron_right),
          // Prevent text entry
          onTap: () async {
            final categoriesProvider = Provider.of<CategoryProvider>(
              context,
              listen: false,
            );
            if (categoriesProvider.searchString.isNotEmpty) {
              categoriesProvider.searchString = "";
              context.read<CategoryProvider>().setCategoryList(isRefresh: true);
            } else if (categoriesProvider.categoryList.isEmpty) {
              context.read<CategoryProvider>().setCategoryList(
                isRefresh: false,
              );
            }
            // await categoriesDialog(context); // Open the bottom sheet
            await showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  scrollable: true,
                  content: Consumer<CategoryProvider>(
                    builder: (context, data, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select Category'.translate(context: context),
                            style: Theme.of(
                              this.context,
                            ).textTheme.titleMedium!.copyWith(color: primary),
                          ),
                          const Divider(color: lightBlack),
                          Flexible(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: SingleChildScrollView(
                                // physics: AlwaysScrollableScrollPhysics(),
                                controller: controller1,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            circularBorderRadius5,
                                          ),
                                        ),
                                        boxShadow: [
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
                                          prefixIcon: const Icon(Icons.search),
                                          hintText: "SEARCH".translate(
                                            context: context,
                                          ),
                                          hintStyle: TextStyle(
                                            color: black.withValues(alpha: 0.3),
                                            fontWeight: FontWeight.normal,
                                          ),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (_debounce1?.isActive ?? false) {
                                            _debounce1?.cancel();
                                          }
                                          data.searchString = value;
                                          //auto search after 1 second of typing
                                          _debounce1 = Timer(
                                            const Duration(milliseconds: 1000),
                                            () {
                                              context
                                                  .read<CategoryProvider>()
                                                  .setCategoryList();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        StatefulBuilder(
                                          builder: (context, setstater) {
                                            print(
                                              "category list length--->${data.categoryList.length}}",
                                            );
                                            return (data
                                                    .categoryList
                                                    .isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: () {
                                                      return data.categoryList
                                                          .asMap()
                                                          .map(
                                                            (
                                                              index,
                                                              element,
                                                            ) => MapEntry(
                                                              index,
                                                              CheckboxListTile(
                                                                title: Text(
                                                                  element.name!,
                                                                ),
                                                                value: selectedCategoriesList.any(
                                                                  (selected) =>
                                                                      selected
                                                                          .id ==
                                                                      element
                                                                          .id,
                                                                ),
                                                                onChanged: (isSelected) {
                                                                  if (isSelected ==
                                                                      true) {
                                                                    if (!selectedCategoriesList.any(
                                                                      (
                                                                        selected,
                                                                      ) =>
                                                                          selected
                                                                              .id ==
                                                                          element
                                                                              .id,
                                                                    )) {
                                                                      selectedCategoriesList
                                                                          .add(
                                                                            element,
                                                                          );
                                                                    }
                                                                  } else {
                                                                    selectedCategoriesList.removeWhere(
                                                                      (
                                                                        selected,
                                                                      ) =>
                                                                          selected
                                                                              .id ==
                                                                          element
                                                                              .id,
                                                                    );
                                                                  }
                                                                  setState(
                                                                    () {},
                                                                  ); // Update UI
                                                                  setstater(
                                                                    () {},
                                                                  ); // Update dialog state
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                          .values
                                                          .toList();
                                                    }(),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 20.0,
                                                        ),
                                                    child: Text(
                                                      'CATEGORY_IS_NOT_AVAIL_LBL'
                                                          .translate(
                                                            context: context,
                                                          ),
                                                    ),
                                                  );
                                          },
                                        ),
                                        DesignConfiguration.showCircularProgress(
                                          false,
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget getZipCodeOrCityType() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            decoration: BoxDecoration(
              border: Border.all(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
              color: lightWhite.withValues(alpha: 0.5),
            ),
            child: ListTile(
              title: Text(
                AppSettingsRepository.appSettings.isCityWiseDeliveribility
                    ? (deliverabletypesValue == "1"
                          ? "All".translate(context: context)
                          : deliverabletypesValue == "2"
                          ? "Include".translate(context: context)
                          : deliverabletypesValue == "3"
                          ? "Exclude".translate(context: context)
                          : "DELIVERABLE_CITY_TYPE".translate(context: context))
                    : (deliverabletypesValue == "1"
                          ? "All".translate(context: context)
                          : deliverabletypesValue == "2"
                          ? "Include".translate(context: context)
                          : deliverabletypesValue == "3"
                          ? "Exclude".translate(context: context)
                          : "DELIVERABLE_ZIPCODE_TYPE".translate(context: context)),
                style: TextStyle(fontSize: 13, color: black.withValues(alpha: 0.4)),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(circularBorderRadius25),
                          topRight: Radius.circular(circularBorderRadius25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Select Deliverable Type".translate(
                                    context: context,
                                  ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(color: primary),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: lightBlack),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      deliverabletypesValue = '1';
                                      Navigator.of(context).pop();
                                      setState(() {});
                                      // update();
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          20.0,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("All".translate(context: context)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      deliverabletypesValue = '2';
                                      Navigator.of(context).pop();
                                      setState(() {});
                                      // update();
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          20.0,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Include".translate(context: context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      deliverabletypesValue = '3';
                                      Navigator.of(context).pop();
                                      setState(() {});
                                      // update();
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          20.0,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Exclude".translate(context: context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => deliverableTypeHelpDialog(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: primary,
                ),
                const SizedBox(width: 4),
                Text(
                  "HOW_IT_WORKS".translate(context: context),
                  style: const TextStyle(
                    fontSize: 12,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Group-wise delivery type selection widget
  Widget getDeliverableGroupType() {
    final isCityWise =
        AppSettingsRepository.appSettings.isCityWiseDeliveribility;
    final currentValue = isCityWise
        ? deliverableCityGroupType
        : deliverableGroupType;

    String getDisplayText() {
      if (currentValue == "1") {
        return "All".translate(context: context);
      } else if (currentValue == "2") {
        return "Include".translate(context: context);
      } else if (currentValue == "3") {
        return "Exclude".translate(context: context);
      }
      return isCityWise
          ? "DELIVERABLE_CITY_GROUP_TYPE".translate(context: context)
          : "DELIVERABLE_ZIPCODE_GROUP_TYPE".translate(context: context);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            decoration: BoxDecoration(
              border: Border.all(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
              color: lightWhite.withValues(alpha: 0.5),
            ),
            child: ListTile(
              title: Text(
                getDisplayText(),
                style: TextStyle(
                  fontSize: 13,
                  color: currentValue == null || currentValue.isEmpty
                      ? black.withValues(alpha: 0.4)
                      : black,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(circularBorderRadius25),
                          topRight: Radius.circular(circularBorderRadius25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                            child: Text(
                              isCityWise
                                  ? "DELIVERABLE_CITY_GROUP_TYPE".translate(
                                      context: context,
                                    )
                                  : "DELIVERABLE_ZIPCODE_GROUP_TYPE".translate(
                                      context: context,
                                    ),
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium!.copyWith(color: primary),
                            ),
                          ),
                          const Divider(color: lightBlack),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // All option
                                  InkWell(
                                    onTap: () {
                                      if (isCityWise) {
                                        deliverableCityGroupType = '1';
                                        selectedCityGroups.clear();
                                      } else {
                                        deliverableGroupType = '1';
                                        selectedZipcodeGroups.clear();
                                      }
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          20.0,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Text(
                                          "All".translate(context: context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Include option
                                  InkWell(
                                    onTap: () {
                                      if (isCityWise) {
                                        deliverableCityGroupType = '2';
                                      } else {
                                        deliverableGroupType = '2';
                                      }
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          20.0,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Text(
                                          "Include".translate(context: context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Exclude option
                                  InkWell(
                                    onTap: () {
                                      if (isCityWise) {
                                        deliverableCityGroupType = '3';
                                      } else {
                                        deliverableGroupType = '3';
                                      }
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20.0,
                                          20.0,
                                          20.0,
                                          20.0,
                                        ),
                                        child: Text(
                                          "Exclude".translate(context: context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => deliverableTypeHelpDialog(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: primary,
                ),
                const SizedBox(width: 4),
                Text(
                  "HOW_IT_WORKS".translate(context: context),
                  style: const TextStyle(
                    fontSize: 12,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Group selection widget for zipcode/city groups
  Widget getDeliverableGroupSelection() {
    final isCityWise =
        AppSettingsRepository.appSettings.isCityWiseDeliveribility;

    String getDisplayText() {
      if (isCityWise) {
        if (selectedCityGroups.isNotEmpty) {
          return selectedCityGroups
              .map((e) {
                final citiesString = e.cities
                    .map((c) => c.cityName)
                    .whereType<String>()
                    .join(', ');
                return '${e.groupName ?? ''} (${"CITIES".translate(context: context)} $citiesString, ${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? '0'})';
              })
              .join(' , ');
        }
        return "SELECT_CITY_GROUP".translate(context: context);
      } else {
        if (selectedZipcodeGroups.isNotEmpty) {
          return selectedZipcodeGroups
              .map((e) {
                final zipcodesString = e.zipcodes
                    .map((z) => z.zipcode)
                    .whereType<String>()
                    .join(', ');
                return '${e.groupName ?? ''} (${"ZIPCODES".translate(context: context)}: $zipcodesString, ${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? '0'})';
              })
              .join(' , ');
        }
        return "SELECT_ZIPCODE_GROUP".translate(context: context);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          border: Border.all(color: black.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(circularBorderRadius7),
          color: lightWhite.withValues(alpha: 0.5),
        ),
        child: ListTile(
          title: Text(
            getDisplayText(),
            style: TextStyle(
              fontSize: 13,
              color:
                  (isCityWise
                      ? selectedCityGroups.isEmpty
                      : selectedZipcodeGroups.isEmpty)
                  ? black.withValues(alpha: 0.4)
                  : black,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            if (isCityWise) {
              await showCityGroupSelectionDialog();
            } else {
              await showZipcodeGroupSelectionDialog();
            }
          },
        ),
      ),
    );
  }

  // Zipcode group selection dialog
  Future<void> showZipcodeGroupSelectionDialog() async {
    final zipcodeProvider = Provider.of<ZipcodeProvider>(
      context,
      listen: false,
    );
    if (zipcodeProvider.zipcodeGroupList.isEmpty) {
      zipcodeProvider.setZipCodeGroup(ProductAction.signup, ignoreSeller: '1');
    }

    await showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          scrollable: true,
          content: Consumer<ZipcodeProvider>(
            builder: (context, data, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "DELIVERABLE_ZIPCODE_GROUP".translate(context: context),
                    style: Theme.of(
                      this.context,
                    ).textTheme.titleMedium!.copyWith(color: primary),
                  ),
                  const Divider(color: lightBlack),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        controller: groupController,
                        child: Column(
                          children: [
                            // Search field
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(circularBorderRadius5),
                                ),
                                boxShadow: [
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
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 40,
                                    maxHeight: 20,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "SEARCH".translate(
                                    context: context,
                                  ),
                                  hintStyle: TextStyle(
                                    color: black.withValues(alpha: 0.3),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (_debounce2?.isActive ?? false) {
                                    _debounce2?.cancel();
                                  }
                                  data.searchString = value;
                                  _debounce2 = Timer(
                                    const Duration(milliseconds: 1000),
                                    () {
                                      data.setZipCodeGroup(
                                        ProductAction.signup,
                                        ignoreSeller: '1',
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            data.zipcodeGroupList.isNotEmpty
                                ? StatefulBuilder(
                                    builder: (context, setStater) {
                                      return Column(
                                        children: data.zipcodeGroupList.map((
                                          element,
                                        ) {
                                          final zipcodesString = element
                                              .zipcodes
                                              .map((z) => z.zipcode)
                                              .whereType<String>()
                                              .join(', ');
                                          return CheckboxListTile(
                                            title: Text(
                                              element.groupName ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${"ZIPCODES".translate(context: context)}: $zipcodesString\n${"CHARGES".translate(context: context)}: ${element.deliveryCharge ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            value: selectedZipcodeGroups.any(
                                              (g) => g.id == element.id,
                                            ),
                                            onChanged: (isSelected) {
                                              if (isSelected == true) {
                                                if (!selectedZipcodeGroups.any(
                                                  (g) => g.id == element.id,
                                                )) {
                                                  selectedZipcodeGroups.add(
                                                    element,
                                                  );
                                                }
                                              } else {
                                                selectedZipcodeGroups
                                                    .removeWhere(
                                                      (g) => g.id == element.id,
                                                    );
                                              }
                                              setState(() {});
                                              setStater(() {});
                                            },
                                          );
                                        }).toList(),
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Text(
                                      'ZIPCODE_GROUP_NOT_AVAIL'.translate(
                                        context: context,
                                      ),
                                    ),
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
                        style: Theme.of(
                          this.context,
                        ).textTheme.titleMedium!.copyWith(color: primary),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // City group selection dialog
  Future<void> showCityGroupSelectionDialog() async {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    if (cityProvider.cityGroupList.isEmpty) {
      cityProvider.getCitiesGroup(ignoreSeller: '1');
    }

    await showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          scrollable: true,
          content: Consumer<CityProvider>(
            builder: (context, data, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "DELIVERABLE_CITY_GROUP".translate(context: context),
                    style: Theme.of(
                      this.context,
                    ).textTheme.titleMedium!.copyWith(color: primary),
                  ),
                  const Divider(color: lightBlack),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        controller: groupController,
                        child: Column(
                          children: [
                            // Search field
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(circularBorderRadius5),
                                ),
                                boxShadow: [
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
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 40,
                                    maxHeight: 20,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "SEARCH".translate(
                                    context: context,
                                  ),
                                  hintStyle: TextStyle(
                                    color: black.withValues(alpha: 0.3),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (_debounce2?.isActive ?? false) {
                                    _debounce2?.cancel();
                                  }
                                  data.searchString = value;
                                  _debounce2 = Timer(
                                    const Duration(milliseconds: 1000),
                                    () {
                                      data.getCitiesGroup(ignoreSeller: '1');
                                    },
                                  );
                                },
                              ),
                            ),
                            data.isLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 50.0,
                                      ),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : data.cityGroupList.isNotEmpty
                                ? StatefulBuilder(
                                    builder: (context, setStater) {
                                      return Column(
                                        children: data.cityGroupList.map((
                                          element,
                                        ) {
                                          final citiesString = element.cities
                                              .map((c) => c.cityName)
                                              .whereType<String>()
                                              .join(', ');
                                          return CheckboxListTile(
                                            title: Text(
                                              element.groupName ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${"CITIES".translate(context: context)}: $citiesString\n${"CHARGES".translate(context: context)}: ${element.deliveryCharge ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            value: selectedCityGroups.any(
                                              (g) => g.id == element.id,
                                            ),
                                            onChanged: (isSelected) {
                                              if (isSelected == true) {
                                                if (!selectedCityGroups.any(
                                                  (g) => g.id == element.id,
                                                )) {
                                                  selectedCityGroups.add(
                                                    element,
                                                  );
                                                }
                                              } else {
                                                selectedCityGroups.removeWhere(
                                                  (g) => g.id == element.id,
                                                );
                                              }
                                              setState(() {});
                                              setStater(() {});
                                            },
                                          );
                                        }).toList(),
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Text(
                                      'CITY_GROUP_NOT_AVAIL'.translate(
                                        context: context,
                                      ),
                                    ),
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
                        style: Theme.of(
                          this.context,
                        ).textTheme.titleMedium!.copyWith(color: primary),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget getZipCodeOrCityContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          border: Border.all(color: black.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(circularBorderRadius7),
          color: lightWhite.withValues(alpha: 0.5),
        ),
        child: ListTile(
          title: AppSettingsRepository.appSettings.isCityWiseDeliveribility
              ? selectedCities.isNotEmpty
                    ? Text(
                        selectedCities.map((e) => e.name).toList().join(', '),
                      )
                    : Text(
                        'SELECT_CITIES_LBL'.translate(context: context),
                        style: TextStyle(
                          fontSize: 13,
                          color: black.withValues(alpha: 0.4),
                        ),
                      )
              : selectedZipcodeList.isNotEmpty
              ? Text(
                  selectedZipcodeList.map((e) => e.zipcode).toList().join(', '),
                )
              : Text(
                  'SELECT_ZIPCODE_LBL'.translate(context: context),
                  style: TextStyle(
                    fontSize: 13,
                    color: black.withValues(alpha: 0.4),
                  ),
                ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
              final cityProvider = Provider.of<CityProvider>(
                context,
                listen: false,
              );
              if (cityProvider.searchString.isNotEmpty) {
                cityProvider.searchString = "";
                context.read<CityProvider>().getCities();
              } else if (cityProvider.cityList.isEmpty) {
                context.read<CityProvider>().getCities();
              }
            } else {
              final zipcodeProvider = Provider.of<ZipcodeProvider>(
                context,
                listen: false,
              );
              if (zipcodeProvider.searchString.isNotEmpty) {
                zipcodeProvider.searchString = "";
                context.read<ZipcodeProvider>().setZipCode(
                  ProductAction.signup,
                  isRefresh: true,
                );
              } else if (zipcodeProvider.zipcodeList.isEmpty) {
                context.read<ZipcodeProvider>().setZipCode(
                  ProductAction.signup,
                  isRefresh: false,
                );
              }
            }
            await showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  scrollable: true,
                  content: Consumer<CityProvider>(
                    builder: (context, cityData, child) {
                      return Consumer<ZipcodeProvider>(
                        builder: (context, data, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppSettingsRepository
                                        .appSettings
                                        .isCityWiseDeliveribility
                                    ? 'SELECT_CITIES_LBL'.translate(
                                        context: context,
                                      )
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
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                circularBorderRadius5,
                                              ),
                                            ),
                                            boxShadow: [
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
                                              prefixIcon: const Icon(
                                                Icons.search,
                                              ),
                                              hintText: "SEARCH".translate(
                                                context: context,
                                              ),
                                              hintStyle: TextStyle(
                                                color: black.withValues(
                                                  alpha: 0.3,
                                                ),
                                                fontWeight: FontWeight.normal,
                                              ),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              if (_debounce?.isActive ??
                                                  false) {
                                                _debounce?.cancel();
                                              }
                                              data.searchString = value;
                                              cityData.searchString = value;
                                              //auto search after 1 second of typing
                                              _debounce = Timer(
                                                const Duration(
                                                  milliseconds: 1000,
                                                ),
                                                () {
                                                  if (AppSettingsRepository
                                                      .appSettings
                                                      .isCityWiseDeliveribility) {
                                                    context
                                                        .read<CityProvider>()
                                                        .getCities();
                                                  } else {
                                                    context
                                                        .read<ZipcodeProvider>()
                                                        .setZipCode(
                                                          ProductAction.signup,
                                                        );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        (AppSettingsRepository
                                                    .appSettings
                                                    .isCityWiseDeliveribility
                                                ? cityData.isLoading
                                                : false)
                                            ? const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 50.0,
                                                  ),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  (AppSettingsRepository
                                                              .appSettings
                                                              .isCityWiseDeliveribility
                                                          ? cityData
                                                                .cityList
                                                                .isNotEmpty
                                                          : data
                                                                .zipcodeList
                                                                .isNotEmpty)
                                                      ? StatefulBuilder(
                                                          builder: (context, setstater) {
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
                                                                      .map(
                                                                        (
                                                                          index,
                                                                          element,
                                                                        ) => MapEntry(
                                                                          index,
                                                                          CheckboxListTile(
                                                                            title: Text(
                                                                              element.name,
                                                                            ),
                                                                            value: selectedCities.any(
                                                                              (
                                                                                selected,
                                                                              ) =>
                                                                                  selected.id ==
                                                                                  element.id,
                                                                            ),
                                                                            // selectedCities.contains(element),
                                                                            onChanged:
                                                                                (
                                                                                  isSelected,
                                                                                ) {
                                                                                  if (isSelected ==
                                                                                      true) {
                                                                                    if (!selectedCities.any(
                                                                                      (
                                                                                        selected,
                                                                                      ) =>
                                                                                          selected.id ==
                                                                                          element.id,
                                                                                    )) {
                                                                                      selectedCities.add(
                                                                                        element,
                                                                                      );
                                                                                    }
                                                                                  } else {
                                                                                    selectedCities.removeWhere(
                                                                                      (
                                                                                        selected,
                                                                                      ) =>
                                                                                          selected.id ==
                                                                                          element.id,
                                                                                    );
                                                                                  }
                                                                                  setState(
                                                                                    () {},
                                                                                  ); // Update UI
                                                                                  setstater(
                                                                                    () {},
                                                                                  ); // Update dialog state
                                                                                },
                                                                          ),
                                                                        ),
                                                                      )
                                                                      .values
                                                                      .toList();
                                                                }
                                                                return data
                                                                    .zipcodeList
                                                                    .asMap()
                                                                    .map(
                                                                      (
                                                                        index,
                                                                        element,
                                                                      ) => MapEntry(
                                                                        index,
                                                                        CheckboxListTile(
                                                                          title: Text(
                                                                            element.zipcode!,
                                                                          ),
                                                                          value: selectedZipcodeList.any(
                                                                            (
                                                                              selected,
                                                                            ) =>
                                                                                selected.id ==
                                                                                element.id,
                                                                          ),
                                                                          // selectedZipcodeList.contains(element),
                                                                          //value: true,
                                                                          onChanged:
                                                                              (
                                                                                isSelected,
                                                                              ) {
                                                                                if (isSelected ==
                                                                                    true) {
                                                                                  if (!selectedZipcodeList.any(
                                                                                    (
                                                                                      selected,
                                                                                    ) =>
                                                                                        selected.id ==
                                                                                        element.id,
                                                                                  )) {
                                                                                    selectedZipcodeList.add(
                                                                                      element,
                                                                                    );
                                                                                  }
                                                                                } else {
                                                                                  selectedZipcodeList.removeWhere(
                                                                                    (
                                                                                      selected,
                                                                                    ) =>
                                                                                        selected.id ==
                                                                                        element.id,
                                                                                  );
                                                                                }
                                                                                setState(
                                                                                  () {},
                                                                                ); // Update UI
                                                                                setstater(
                                                                                  () {},
                                                                                ); // Update dialog state
                                                                              },
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .values
                                                                    .toList();
                                                              }(),
                                                            );
                                                          },
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 20.0,
                                                              ),
                                                          child: Text(
                                                            AppSettingsRepository
                                                                    .appSettings
                                                                    .isCityWiseDeliveribility
                                                                ? 'CITY_IS_NOT_AVAIL_LBL'
                                                                      .translate(
                                                                        context:
                                                                            context,
                                                                      )
                                                                : 'ZIPCODE_IS_NOT_AVAIL_LBL'
                                                                      .translate(
                                                                        context:
                                                                            context,
                                                                      ),
                                                          ),
                                                        ),
                                                  DesignConfiguration.showCircularProgress(
                                                    AppSettingsRepository
                                                            .appSettings
                                                            .isCityWiseDeliveribility
                                                        ? cityData.isLoadingmore
                                                        : false,
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

  storeUrl() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: storeUrlController,
        focusNode: storeUrlFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeUrlFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          storeurl = value;
        },
        hintText: "StoreURL".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.storeUrl),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  storeName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 10.0),
      child: CommonTextFormField(
        controller: storeController,
        focusNode: storeFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storeFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          storename = value;
        },
        hintText: "StoreName".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.storeName),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  setaddress() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: addressController,
        focusNode: addressFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(addressFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) =>
            StringValidation.validateThisFieldRequired(val!, context),
        onSaved: (String? value) {
          address = value;
        },
        hintText: "Address".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.address),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  setEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: emailController,
        focusNode: emailFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(emailFocus);
        },
        keyboardType: TextInputType.text,
        validator: (val) => StringValidation.validateEmail(val!, context),
        onSaved: (String? value) {
          email = value;
        },
        hintText: "E-mail".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.email),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  setMobileNo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: mobileController,
        focusNode: monumberFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(monumberFocus);
        },
        keyboardType: TextInputType.number,
        validator: (val) => StringValidation.validateMob(val!, context),
        onSaved: (String? value) {
          mobile = value;
        },
        hintText: "MobileNumber".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.mobileNumber),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.3).withValues(alpha: 0.3),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.next,
        maxLength: 16,
      ),
    );
  }

  setPass() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: passwordController,
        focusNode: passFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (val) =>
            StringValidation.validatePass(val!, context, onlyRequired: false),
        onSaved: (String? value) {
          password = value;
        },
        hintText: "PASSHINT_LBL".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.password),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  confirmPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.only(top: 15.0),
      child: CommonTextFormField(
        controller: confirmPasswordController,
        focusNode: confirmPassFocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(confirmPassFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (val) =>
            StringValidation.validatePass(val!, context, onlyRequired: true),
        onSaved: (String? value) {
          confirmpassword = value;
        },
        hintText: "CONFIRMPASSHINT_LBL".translate(context: context),
        prefixIcon: SvgPicture.asset(
          DesignConfiguration.setNewSvgPath(Assets.password),
          fit: BoxFit.scaleDown,
          colorFilter: const ColorFilter.mode(lightBlack2, BlendMode.srcIn),
        ),
        fillColor: lightWhite.withValues(alpha: 0.4),
        borderColor: black,
        borderRadius: circularBorderRadius7,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: lightBlack2,
          fontWeight: FontWeight.normal,
        ),
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        textInputAction: TextInputAction.next,
      ),
    );
  }

  loginBtn() {
    return AppBtn(
      title: "Apply Now".translate(context: context),
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }
}
