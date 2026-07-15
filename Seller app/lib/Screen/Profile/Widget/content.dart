import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Screen/Map/map.dart';
import 'package:sellermultivendor/Screen/Profile/Profile.dart';
import 'package:sellermultivendor/Screen/Profile/Widget/commonfield.dart';
import 'package:sellermultivendor/Screen/Profile/Widget/deliverabilitySection.dart';
import 'package:sellermultivendor/Widget/validation.dart';

class Content extends StatelessWidget {
  final Function setStateNow;
  const Content({super.key, required this.setStateNow});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: profileProvider!.formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: "NAME_LBL".translate(context: context)),
          CommonField(
            controller: profileProvider!.nameC,
            labelText: "NAME_LBL".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateUserName(val, context),
          ),
          CommonText(text: "MOBILEHINT_LBL".translate(context: context)),
          CommonField(
            controller: profileProvider!.mobileC,
            labelText: "MOBILEHINT_LBL".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateMob(val, context),
          ),
          CommonText(text: "Email".translate(context: context)),
          CommonField(
            controller: profileProvider!.emailC,
            labelText: "Email".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateMob(val, context),
          ),
          CommonText(text: "Address".translate(context: context)),
          CommonField(
            controller: profileProvider!.addressC,
            labelText: "Address".translate(context: context),
            isObscureText: false,
            maxlines: 3,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: "StoreName".translate(context: context)),
          CommonField(
            controller: profileProvider!.storenameC,
            labelText: "StoreName".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: "StoreURL".translate(context: context)),
          CommonField(
            controller: profileProvider!.storeurlC,
            labelText: "StoreURL".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: "Description".translate(context: context)),
          CommonField(
            controller: profileProvider!.storeDescC,
            labelText: "Description".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: "Latitude".translate(context: context)),
          CommonField(
            controller: profileProvider!.latitututeC,
            labelText: "Latitude".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
            suffixIcon: IconButton(
              onPressed: () async {
                LocationPermission permission;
                permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                }
                Position position = await Geolocator.getCurrentPosition(
                  locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.high,
                  ),
                );
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MapScreen(
                      latitude: position.latitude,
                      longitude: position.longitude,
                      from: true,
                    ),
                  ),
                ).then((value) {
                  profileProvider!.latitututeC!.text =
                      profileProvider!.latitutute!;
                  profileProvider!.longituteC!.text =
                      profileProvider!.longitude!;
                  setStateNow;
                });
              },
              icon: const Icon(Icons.my_location, color: red),
            ),
          ),
          CommonText(text: "Longitude".translate(context: context)),
          CommonField(
            controller: profileProvider!.longituteC,
            labelText: "Longitude".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: "TaxName".translate(context: context)),
          CommonField(
            controller: profileProvider!.taxnameC,
            labelText: "TaxName".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(text: "TaxNumber".translate(context: context)),
          CommonField(
            controller: profileProvider!.taxnumberC,
            labelText: "TaxNumber".translate(context: context),
            isObscureText: false,
            validator: (val) => StringValidation.validateField(val, context),
          ),
          CommonText(
            text: "PRODUCT_LOW_STOCK_LIMIT".translate(context: context),
          ),
          CommonField(
            controller: profileProvider!.lowStockLimitC,
            labelText: "PRODUCT_LOW_STOCK_LIMIT".translate(context: context),
            isObscureText: false,
            // validator: (val) => StringValidation.validateField(val, context),
          ),
          DeliverabilitySection(setStateNow: setStateNow),
          CommonText(text: "Authorized Signature".translate(context: context)),
        ],
      ),
    );
  }
}
