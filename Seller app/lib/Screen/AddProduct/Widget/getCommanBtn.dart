import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/ProductDescription.dart';
import '../../../Widget/snackbar.dart';
import '../../MediaUpload/Media.dart';
import '../Add_Product.dart';

getCommonButtonAdd(
  String title,
  int index,
  Function setState,
  BuildContext context,
) {
  return InkWell(
    onTap: () {
      if (index == 1) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                const Media(from: "main", type: "add", pos: -1),
          ),
        ).then((value) => setState());
      } else if (index == 2) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                const Media(from: "other", pos: 0, type: "add"),
          ),
        ).then((value) => setState());
      } else if (index == 9) {
        Navigator.push(
          context,
          CupertinoPageRoute<String>(
            builder: (context) => ProductDescription(
              addProvider!.extraDescription ?? "",
              "Product Extra Description".translate(context: context),
            ),
          ),
        ).then((changed) {
          if (changed?.trim().isNotEmpty ?? false) {
            addProvider!.setExtraDescription(changed);
          }
          //addProvider!.extraDescription = changed;
        });
      } else if (index == 4) {
        if (addProvider!.simpleProductPriceController.text.isEmpty) {
          setSnackbar(
            "Please enter product price".translate(context: context),
            context,
          );
        } else if (addProvider!
            .simpleProductSpecialPriceController
            .text
            .isEmpty) {
          addProvider!.simpleProductSaveSettings = true;
          setSnackbar(
            "Setting saved successfully".translate(context: context),
            context,
          );
          setState();
        } else if (double.parse(addProvider!.simpleproductPrice!) <
            double.parse(addProvider!.simpleproductSpecialPrice!)) {
          setSnackbar(
            "Special price must be less than original price".translate(
              context: context,
            ),
            context,
          );
        } else {
          addProvider!.simpleProductSaveSettings = true;
          setSnackbar(
            "Setting saved successfully".translate(context: context),
            context,
          );
          setState(() {});
        }
      } else if (index == 5) {
        if (addProvider!.isStockSelected != null &&
            addProvider!.isStockSelected == true &&
            (addProvider!.variountProductTotalStock.text.isEmpty ||
                addProvider!.stockStatus.isEmpty)) {
          setSnackbar(
            "Please enter all details".translate(context: context),
            context,
          );
        } else {
          addProvider!.variantProductProductLevelSaveSettings = true;
          setSnackbar(
            "Setting saved successfully".translate(context: context),
            context,
          );
          setState(() {});
        }
      } else if (index == 6) {
        addProvider!.variantProductVariableLevelSaveSettings = true;
        setSnackbar(
          "Setting saved successfully".translate(context: context),
          context,
        );
        setState(() {});
      } else if (index == 8) {
        if (addProvider!.digitalPriceController.text.isEmpty) {
          setSnackbar(
            "Please enter product price".translate(context: context),
            context,
          );
        } else if (addProvider!.digitalSpecialController.text.isEmpty) {
          addProvider!.digitalProductSaveSettings = true;
          setSnackbar(
            "Setting saved successfully".translate(context: context),
            context,
          );
          setState();
        } else if (double.parse(addProvider!.digitalPriceController.text) <
            double.parse(addProvider!.digitalSpecialController.text)) {
          setSnackbar(
            "Special price must be less than original price".translate(
              context: context,
            ),
            context,
          );
        } else {
          addProvider!.digitalProductSaveSettings = true;
          setSnackbar(
            "Setting saved successfully".translate(context: context),
            context,
          );
          setState(() {});
        }
      }
    },
    child: index == 1 || index == 2
        ? Container(
            // margin: EdgeInsetsDirectional.only(top: 15),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: black.withValues(alpha: 0.3)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    '${'ENTER_YOUR'.translate(context: context)} $title ${'HERE'.translate(context: context)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: lightBlack,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          )
        :
          // child:
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              color: primary,
            ),
            // height: 35,
            child: Center(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: textFontSize16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
  );
}

uploadedOtherImageShow(Function setState) {
  return addProvider!.otherImageUrl.isEmpty
      ? Container()
      : SizedBox(
          width: double.infinity,
          height: 130,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addProvider!.otherPhotos.length,
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
                          addProvider!.otherImageUrl[i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        addProvider!.otherPhotos.removeAt(i);
                        addProvider!.otherImageUrl.removeAt(i);
                        setState();
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
