import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/dialogAnimate.dart';
import '../../../Widget/networkAvailablity.dart';
import '../home.dart';

class DeleteAccountDialog {
  static deleteAccountDailog(
    BuildContext context,
    Function update,
  ) async {
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
                homeProvider!.currentIndex == 0
                    ? Text(
                        "Delete Account".translate(context: context),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container(),
                homeProvider!.currentIndex == 0
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(),
                homeProvider!.currentIndex == 0
                    ? Text(
                        'Your all return order request, ongoing orders, wallet amount and also your all data will be deleted. So you will not able to access this account further. We understand if you want you can create new account to use this application.'
                            .translate(
                          context: context,
                        ),
                        style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(),
                      )
                    : Container(),
                //==================
                // when currentIndex == 1
                //==================
                homeProvider!.currentIndex == 1
                    ? Text(
                        "Please Verify Password".translate(context: context),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container(),
                homeProvider!.currentIndex == 1
                    ? const SizedBox(
                        height: 25,
                      )
                    : Container(),
                homeProvider!.currentIndex == 1
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
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSize13),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(homeProvider!.passFocus);
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: homeProvider!.passwordController,
                          focusNode: homeProvider!.passFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            homeProvider!.verifyPassword = value;
                          },
                          onSaved: (String? value) {
                            homeProvider!.verifyPassword = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 5,
                            ),
                            suffixIconConstraints: const BoxConstraints(
                                minWidth: 40, maxHeight: 20),
                            hintText: 'Password'.translate(context: context),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSize13,
                            ),
                            fillColor: lightWhite,
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    : Container(),
                //==================
                // when currentIndex == 2
                //==================

                homeProvider!.currentIndex == 2
                    ? const Center(child: CircularProgressIndicator())
                    : Container(),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  homeProvider!.currentIndex == 0
                      ? TextButton(
                          child: Text(
                            "No".translate(context: context),
                            style: Theme.of(context)
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
                  homeProvider!.currentIndex == 0
                      ? TextButton(
                          child: Text(
                            "Yes".translate(context: context),
                            style: Theme.of(context)
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
                                homeProvider!.currentIndex = 1;
                              },
                            );
                          },
                        )
                      : Container(),
                ],
              ),
              homeProvider!.currentIndex == 1
                  ? TextButton(
                      child: Text(
                        "Delete Now".translate(context: context),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onPressed: () async {
                        homeProvider!.currentIndex = 2;

                        await checkNetwork(
                          homeProvider!.mobileNumber ?? "",
                          update,
                          context,
                        ).then(
                          (value) {
                            homeProvider!.currentIndex = 0;
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

  static Future<void> checkNetwork(
    String mobile,
    Function update,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      homeProvider!.deleteAccountAPI(mobile, update, context);
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await homeProvider!.buttonController!.reverse();
          update(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }
}
