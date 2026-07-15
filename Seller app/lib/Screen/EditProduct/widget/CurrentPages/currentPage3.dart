import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getIconSelectionDesingWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommonButton.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import 'package:sellermultivendor/Screen/AddProduct/Widget/languageTabBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../MediaUpload/Media.dart';
import '../../EditProduct.dart';

currentPage3(BuildContext context, Function setStateNow) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          getPrimaryCommanText(
            "Product Main Image".translate(context: context),
            true,
          ),
        ],
      ),
      editProvider!.productImage != '' ? getCommanSizedBox() : Container(),
      editProvider!.productImage != '' ? getCommanSizedBox() : Container(),
      Row(
        children: [
          getCommonButton(
            "Upload".translate(context: context),
            1,
            setStateNow,
            context,
          ),
          getCommanSizedBoxWidth(),
          editProvider!.productImage != ''
              ? selectedMainImageShow()
              : Container(),
        ],
      ),
      getCommanSizedBox(),
      Row(
        children: [
          getPrimaryCommanText(
            "Product Other Images".translate(context: context),
            true,
          ),
        ],
      ),
      getCommanSizedBox(),
      Row(
        children: [
          getCommonButton(
            "Upload".translate(context: context),
            2,
            setStateNow,
            context,
          ),
          getCommanSizedBoxWidth(),
          Expanded(
            flex: 3,
            child: editProvider!.showOtherImages.isNotEmpty
                ? uploadedOtherImageShow(setStateNow)
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
        setStateNow,
      ),
      getCommanSizedBox(),
      (editProvider!.selectedTypeOfVideo == 'vimeo' ||
              editProvider!.selectedTypeOfVideo == 'youtube')
          ? getCommanInputTextField(
              editProvider!.selectedTypeOfVideo == 'vimeo'
                  ? "Paste Vimeo Video link / url ...!".translate(
                      context: context,
                    )
                  : editProvider!.selectedTypeOfVideo == 'youtube'
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
          : editProvider!.selectedTypeOfVideo == 'self_hosted'
          ? Column(
              children: [
                videoUpload(context, setStateNow),
                selectedVideoShow(),
              ],
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
      getEditLanguageTabBar(context, onChanged: () => setStateNow()),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
              "Product Description".translate(context: context),
              true,
            ),
          ),
        ],
      ),
      (editProvider!.description == "" || editProvider!.description == null)
          ? Container()
          : getCommanSizedBox(),
      (editProvider!.description == "" || editProvider!.description == null)
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
                      editProvider!.description ?? "",
                      "Product Description".translate(context: context),
                      productTitle: editProvider!.productName,
                      fieldType: 'description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.description = changed;
                  }
                  setStateNow();
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
                child: Container(child: getDescription(1)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      editProvider!.description ?? "",
                      "Product Description".translate(context: context),
                      productTitle: editProvider!.productName,
                      fieldType: 'description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.description = changed;
                  }
                  setStateNow();
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
      (editProvider!.extraDescription == "" ||
              editProvider!.extraDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (editProvider!.extraDescription == "" ||
              editProvider!.extraDescription == null)
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
                      editProvider!.extraDescription ?? "",
                      "Product Extra Description".translate(context: context),
                      productTitle: editProvider!.productName,
                      fieldType: 'extra_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.extraDescription = changed;
                  }
                  setStateNow();
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
                      editProvider!.extraDescription ?? "",
                      "Product Extra Description".translate(context: context),
                      productTitle: editProvider!.productName,
                      fieldType: 'extra_description',
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.extraDescription = changed;
                  }
                  setStateNow();
                });
              },
            ),
    ],
  );
}

selectedMainImageShow() {
  return editProvider!.productImage == ''
      ? Container()
      : ClipRRect(
          borderRadius: BorderRadius.circular(circularBorderRadius10),
          child: Image.network(
            editProvider!.productImageUrl!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
}

uploadedOtherImageShow(Function update) {
  return editProvider!.showOtherImages.isEmpty
      ? Container()
      : SizedBox(
          width: double.infinity,
          height: 130,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: editProvider!.showOtherImages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        // right: 8.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          circularBorderRadius10,
                        ),
                        child: Image.network(
                          editProvider!.showOtherImages[i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        editProvider!.showOtherImages.removeAt(i);
                        editProvider!.otherPhotos.removeAt(i);
                        update();
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                        child: const Icon(Icons.clear, size: 15, color: white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
}

videoUpload(BuildContext context, Function update) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Video * ".translate(context: context)),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(circularBorderRadius5),
            ),
            width: 90,
            height: 40,
            child: Center(
              child: Text(
                "Upload".translate(context: context),
                style: const TextStyle(color: white),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    const Media(from: "video", pos: 0, type: "edit"),
              ),
            ).then((value) => update());
          },
        ),
      ],
    ),
  );
}

selectedVideoShow() {
  return editProvider!.uploadedVideoName == ''
      ? Container()
      : SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Text(editProvider!.uploadedVideoName!)),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        );
}

getDescription(int fromdescription) {
  return Container(
    decoration: BoxDecoration(
      color: grey1,
      borderRadius: BorderRadius.circular(circularBorderRadius5),
      border: Border.all(color: black.withValues(alpha: 0.1)),
    ),
    width: width,
    child: Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: HtmlWidget(
        fromdescription == 1
            ? editProvider!.description ?? ""
            : fromdescription == 2
            ? editProvider!.sortDescription ?? ""
            : editProvider!.extraDescription ?? "",
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
