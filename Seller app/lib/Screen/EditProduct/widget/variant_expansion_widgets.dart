import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/editProductProvider.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/variantStockStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getVariantInputField.dart';
import 'common_helper_widgets.dart';
import 'getCommannWidget.dart';

/// Build Expandable Content for Variant - Price, Special Price, Weight
List<Widget> buildExpandableContent(
  int pos,
  BuildContext context,
  EditProductProvider editProvider,
) {
  List<Widget> columnContent = [];

  columnContent.add(
    variantProductPrice(pos, editProvider),
  );
  columnContent.add(
    variantProductSpecialPrice(pos, editProvider),
  );
  columnContent.add(
    variantProductWeight(pos, editProvider),
  );
  return columnContent;
}

/// Build Expandable Content 2 for Variant - Height, Breadth, Length
List<Widget> buildExpandableContent2(
  int pos,
  BuildContext context,
  EditProductProvider editProvider,
) {
  List<Widget> columnContent2 = [];
  columnContent2.add(
    variantProductHeight(pos, editProvider),
  );
  columnContent2.add(
    variantProductBreadth(pos, editProvider),
  );
  columnContent2.add(
    variantProductLength(pos, editProvider),
  );

  return columnContent2;
}

/// Build Expandable Content 3 for Variant - SKU, Stock, Images
List<Widget> buildExpandableContent3(
  int pos,
  BuildContext context,
  EditProductProvider editProvider,
  double width,
  Function update,
  Function() onUpdate,
) {
  List<Widget> columnContent = [];
  columnContent.add(
    editProvider.productType == 'variable_product' &&
            editProvider.variantStockLevelType == "variable_level" &&
            editProvider.isStockSelected != null &&
            editProvider.isStockSelected == true
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getCommanSizedBoxWidth(),
                  Expanded(
                      child: variableVariableSKU(
                          pos, editProvider, width, context)),
                  getCommanSizedBox(),
                  Expanded(
                      child: variantVariableTotalstock(
                          pos, editProvider, width, context)),
                  getCommanSizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getPrimaryCommanText(
                    "Stock Status :".translate(context: context), true),
              ),
              variantStockStatusSelect(pos, editProvider, context, update),
              getCommanSizedBox()
            ],
          )
        : Container(),
  );
  columnContent.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: getPrimaryCommanText(
          "Other Images".translate(context: context), true)));

  columnContent
      .add(variantOtherImageShow(editProvider, pos, context, onUpdate));
  return columnContent;
}

/// Variant Product Price Input Field
Widget variantProductPrice(int pos, EditProductProvider editProvider) {
  return VariantInputField(
    label: "PRICE_LBL",
    initialValue: editProvider.variationList[pos].price,
    onChanged: (String? value) {
      editProvider.variationList[pos].price = value;
    },
    keyboardType: TextInputType.number,
    useUnderlineBorder: true,
  );
}

/// Variant Product Special Price Input Field
Widget variantProductSpecialPrice(int pos, EditProductProvider editProvider) {
  return VariantInputField(
    label: "Special Price",
    initialValue: editProvider.variationList[pos].disPrice,
    onChanged: (String? value) {
      editProvider.variationList[pos].disPrice = value;
    },
    keyboardType: TextInputType.number,
  );
}

/// Variant Product Height Input Field
Widget variantProductHeight(int pos, EditProductProvider editProvider) {
  return VariantInputField(
    label: "Height (cms)",
    initialValue: editProvider.variationList[pos].height,
    onChanged: (String? value) {
      editProvider.variationList[pos].height = value;
    },
    keyboardType: TextInputType.number,
  );
}

/// Variant Product Weight Input Field
Widget variantProductWeight(int pos, EditProductProvider editProvider) {
  return VariantInputField(
    label: "Weight (kg)",
    initialValue: editProvider.variationList[pos].weight,
    onChanged: (String? value) {
      editProvider.variationList[pos].weight = value;
    },
    keyboardType: TextInputType.number,
  );
}

/// Variant Product Breadth Input Field
Widget variantProductBreadth(int pos, EditProductProvider editProvider) {
  return VariantInputField(
    label: "Breadth (cms)",
    initialValue: editProvider.variationList[pos].breadth,
    onChanged: (String? value) {
      editProvider.variationList[pos].breadth = value;
    },
    keyboardType: TextInputType.number,
  );
}

/// Variant Product Length Input Field
Widget variantProductLength(int pos, EditProductProvider editProvider) {
  return VariantInputField(
    label: "Length (cms)",
    initialValue: editProvider.variationList[pos].length,
    onChanged: (String? value) {
      editProvider.variationList[pos].length = value;
    },
    keyboardType: TextInputType.number,
  );
}

/// Variant Stock Status Selector
Widget variantStockStatusSelect(
  int pos,
  EditProductProvider editProvider,
  BuildContext context,
  Function update,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          border: Border.all(
            color: grey2,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editProvider.variationList[pos].stockStatus == '1'
                        ? "In Stock".translate(context: context)
                        : "Out Of Stock".translate(context: context),
                  )
                ],
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: primary,
            )
          ],
        ),
      ),
      onTap: () {
        variantStockStatusDialog("variable", pos, context, update);
      },
    ),
  );
}

/// Variant Total Stock Input Field
Widget variantVariableTotalstock(
  int pos,
  EditProductProvider editProvider,
  double width,
  BuildContext context,
) {
  return VariantInputField(
    label: "Total Stock",
    initialValue: editProvider.variationList[pos].stock,
    onChanged: (String? value) {
      editProvider.variationList[pos].stock = value;
    },
    keyboardType: TextInputType.number,
    width: width * 0.4,
    focusNode: editProvider.variountProductTotalStockFocus,
  );
}

/// Variant SKU Input Field
Widget variableVariableSKU(
  int pos,
  EditProductProvider editProvider,
  double width,
  BuildContext context,
) {
  return VariantInputField(
    label: "SKU",
    initialValue: editProvider.variationList[pos].sku,
    onChanged: (String? value) {
      editProvider.variationList[pos].sku = value;
    },
    width: width * 0.4,
    focusNode: editProvider.variountProductSKUFocus,
    onFieldSubmitted: (v) {
      FocusScope.of(context).requestFocus(editProvider.variountProductSKUFocus);
    },
  );
}
