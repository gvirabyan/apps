import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/Attribute Models/AttributeModel/AttributesModel.dart';
import 'package:sellermultivendor/Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import 'package:sellermultivendor/Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import 'package:sellermultivendor/Provider/editProductProvider.dart';
import 'package:sellermultivendor/Widget/FilterChips.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'getCommannWidget.dart';

/// Attribute Dialog - Shows modal bottom sheet for selecting attributes
Future<void> showAttributeDialog(
  BuildContext context,
  EditProductProvider editProvider,
  int pos,
  Function setState,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          editProvider.taxesState = setStater;
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circularBorderRadius25),
                topRight: Radius.circular(circularBorderRadius25),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
                            "Select Attribute".translate(context: context),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: primary),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: lightBlack),
                    editProvider.suggessionisNoData
                        ? DesignConfiguration.getNoItem(context)
                        : SizedBox(
                            width: double.maxFinite,
                            height: editProvider.attributeSetList.isNotEmpty
                                ? MediaQuery.of(context).size.height * 0.3
                                : 0,
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: editProvider.attributeSetList.length,
                                itemBuilder: (context, index) {
                                  List<AttributeModel> attrList = [];

                                  AttributeSetModel item =
                                      editProvider.attributeSetList[index];

                                  for (int i = 0;
                                      i < editProvider.attributesList.length;
                                      i++) {
                                    if (item.id ==
                                        editProvider
                                            .attributesList[i].attributeSetId) {
                                      attrList
                                          .add(editProvider.attributesList[i]);
                                    }
                                  }
                                  return Material(
                                    child: StickyHeaderBuilder(
                                      builder: (BuildContext context,
                                          double stuckAmount) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      circularBorderRadius7)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 2),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            editProvider.attributeSetList[index]
                                                    .name ??
                                                '',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      },
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List<int>.generate(
                                            attrList.length, (i) => i).map(
                                          (item) {
                                            return InkWell(
                                              onTap: () {
                                                setState(
                                                  () {
                                                    editProvider
                                                            .attrController[pos]
                                                            .text =
                                                        attrList[item].name!;
                                                    editProvider
                                                            .attributeIndiacator =
                                                        pos + 1;
                                                    if (!editProvider.attrId
                                                        .contains(int.parse(
                                                            attrList[item]
                                                                .id!))) {
                                                      editProvider.attrId.add(
                                                          int.parse(
                                                              attrList[item]
                                                                  .id!));
                                                      Navigator.pop(context);
                                                    } else {
                                                      setSnackbar(
                                                        "Already inserted.."
                                                            .translate(
                                                                context:
                                                                    context),
                                                        context,
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: double.maxFinite,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  attrList[item].name ?? '',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/// Add Attribute Value Dialog - Shows bottom sheet for selecting attribute values
Future<void> showAddAttributeValueDialog(
  BuildContext context,
  List<AttributeValueModel> selected,
  List<AttributeValueModel> searchRange,
  String attributeId,
  Function update,
  bool fromAdd,
) async {
  await showModalBottomSheet<List<AttributeValueModel>>(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(circularBorderRadius10),
        topRight: Radius.circular(circularBorderRadius10),
      ),
    ),
    enableDrag: true,
    context: context,
    builder: (context) {
      return SizedBox(
        height: 200 + MediaQuery.of(context).viewPadding.bottom,
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Select Attribute Value".translate(context: context),
                          style: const TextStyle(
                            fontSize: textFontSize18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return filterChipWidget(
                    chipName: searchRange[index],
                    selectedList: selected,
                    update: update,
                    fromAdd: fromAdd,
                  );
                },
                childCount: searchRange.length,
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Add Attribute Widget - Card widget for adding and managing attributes
Widget buildAttributeCard(
  BuildContext context,
  EditProductProvider editProvider,
  int pos,
  double width,
  Function setState,
  Function update,
) {
  final result = editProvider.attributesList
      .where((element) => element.name == editProvider.attrController[pos].text)
      .toList();
  final attributeId = result.isEmpty ? "" : result.first.id;

  return Card(
    color: lightWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(circularBorderRadius10),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getPrimaryCommanText(
                  "Select Attribute".translate(context: context), true),
              Row(
                children: [
                  Checkbox(
                    value: editProvider.variationBoolList[pos],
                    onChanged: (bool? value) {
                      setState(
                        () {
                          editProvider.variationBoolList[pos] = value ?? false;
                        },
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      // Removing from everywhere (try-catches are for safety when attributes are saved)
                      try {
                        editProvider.finalAttList.removeAt(pos);
                      } catch (_) {}
                      try {
                        editProvider.attrId.removeAt(pos);
                      } catch (_) {}
                      try {
                        editProvider.tempAttList.removeAt(pos);
                      } catch (_) {}
                      editProvider.attrController[pos].dispose();
                      editProvider.variationBoolList.removeAt(pos);
                      editProvider.attrController.removeAt(pos);
                      editProvider.selectedAttributeValues[attributeId!] = [];
                      editProvider.attributeIndiacator =
                          editProvider.attrController.length;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete_outline_sharp,
                      color: primary,
                    ),
                  ),
                ],
              )
            ],
          ),
          getCommanSizedBox(),
          TextFormField(
            textAlign: TextAlign.center,
            readOnly: true,
            onTap: () {
              showAttributeDialog(context, editProvider, pos, setState);
            },
            controller: editProvider.attrController[pos],
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: black,
              fontWeight: FontWeight.normal,
            ),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: white,
              hintText: "Select Attributes".translate(context: context),
              hintStyle: const TextStyle(
                color: grey,
                fontWeight: FontWeight.normal,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 40, maxHeight: 20),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(circularBorderRadius7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: lightWhite),
                borderRadius: BorderRadius.circular(circularBorderRadius8),
              ),
            ),
          ),
          getCommanSizedBox(),
          getCommanSizedBox(),
          GestureDetector(
            onTap: () {
              final attributeValues = editProvider.attributesValueList
                  .where((element) => element.attributeId == attributeId)
                  .toList();

              showAddAttributeValueDialog(
                  context,
                  editProvider.selectedAttributeValues[attributeId]!,
                  attributeValues,
                  attributeId!,
                  update,
                  false);
            },
            child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                  color: white,
                ),
                constraints: const BoxConstraints(
                  minHeight: 50,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      "Add attribute value".translate(context: context),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: textFontSize16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )),
          ),
          getCommanSizedBox(),
          if ((editProvider.selectedAttributeValues[attributeId!] ?? [])
              .isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: editProvider.selectedAttributeValues[attributeId]!
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius10),
                          color: primary,
                          border: Border.all(color: black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Text(
                            value.value ?? '',
                            style: const TextStyle(
                              color: white,
                              fontSize: textFontSize12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    ),
  );
}
