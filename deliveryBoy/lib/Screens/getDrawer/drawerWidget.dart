import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Screens/Profile/profile.dart';
import 'package:deliveryboy_multivendor/Widget/desing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Helper/color.dart';
import '../../Helper/constant.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/translateVariable.dart';
import '../CashCollection/cash_collection.dart';
import '../Home/Widget/deleteAccountDialog.dart';
import '../Home/Widget/getHeading.dart';
import '../Home/Widget/getLanguageDialog.dart';
import '../Home/Widget/getLogOutDialog.dart';
import '../NotificationList/notification_lIst.dart';
import '../Privacy policy/privacy_policy.dart';
import '../WalletHistory/wallet_history.dart';

class GetDrawerWidget extends StatefulWidget {
  const GetDrawerWidget({Key? key}) : super(key: key);

  @override
  State<GetDrawerWidget> createState() => _GetDrawerWidgetState();
}

class _GetDrawerWidgetState extends State<GetDrawerWidget> {
  Widget _getDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        height: 1,
      ),
    );
  }

  setstate() {
    setState(() {});
  }

  Widget _getDrawerItem(String title, String img) {
    return ListTile(
      dense: true,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(circularBorderRadius100),
        child: Container(
          padding: EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: SvgPicture.asset(
            DesignConfiguration.setSvgPath(img),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: black,
          fontSize: textFontSize15,
        ),
      ),
      onTap: () {
        if (title == ChangeLanguage.translate(context: context)) {
          LanguageDialog.languageDialog(
            context,
            setState,
          );
        } else if (title == EDIT_PROFILE_LBL.translate(context: context)) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Profile(),
            ),
          ).then((_) => setState(() {}));
        } else if (title == "Delete Account".translate(context: context)) {
          DeleteAccountDialog.deleteAccountDailog(context, setstate);
        } else if (title == NOTIFICATION.translate(context: context)) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => NotificationList(),
            ),
          );
        } else if (title == LOGOUT.translate(context: context)) {
          LogOutDialog.logOutDailog(context);
        } else if (title == PRIVACY.translate(context: context)) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => PrivacyPolicy(
                title: PRIVACY.translate(context: context),
              ),
            ),
          );
        } else if (title == TERM.translate(context: context)) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => PrivacyPolicy(
                title: TERM.translate(context: context),
              ),
            ),
          );
        } else if (title == WALLET.translate(context: context)) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => WalletHistory(
                isBack: true,
              ),
            ),
          );
        } else if (title == CASH_COLL.translate(context: context)) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => CashCollection(
                isBack: true,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        color: white,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              GetHeading(update: setState),
              SizedBox(
                height: 10,
              ),
              _getDrawerItem(
                  EDIT_PROFILE_LBL.translate(context: context), Assets.profile),
              _getDrawerItem(ChangeLanguage.translate(context: context),
                  Assets.changeLanguage),
              _getDivider(),
              _getDrawerItem(
                  PRIVACY.translate(context: context), Assets.privacyPolicy),
              _getDrawerItem(
                  TERM.translate(context: context), Assets.termsConditions),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDivider(),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDrawerItem("Delete Account".translate(context: context),
                      Assets.delete),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDrawerItem(
                      LOGOUT.translate(context: context), Assets.logout),
            ],
          ),
        ),
      ),
    );
  }
}
