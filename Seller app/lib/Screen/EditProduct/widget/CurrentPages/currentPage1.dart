import 'package:flutter/cupertino.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage3.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getIconSelectionDesingWidget.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import 'package:sellermultivendor/Screen/AddProduct/Widget/languageTabBar.dart';
import '../../EditProduct.dart';

currentPage1(BuildContext context, Function update) {
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
      getEditLanguageTabBar(context, onChanged: () => update()),
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
        update,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText("Select Tax".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "Select Tax".translate(context: context),
        1,
        context,
        update,
      ),
      getCommanSizedBox(),
      editProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText(
              "Select Indicator".translate(context: context),
              false,
            )
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getIconSelectionDesing(
              "Select Indicator".translate(context: context),
              2,
              context,
              update,
            )
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      getPrimaryCommanText("Made In".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "Made In".translate(context: context),
        3,
        context,
        update,
      ),
      getCommanSizedBox(),
      editProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText('HSN Code'.translate(context: context), false)
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanInputTextField(
              'HSN Code'.translate(context: context),
              16,
              0.06,
              1,
              2,
              context,
            )
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
              "ShortDescription".translate(context: context),
              true,
            ),
          ),
        ],
      ),
      (editProvider!.sortDescription == "" ||
              editProvider!.sortDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (editProvider!.sortDescription == "" ||
              editProvider!.sortDescription == null)
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
                      editProvider!.sortDescription ?? "",
                      "Product Sort Description".translate(context: context),
                      productTitle: editProvider!.productName,
                      fieldType: 'short_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.sortDescription = changed;
                  }
                  update();
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
                      editProvider!.sortDescription ?? "",
                      "Product Sort Description".translate(context: context),
                      productTitle: editProvider!.productName,
                      fieldType: 'short_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.sortDescription = changed;
                  }
                  update();
                });
              },
            ),
    ],
  );
}
