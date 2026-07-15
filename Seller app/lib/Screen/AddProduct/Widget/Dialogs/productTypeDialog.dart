import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../Add_Product.dart';

productTypeDialog(
  BuildContext context,
  Function setState,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          addProvider!.taxesState = setStater;
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circularBorderRadius25),
                topRight: Radius.circular(circularBorderRadius25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Type".translate(context: context),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary),
                      ),
                    ],
                  ),
                ),
                const Divider(color: lightBlack),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addProvider!.currentSellectedProductIsPysical
                            ? InkWell(
                                onTap: () {
                                  addProvider!
                                          .variantProductVariableLevelSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductProductLevelSaveSettings =
                                      false;
                                  addProvider!.simpleProductSaveSettings =
                                      false;
                                  addProvider!.digitalProductSaveSettings =
                                      false;
                                  addProvider!.productType = 'simple_product';
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Simple Product"
                                              .translate(context: context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        addProvider!.currentSellectedProductIsPysical
                            ? InkWell(
                                onTap: () {
                                  //----reset----
                                  addProvider!
                                      .simpleProductPriceController.text = '';
                                  addProvider!
                                      .simpleProductSpecialPriceController
                                      .text = '';
                                  addProvider!.isStockSelected = false;

                                  //--------------set
                                  addProvider!
                                          .variantProductVariableLevelSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductProductLevelSaveSettings =
                                      false;
                                  addProvider!.simpleProductSaveSettings =
                                      false;
                                  addProvider!.digitalProductSaveSettings =
                                      false;
                                  addProvider!.productType = 'variable_product';
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Variable Product"
                                              .translate(context: context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        addProvider!.currentSellectedProductIsPysical
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  addProvider!.productType = 'digital_product';
                                  addProvider!.digitalProductSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductVariableLevelSaveSettings =
                                      false;
                                  addProvider!
                                          .variantProductProductLevelSaveSettings =
                                      false;
                                  addProvider!.simpleProductSaveSettings =
                                      false;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: const SizedBox(
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Digital Product',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
