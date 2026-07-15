import 'package:flutter/cupertino.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import '../../Add_Product.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getIconSelectionDesingWidget.dart';
import '../languageTabBar.dart';
import 'currentPage3.dart';

currentPage1(BuildContext context, Function setState, Function updateCity) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Multilingual: language tabs for name / short description / tags
      // (and description / extra description on the description step).
      getPrimaryCommanText(
        "Content language".translate(context: context),
        false,
      ),
      getCommanSizedBox(),
      getLanguageTabBar(context, onChanged: () => setState()),
      getCommanSizedBox(),
      getPrimaryCommanText(
        "PRODUCTNAME_LBL".translate(context: context),
        false,
      ),
      getCommanSizedBox(),
      getCommanInputTextField(
        "PRODUCTHINT_TXT".translate(context: context),
        1,
        0.06,
        1,
        2,
        context,
      ),
      getCommanSizedBox(),
      Row(
        children: [
          getPrimaryCommanText("Tags".translate(context: context), false),
          const SizedBox(width: 10),
          Flexible(
            fit: FlexFit.loose,
            child: getSecondaryCommanText(
              "(These tags help you in search result)".translate(
                context: context,
              ),
            ),
          ),
        ],
      ),
      getCommanSizedBox(),
      getCommanInputTextField(
        "Type in some tags for example AC, Cooler, Flagship Smartphones, Mobiles, Sport etc.."
            .translate(context: context),
        3,
        0.06,
        1,
        2,
        context,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText("PRODUCT_TYPE".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "PRODUCT_TYPE".translate(context: context),
        15,
        context,
        setState,
        updateCity,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText("Select Tax".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "Select Tax".translate(context: context),
        1,
        context,
        setState,
        updateCity,
      ),
      getCommanSizedBox(),
      addProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText(
              "Select Indicator".translate(context: context),
              false,
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getIconSelectionDesing(
              "Select Indicator".translate(context: context),
              2,
              context,
              setState,
              updateCity,
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      getPrimaryCommanText("Made In".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "Made In".translate(context: context),
        3,
        context,
        setState,
        updateCity,
      ),
      getCommanSizedBox(),
      addProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText('HSN Code'.translate(context: context), false)
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanInputTextField(
              'HSN Code'.translate(context: context),
              16,
              0.06,
              1,
              2,
              context,
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: getPrimaryCommanText(
              "ShortDescription".translate(context: context),
              true,
            ),
          ),
        ],
      ),
      (addProvider!.sortDescription == "" ||
              addProvider!.sortDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.sortDescription == "" ||
              addProvider!.sortDescription == null)
          ? GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(color: black.withValues(alpha: 0.1)),
                ),
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 28,
                  ),
                  child: Text("Description".translate(context: context)),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.sortDescription ?? "",
                      "Product Sort Description".translate(context: context),
                      productTitle: addProvider!.productName,
                      fieldType: 'short_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setsortDescription(changed);
                  }
                  setState();
                });
              },
            )
          : GestureDetector(
              child: getDescription(2),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.sortDescription ?? "",
                      "Product Sort Description".translate(context: context),
                      productTitle: addProvider!.productName,
                      fieldType: 'short_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setsortDescription(changed);
                  }
                  setState();
                });
              },
            ),
    ],
  );
}
