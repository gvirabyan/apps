import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/editProductProvider.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/attribute_management.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/variant_expansion_widgets.dart';
import 'package:sellermultivendor/Screen/MediaUpload/Media.dart';
import 'getCommannWidget.dart';
import 'getCommonSwitch.dart';
import 'getIconSelectionDesingWidget.dart';

/// Attributes Section - Displays list of attributes for variable products
Widget buildAttributesSection(
  BuildContext context,
  EditProductProvider editProvider,
  double width,
  Function setState,
  Function update,
) {
  if (editProvider.curSelPos != 2 ||
      editProvider.productType != 'variable_product') {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Note : select checkbox if the attribute is to be used for variation"
            .translate(context: context),
      ),
      getCommanSizedBox(),
      for (int i = 0; i < editProvider.attrController.length; i++)
        buildAttributeCard(context, editProvider, i, width, setState, update),
    ],
  );
}

/// Variants List Section - Displays list of product variants with expansion tiles
Widget buildVariantsListSection(
  BuildContext context,
  EditProductProvider editProvider,
  double width,
  Function setState,
  Function update,
  Function() onUpdate,
) {
  if (editProvider.curSelPos != 2 || editProvider.variationList.isEmpty) {
    return Container();
  }

  return ListView.builder(
    itemCount: editProvider.row,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, i) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(circularBorderRadius5),
            border: Border.all(
              color: grey2,
              width: 1,
            ),
          ),
          child: ExpansionTile(
            textColor: Colors.green,
            title: Row(
              children: [
                for (int j = 0; j < editProvider.col!; j++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        editProvider.variationList[i].varient_value!
                            .split(',')[j],
                        style: const TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.delete_outline,
                      color: primary,
                    ),
                  ),
                  onTap: () {
                    editProvider.variationList.removeAt(i);
                    editProvider.row = editProvider.row - 1;
                    setState(() {});
                  },
                ),
              ],
            ),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCommanSizedBoxWidth(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:
                              buildExpandableContent(i, context, editProvider),
                        ),
                      ),
                      getCommanSizedBoxWidth(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:
                              buildExpandableContent2(i, context, editProvider),
                        ),
                      ),
                      getCommanSizedBoxWidth(),
                    ],
                  ),
                  ...buildExpandableContent3(
                      i, context, editProvider, width, update, onUpdate),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Simple Product Form Fields
Widget buildSimpleProductFields(
  BuildContext context,
  EditProductProvider editProvider,
  Function setStateNow,
  double width,
) {
  if (editProvider.productType != 'simple_product') {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getCommanSizedBox(),
      getCommanSizedBox(),
      // Price and Special Price
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    "PRICE_LBL".translate(context: context), true),
                const SizedBox(height: 5),
                getCommanInputTextField(" ", 10, 0.06, 0.44, 3, context),
              ],
            ),
          ),
          getCommanSizedBoxWidth(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    "Special Price".translate(context: context), true),
                const SizedBox(height: 5),
                getCommanInputTextField(" ", 11, 0.06, 0.44, 3, context),
              ],
            ),
          )
        ],
      ),
      getCommanSizedBox(),
      // Weight
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                "Weight (kg)".translate(context: context), true),
          ),
          Expanded(
            flex: 3,
            child: getCommanInputTextField(" ", 22, 0.06, 1, 3, context),
          ),
        ],
      ),
      getCommanSizedBox(),
      // Height
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                "Height (cms)".translate(context: context), true),
          ),
          Expanded(
            flex: 3,
            child: getCommanInputTextField(" ", 23, 0.06, 1, 3, context),
          ),
        ],
      ),
      getCommanSizedBox(),
      // Breadth
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                "Breadth (cms)".translate(context: context), true),
          ),
          Expanded(
            flex: 3,
            child: getCommanInputTextField(" ", 24, 0.06, 1, 3, context),
          ),
        ],
      ),
      getCommanSizedBox(),
      // Length
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                "Length (cms)".translate(context: context), true),
          ),
          Expanded(
            flex: 3,
            child: getCommanInputTextField(" ", 25, 0.06, 1, 3, context),
          ),
        ],
      ),
      getCommanSizedBox(),
    ],
  );
}

/// Stock Management Section for Simple Product
Widget buildSimpleProductStockSection(
  BuildContext context,
  EditProductProvider editProvider,
  Function setStateNow,
  Function setState,
) {
  if (editProvider.productType != 'simple_product' ||
      editProvider.isStockSelected != true) {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getPrimaryCommanText("SKU".translate(context: context), true),
                const SizedBox(height: 5),
                getCommanInputTextField(" ", 12, 0.06, 0.44, 2, context),
              ],
            ),
          ),
          getCommanSizedBoxWidth(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getPrimaryCommanText(
                    "Total Stock".translate(context: context), true),
                const SizedBox(height: 5),
                getCommanInputTextField(" ", 13, 0.06, 0.44, 3, context),
              ],
            ),
          ),
        ],
      ),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "Select Stock Status".translate(context: context),
        10,
        context,
        setStateNow,
      ),
    ],
  );
}

/// Digital Product Form Fields
Widget buildDigitalProductFields(
  BuildContext context,
  EditProductProvider editProvider,
  Function setState,
) {
  if (editProvider.productType != 'digital_product') {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Price
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                "PRICE_LBL".translate(context: context), true),
          ),
          Expanded(
            flex: 3,
            child: getCommanInputTextField(" ", 17, 0.06, 1, 3, context),
          ),
        ],
      ),
      getCommanSizedBox(),
      // Special Price
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                "Special Price".translate(context: context), true),
          ),
          Expanded(
            flex: 3,
            child: getCommanInputTextField(" ", 18, 0.06, 1, 3, context),
          ),
        ],
      ),
      getCommanSizedBox(),
      // Download allowed switch
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText("Is Download allowed?", true),
          ),
          getCommanSwitch(5, setState),
        ],
      ),
      getCommanSizedBox(),
      // Download link type section
      if (editProvider.digitalProductDownloaded)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getPrimaryCommanText('Download Link Type', false),
            getCommanSizedBox(),
            getIconSelectionDesing(
              "Select Type",
              14,
              context,
              setState,
            ),
            if (editProvider.selectedDigitalProductTypeOfDownloadLink ==
                'self_hosted') ...[
              getCommanSizedBox(),
              getCommanSizedBox(),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(circularBorderRadius7),
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
                      builder: (context) => const Media(
                        from: "archive,document",
                        pos: 0,
                        type: "edit",
                      ),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ],
            if (editProvider.selectedDigitalProductTypeOfDownloadLink ==
                    'self_hosted' &&
                editProvider.digitalProductNamePathNameForSelectedFile != '')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.file_open_rounded),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        editProvider.digitalProductNamePathNameForSelectedFile,
                        maxLines: 10,
                        softWrap: true,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (editProvider.selectedDigitalProductTypeOfDownloadLink ==
                'Add Link') ...[
              getCommanSizedBox(),
              getPrimaryCommanText('Digital Product Link', false),
              getCommanSizedBox(),
              getCommanInputTextField(
                'Paste digital product link or URL here',
                19,
                0.06,
                1,
                2,
                context,
              ),
            ],
          ],
        ),
    ],
  );
}

/// Variable Product Stock Management Section
Widget buildVariableProductStockSection(
  BuildContext context,
  EditProductProvider editProvider,
  Function setStateNow,
) {
  if (editProvider.productType != 'variable_product' ||
      editProvider.isStockSelected != true) {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getPrimaryCommanText(
          "Choose Stock Management Type".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "Select Stock Status".translate(context: context),
        11,
        context,
        setStateNow,
      ),
      if (editProvider.variantStockLevelType == "product_level")
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getCommanSizedBox(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getPrimaryCommanText(
                          "SKU".translate(context: context), true),
                      const SizedBox(height: 5),
                      getCommanInputTextField(" ", 14, 0.06, 0.44, 2, context),
                    ],
                  ),
                ),
                getCommanSizedBoxWidth(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getPrimaryCommanText(
                          "Total Stock".translate(context: context), true),
                      const SizedBox(height: 5),
                      getCommanInputTextField(" ", 15, 0.06, 0.44, 3, context),
                    ],
                  ),
                ),
              ],
            ),
            getCommanSizedBox(),
            getPrimaryCommanText(
                "STOCK_STATUS".translate(context: context), false),
            getCommanSizedBox(),
            getIconSelectionDesing(
              "Select Stock Status".translate(context: context),
              12,
              context,
              setStateNow,
            ),
          ],
        ),
    ],
  );
}
