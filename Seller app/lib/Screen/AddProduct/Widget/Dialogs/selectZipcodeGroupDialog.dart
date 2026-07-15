import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Provider/zipcodeProvider.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../Add_Product.dart';

selectZipcodeGroupDialog(BuildContext context, Function setState) async {
  // Clear search string and reload data before opening dialog
  context.read<ZipcodeProvider>().searchString = '';
  await context.read<ZipcodeProvider>().setZipCodeGroup(
    ProductAction.addProduct,
    isRefresh: true,
    ignoreSeller: '0',
    sellerId: context.read<SettingProvider>().CUR_USERID,
  );
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, setStater) {
            final zipcodeProvider = context.read<ZipcodeProvider>();

            ScrollController scrollController = ScrollController();
            scrollController.addListener(() async {
              if (scrollController.offset >=
                      scrollController.position.maxScrollExtent &&
                  !scrollController.position.outOfRange) {
                if (context.mounted) {
                  await zipcodeProvider.setZipCodeGroup(
                    ProductAction.addProduct,
                    isRefresh: false,
                    ignoreSeller: '0',
                    sellerId: context.read<SettingProvider>().CUR_USERID,
                  );
                  setStater(() {});
                }
              }
            });

            addProvider!.taxesState = setStater;
            Timer? debounce;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                  child: Text(
                    "SELECT_ZIPCODE_GROUP".translate(context: context),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: primary),
                  ),
                ),
                const Divider(color: lightBlack),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(circularBorderRadius5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: blarColor,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                    color: white,
                  ),
                  child: TextFormField(
                    initialValue: zipcodeProvider.searchString,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      fillColor: white,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        maxHeight: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: "SEARCH".translate(context: context),
                      hintStyle: TextStyle(
                        color: black.withValues(alpha: 0.3),
                        fontWeight: FontWeight.normal,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      // auto search after 1 second of typing
                      debounce = Timer(
                        const Duration(milliseconds: 1000),
                        () async {
                          zipcodeProvider.searchString = value;
                          await zipcodeProvider.setZipCodeGroup(
                            ProductAction.addProduct,
                            isRefresh: true,
                            ignoreSeller: '0',
                            sellerId: context
                                .read<SettingProvider>()
                                .CUR_USERID,
                          );
                          setStater(() {});
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: addProvider!.zipcodeSearchGroupsList.isEmpty
                      ? Center(
                          child: Text(
                            "NO_DATA_FOUND".translate(context: context),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(color: primary),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: () {
                              return addProvider!.zipcodeSearchGroupsList
                                  .asMap()
                                  .map(
                                    (index, element) => MapEntry(
                                      index,
                                      InkWell(
                                        onTap: () {
                                          final isSelected = addProvider!
                                              .selectedZipcodeGroups
                                              .any((g) => g.id == element.id);

                                          if (isSelected) {
                                            addProvider!.selectedZipcodeGroups
                                                .removeWhere(
                                                  (g) => g.id == element.id,
                                                );
                                          } else {
                                            addProvider!.selectedZipcodeGroups
                                                .add(element);
                                          }

                                          setState();
                                          setStater(() {});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                            vertical: 12.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: const BoxDecoration(
                                                  color: grey2,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 16,
                                                    width: 16,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          addProvider!
                                                              .selectedZipcodeGroups
                                                              .any(
                                                                (g) =>
                                                                    g.id ==
                                                                    element.id,
                                                              )
                                                          ? primary
                                                          : white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  () {
                                                    final zipcodesString =
                                                        element.zipcodes
                                                            .map(
                                                              (z) => z.zipcode,
                                                            )
                                                            .whereType<String>()
                                                            .join(', ');

                                                    return "${element.groupName ?? ''} (${"ZIPCODES".translate(context: context)}: $zipcodesString, ${"CHARGES".translate(context: context)}: ${element.deliveryCharge ?? ''})";
                                                  }(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList();
                            }(),
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        "CANCEL".translate(context: context),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        addProvider!.selectedZipcodeGroups.clear();
                        context.read<ZipcodeProvider>().searchString = '';
                        setState();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Ok".translate(context: context)),
                      onPressed: () {
                        context.read<ZipcodeProvider>().searchString = '';
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
