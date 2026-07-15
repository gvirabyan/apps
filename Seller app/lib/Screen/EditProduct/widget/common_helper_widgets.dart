import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/editProductProvider.dart';
import 'package:sellermultivendor/Screen/MediaUpload/Media.dart';
import 'package:sellermultivendor/Widget/desing.dart';

/// Small helper widgets for Edit Product screen

/// Other Images upload widget
Widget otherImages(
  BuildContext context,
  String from,
  int pos,
  Function() onUpdate,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: black.withValues(alpha: 0.3),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    DesignConfiguration.setNewSvgPath(Assets.capa)),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Text(
                    'ENTER_YOUR_UPLOAD_HERE'.translate(context: context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: lightBlack, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Media(
                  from: from,
                  pos: pos,
                  type: "edit",
                ),
              ),
            ).then((value) => onUpdate());
          },
        ),
      ],
    ),
  );
}

/// Variant other images display widget
Widget variantOtherImageShow(
  EditProductProvider editProvider,
  int pos,
  BuildContext context,
  Function() onUpdate,
) {
  return editProvider.variationList.length == pos ||
          editProvider.variationList[pos].images == null ||
          editProvider.variationList[pos].images!.isEmpty
      ? otherImages(context, "variant", pos, onUpdate)
      : Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 130,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: editProvider.variationList[pos].images!.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return otherImages(context, "variant", pos, onUpdate);
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          right: 8.0,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius10),
                          child: Image.network(
                            editProvider.variationList[pos].images![i - 1],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          editProvider.variationList[pos].images!.removeAt(i);
                          try {
                            editProvider.variationList[pos].imageRelativePath!
                                .removeAt(i);
                          } catch (_) {}
                          onUpdate();
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                          child: const Icon(
                            Icons.clear,
                            size: 15,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
}
