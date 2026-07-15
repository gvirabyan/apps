import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../Add_Product.dart';
import '../ImagesWidgets.dart';
import '../getCommanBtn.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getIconSelectionDesingWidget.dart';
import '../languageTabBar.dart';

currentPage3(BuildContext context, Function setState, Function updateCitys) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getPrimaryCommanText(
        "Product Main Image".translate(context: context),
        true,
      ),
      getCommanSizedBox(),
      Row(
        children: [
          getCommonButtonAdd(
            "Upload".translate(context: context),
            1,
            setState,
            context,
          ),
          getCommanSizedBoxWidth(),
          getCommanSizedBoxWidth(),
          addProvider!.productImage != ''
              ? selectedMainImageShow()
              : Container(),
        ],
      ),
      getCommanSizedBox(),
      getCommanSizedBox(),
      getPrimaryCommanText(
        "Product Other Images".translate(context: context),
        true,
      ),
      getCommanSizedBox(),
      Row(
        children: [
          getCommonButtonAdd(
            "Upload".translate(context: context),
            2,
            setState,
            context,
          ),
          getCommanSizedBoxWidth(),
          Expanded(
            flex: 3,
            child: addProvider!.otherImageUrl.isNotEmpty
                ? uploadedOtherImageShow(setState)
                : Container(),
          ),
        ],
      ),
      getCommanSizedBox(),
      getPrimaryCommanText(
        "Select Video Type".translate(context: context),
        false,
      ),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "not Selected Yet!(ex. Vimeo, Youtube)".translate(context: context),
        8,
        context,
        setState,
        updateCitys,
      ),
      getCommanSizedBox(),
      (addProvider!.selectedTypeOfVideo == 'vimeo' ||
              addProvider!.selectedTypeOfVideo == 'youtube')
          ? getCommanInputTextField(
              addProvider!.selectedTypeOfVideo == 'vimeo'
                  ? "Paste Vimeo Video link / url ...!".translate(
                      context: context,
                    )
                  : addProvider!.selectedTypeOfVideo == 'youtube'
                  ? "Paste Youtube Video link / url...!".translate(
                      context: context,
                    )
                  : "Self Hosted".translate(context: context),
              9,
              0.06,
              1,
              2,
              context,
            )
          : addProvider!.selectedTypeOfVideo == 'self_hosted'
          ? Column(
              children: [videoUpload(context, setState), selectedVideoShow()],
            )
          : Container(),
      getCommanSizedBox(),
      // Multilingual: language tabs governing Product Description and
      // Extra Description (per-language HTML content).
      getPrimaryCommanText(
        "Content language".translate(context: context),
        false,
      ),
      getCommanSizedBox(),
      getLanguageTabBar(context, onChanged: () => setState()),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
              'Product Description'.translate(context: context),
              true,
            ),
          ),
        ],
      ),
      (addProvider!.description == "" || addProvider!.description == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.description == "" || addProvider!.description == null)
          ? GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.description ?? "",
                      "Product Description".translate(context: context),
                      productTitle: addProvider!.productName,
                      fieldType: 'description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setDescription(changed);
                  }
                  setState();
                });
              }),
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(color: grey2, width: 1),
                ),
                width: width,
                child: SizedBox(
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                      right: 8,
                      bottom: 28,
                    ),
                    child: Text(
                      "Description".translate(context: context),
                      style: const TextStyle(color: lightBlack),
                    ),
                  ),
                ),
              ),
            )
          : GestureDetector(
              child: getDescription(1),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.description ?? "",
                      "Product Description".translate(context: context),
                      productTitle: addProvider!.productName,
                      fieldType: 'description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setDescription(changed);
                  }
                  setState();
                });
              },
            ),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
              "Extra Description".translate(context: context),
              true,
            ),
          ),
        ],
      ),
      (addProvider!.extraDescription == "" ||
              addProvider!.extraDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.extraDescription == "" ||
              addProvider!.extraDescription == null)
          ? GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(color: black.withValues(alpha: 0.1)),
                ),
                width: width,
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
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.extraDescription ?? "",
                      "Product Extra Description".translate(context: context),
                      productTitle: addProvider!.productName,
                      fieldType: 'extra_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.extraDescription = changed;
                  }
                  setState();
                });
              },
            )
          : GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(color: black.withValues(alpha: 0.1)),
                ),
                width: width,
                child: Container(child: getDescription(3)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.extraDescription ?? "",
                      "Product Extra Description".translate(context: context),
                      productTitle: addProvider!.productName,
                      fieldType: 'extra_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.extraDescription = changed;
                  }
                  setState();
                });
              },
            ),
    ],
  );
}

//==============================================================================
//=========================== Description ======================================

getDescription(int fromdescription) {
  return Container(
    decoration: BoxDecoration(
      color: grey1,
      borderRadius: BorderRadius.circular(circularBorderRadius5),
      border: Border.all(color: grey2, width: 1),
    ),
    width: width,
    child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: HtmlWidget(
        fromdescription == 1
            ? addProvider!.description ?? ""
            : fromdescription == 2
            ? addProvider!.sortDescription ?? ""
            : addProvider!.extraDescription ?? "",
        onErrorBuilder: (context, element, error) =>
            Text('$element error: $error'),
        onLoadingBuilder: (context, element, loadingProgress) =>
            const CircularProgressIndicator(),
        onTapUrl: (url) {
          launchUrl(Uri.parse(url));
          return true;
        },
        renderMode: RenderMode.column,
        textStyle: const TextStyle(fontSize: textFontSize14),
      ),
    ),
  );
}
