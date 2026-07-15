//============================= Drawer Implimentation ==========================
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/appLanguageModel.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/OrderList/orders_screen.dart';
import 'package:sellermultivendor/Widget/bottomsheet.dart';
import 'package:sellermultivendor/cubits/languageCubit.dart';
import '../../../Helper/ApiBaseHelper.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/dialogAnimate.dart';
import '../../../Widget/networkAvailablity.dart';
import '../../../Widget/parameterString.dart';
import '../../../Provider/privacyProvider.dart';
import '../../../Provider/walletProvider.dart';
import '../../../Widget/api.dart';
import '../../../Widget/routes.dart';
import '../../../Widget/sharedPreferances.dart';
import '../../../Widget/snackbar.dart';
import '../../AddProduct/Add_Product.dart';
import '../../Authentication/Login.dart';
import '../../ProductList/ProductList.dart';
import '../../Profile/Profile.dart';
import '../../StockManageMentScreen/StockManageMentList.dart';
import '../../TermFeed/policys.dart';
import '../../WalletHistory/WalletHistory.dart';
import 'logoutDialog.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int currentIndex = 0;
  String? verifyPassword;
  List<String?> languageList = [];
  TextEditingController passwordController = TextEditingController();
  FocusNode? passFocus = FocusNode();
  double? size;
  String? selectedLanguageCode;
  bool _isLoadingProfile = false;

  @override
  void initState() {
    super.initState();
    final languageState = context.read<LanguageCubit>().state;
    if (languageState is LanguageLoader) {
      selectedLanguageCode = languageState.languageCode;
    }
    // Load profile data if not already loaded
    if (LOGO == '' || CUR_USERNAME == null || CUR_USERNAME == '') {
      _loadProfileData();
    }
  }

  Future<void> _loadProfileData() async {
    if (_isLoadingProfile) return;
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      isNetworkAvail = await isNetworkAvailable();
      if (isNetworkAvail) {
        var parameter = {};
        ApiBaseHelper().postAPICall(getSellerDetailsApi, parameter).then(
          (getdata) async {
            bool error = getdata["error"];
            if (!error) {
              var data = getdata["data"][0];
              CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
              LOGO = data["logo"].toString();
              RATTING = data[Rating] ?? "";
              NO_OFF_RATTING = data[NoOfRatings] ?? "";
              CUR_USERNAME = data[Username];
              EMAIL = data[EmailText];
              if (mounted) {
                setState(() {
                  _isLoadingProfile = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  _isLoadingProfile = false;
                });
              }
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _isLoadingProfile = false;
              });
            }
          },
        );
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProfile = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.height;
    return ListView(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      children: <Widget>[
        _getHeader(),
        _getDrawerItem(
            "EDIT_PROFILE_LBL".translate(context: context), Assets.profile),
        _getDrawerItem("ORDERS".translate(context: context), Assets.order),
        _getDrawerItem("CHAT".translate(context: context), Assets.chat),
        const Divider(),
        _getDrawerItem(
            "WALLETHISTORY".translate(context: context), Assets.wallet),
        _getDrawerItem("PRODUCTS".translate(context: context), Assets.product),
        _getDrawerItem(
            'Add Product'.translate(context: context), Assets.addProduct),
        if (AppSettingsRepository.appSettings.isShiprocketOn)
          _getDrawerItem('Manage PickUp Location'.translate(context: context),
              Assets.managePickupLocation),
        _getDrawerItem('Stock Management'.translate(context: context),
            Assets.stockManagement),
        const Divider(),
        _getDrawerItem("ChangeLanguage".translate(context: context),
            Assets.changeLanguage),
        _getDrawerItem(
            "T_AND_C".translate(context: context), Assets.privacyPolicy),
        _getDrawerItem("PRIVACYPOLICY".translate(context: context),
            Assets.termsConditions),
        const Divider(),
        _getDrawerItem(
            "CONTACTUS".translate(context: context), Assets.contactUs),
        _getDrawerItem(
            "Return Policy".translate(context: context), Assets.returnPolicy),
        _getDrawerItem(
            "Shipping Policy".translate(context: context), Assets.shipping),
        const Divider(),
        _getDrawerItem(
            "Delete Account".translate(context: context), Assets.delete),
        _getDrawerItem("LOGOUT".translate(context: context), Assets.logout),
      ],
    );
  }

//Userd Widget for Drawer

  _getHeader() {
    return Container(
      decoration: DesignConfiguration.back(),
      padding: const EdgeInsets.only(left: 10.0, bottom: 10),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: size! / 15,
                      width: size! / 15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: LOGO != ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  circularBorderRadius100),
                              child: sallerLogo(62),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  circularBorderRadius100),
                              child: imagePlaceHolder(62),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CUR_USERNAME!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                          maxLines: 1,
                          softWrap: false,
                        ),
                        EMAIL != ''
                            ? Text(
                                EMAIL!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                maxLines: 1,
                                softWrap: false,
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:
                              const Color(0xffFFFFFF).withValues(alpha: 0.3)),
                      // height: 30,
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              DesignConfiguration.setNewSvgPath(Assets.wallet),
                            ),
                            Text(
                              DesignConfiguration.getPriceFormat(
                                context,
                                double.parse(CUR_BALANCE),
                              )!,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sallerLogo(double size) {
    return CircleAvatar(
      backgroundImage: NetworkImage(LOGO),
      radius: 25,
    );
  }

  imagePlaceHolder(double size) {
    return SizedBox(
      height: size,
      width: size,
      child: Icon(
        Icons.account_circle,
        color: Colors.white,
        size: size,
      ),
    );
  }

  _getDrawerItem(String title, String img) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(circularBorderRadius50),
          bottomRight: Radius.circular(circularBorderRadius50),
        ),
      ),
      child: ListTile(
        dense: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(circularBorderRadius100),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: SvgPicture.asset(
              DesignConfiguration.setNewSvgPath(img),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: black, fontSize: textFontSize15),
        ),
        onTap: () {
          if (title == "EDIT_PROFILE_LBL".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const Profile(),
              ),
            ).then(
              (value) {
                setState(() {});
              },
            );
            setState(
              () {},
            );
          } else if (title == "ORDERS".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const OrdersScreen(),
              ),
            );
          } else if (title == "CHAT".translate(context: context)) {
            Routes.navigateToConversationListScreen(context);
          } else if (title == "WALLETHISTORY".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<WalletTransactionProvider>(
                  create: (context) => WalletTransactionProvider(),
                  child: const WalletHistory(),
                ),
              ),
            );
          } else if (title == "PRODUCTS".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const ProductList(
                  flag: '',
                  fromNavbar: false,
                ),
              ),
            );
          } else if (title == "ChangeLanguage".translate(context: context)) {
            // languageDialog();
            _showBottomSheet();
          } else if (title == "T_AND_C".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChangeNotifierProvider<SystemProvider>(
                  create: (context) => SystemProvider(),
                  child: Policy(
                    title: "TERM_CONDITIONS".translate(context: context),
                  ),
                ),
              ),
            );
          } else if (title == "Delete Account".translate(context: context)) {
            currentIndex = 0;
            deleteAccountDailog();
          } else if (title == "CONTACTUS".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChangeNotifierProvider<SystemProvider>(
                  create: (context) => SystemProvider(),
                  child: Policy(
                    title: "CONTACTUS".translate(context: context),
                  ),
                ),
              ),
            );
          } else if (title == "PRIVACYPOLICY".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChangeNotifierProvider<SystemProvider>(
                  create: (context) => SystemProvider(),
                  child: Policy(
                    title: "PRIVACYPOLICY".translate(context: context),
                  ),
                ),
              ),
            );
          } else if (title == "Return Policy".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChangeNotifierProvider<SystemProvider>(
                  create: (context) => SystemProvider(),
                  child: Policy(
                    title: "Return Policy".translate(context: context),
                  ),
                ),
              ),
            );
          } else if (title == "Shipping Policy".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChangeNotifierProvider<SystemProvider>(
                  create: (context) => SystemProvider(),
                  child: Policy(
                    title: "Shipping Policy".translate(context: context),
                  ),
                ),
              ),
            );
          } else if (title == "LOGOUT".translate(context: context)) {
            logOutDailog(context);
          } else if (title == "Add Product".translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const AddProduct(),
              ),
            );
          } else if (title == 'Stock Management'.translate(context: context)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const StockManagementList(
                  fromNavbar: false,
                ),
              ),
            );
          } else if (title ==
              'Manage PickUp Location'.translate(context: context)) {
            Routes.navigateToPickUpLocationList(context);
          }
        },
      ),
    );
  }

//==============================================================================
//============================= Language Implimentation ========================

  _showBottomSheet() async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10,
                  right: 10),
              child: Column(
                children: [
                  Center(child: CustomBottomSheet.bottomSheetHandle(context)),
                  CustomBottomSheet.bottomSheetLabel(
                    context,
                    'CHOOSE_LANGUAGE_LBL'.translate(context: context),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const ClampingScrollPhysics(), // disables bounce
                          itemCount: appLanguages.length,
                          itemBuilder: (context, index) {
                            return getLanguageTile(
                                appLanguage: appLanguages[index]);
                          },
                        ),
                      );
                    },
                  ),
                  Platform.isIOS
                      ? const Padding(padding: EdgeInsets.only(bottom: 20))
                      : const Padding(padding: EdgeInsets.zero)
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

//==============================================================================
//======================== Language List Generate ==============================
  Column getLanguageTile({required AppLanguage appLanguage}) => Column(
        children: [
          InkWell(
            onTap: () {
              context.read<LanguageCubit>().changeLanguage(
                    selectedLanguageCode: appLanguage.languageCode,
                    selectedLanguageName: appLanguage.languageName,
                    selectedSubLanguageName: appLanguage.subLanguageName,
                  );
              setState(() {
                selectedLanguageCode = appLanguage.languageCode;
              });
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  RadioGroup<String>(
                    groupValue: selectedLanguageCode,
                    onChanged: (String? val) {
                      if (val == null) return;
                      setState(() {
                        selectedLanguageCode = val;
                      });
                      context.read<LanguageCubit>().changeLanguage(
                            selectedLanguageCode: appLanguage.languageCode,
                            selectedLanguageName: appLanguage.languageName,
                            selectedSubLanguageName:
                                appLanguage.subLanguageName,
                          );
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: appLanguage.languageCode,
                          fillColor: const WidgetStatePropertyAll(Colors.red),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appLanguage.languageName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appLanguage.subLanguageName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
        ],
      );

//=================================== delete user dialog =======================
//==============================================================================

  deleteAccountDailog() async {
    await dialogAnimate(
      context,
      StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(circularBorderRadius5),
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //==================
                // when currentIndex == 0
                //==================
                currentIndex == 0
                    ? Text(
                        "Delete Account".translate(context: context),
                        style: Theme.of(this.context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container(),
                currentIndex == 0
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(),
                currentIndex == 0
                    ? Text(
                        'Your all return order request, ongoing orders, wallet amount and also your all data will be deleted. So you will not able to access this account further. We understand if you want you can create new account to use this application.'
                            .translate(
                          context: context,
                        ),
                        style: Theme.of(this.context)
                            .textTheme
                            .titleSmall!
                            .copyWith(),
                      )
                    : Container(),
                //==================
                // when currentIndex == 1
                //==================
                currentIndex == 1
                    ? Text(
                        "Please Verify Password".translate(context: context),
                        style: Theme.of(this.context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container(),
                currentIndex == 1
                    ? const SizedBox(
                        height: 25,
                      )
                    : Container(),
                currentIndex == 1
                    ? Container(
                        height: 53,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: lightWhite1,
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius10),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          style: const TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSize13),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(passFocus);
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: passwordController,
                          focusNode: passFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            verifyPassword = value;
                          },
                          onSaved: (String? value) {
                            verifyPassword = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 5,
                            ),
                            suffixIconConstraints: const BoxConstraints(
                                minWidth: 40, maxHeight: 20),
                            hintText:
                                "PASSHINT_LBL".translate(context: context),
                            hintStyle: const TextStyle(
                                color: grey,
                                fontWeight: FontWeight.bold,
                                fontSize: textFontSize13),
                            fillColor: lightWhite,
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    : Container(),
                //==================
                // when currentIndex == 2
                //==================

                currentIndex == 2
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
                //==================
                // when currentIndex == 2
                //==================
                // currentIndex == 3
                //     ? Center(
                //         child: Text(
                //           errorTrueMessage ??
                //
                //                   "something Error Please Try again...!")!,
                //         ),
                //       )
                //     : Container(),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  currentIndex == 0
                      ? TextButton(
                          child: Text(
                            'LOGOUTNO'.translate(context: context),
                            style: Theme.of(this.context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: lightBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        )
                      : Container(),
                  currentIndex == 0
                      ? TextButton(
                          child: Text(
                            'LOGOUTYES'.translate(context: context),
                            style: Theme.of(this.context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                currentIndex = 1;
                              },
                            );
                          },
                        )
                      : Container(),
                ],
              ),
              currentIndex == 1
                  ? TextButton(
                      child: Text(
                        "Delete Now".translate(context: context),
                        style: Theme.of(this.context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onPressed: () async {
                        setState(
                          () {
                            currentIndex = 2;
                          },
                        );
                        var mobile = await getPrefrence(Mobile);
                        await checkNetwork(mobile ?? "").then(
                          (value) {
                            setState(
                              () {
                                currentIndex = 0;
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Future<void> checkNetwork(
    String mobile,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      deleteAccountAPI(mobile);
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          if (mounted) {
            setState(
              () {
                isNetworkAvail = false;
              },
            );
          }
        },
      );
    }
  }

  Future<void> deleteAccountAPI(String mobile) async {
    var data = {"mobile": mobile, "password": verifyPassword};

    ApiBaseHelper().postAPICall(deleteSellerApi, data).then(
      (getdata) async {
        bool error = getdata['error'];
        String? msg = getdata['message'];
        if (!error) {
          currentIndex = 0;
          verifyPassword = "";
          passwordController.text = "";
          setSnackbar(msg!, context);
          clearUserSession(context);
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const Login(),
              ),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pop(context);
          currentIndex = 0;
          setState(() {});
          verifyPassword = "";
          passwordController.text = "";
          setSnackbar(msg!, context);
        }
      },
      onError: (error) {
        setSnackbar(
          error.toString(),
          context,
        );
      },
    );
  }
}
