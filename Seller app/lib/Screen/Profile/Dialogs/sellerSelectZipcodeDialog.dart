import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/ZipCodesModel/ZipCodeModel.dart';
import '../../../Repository/zipcodeRepositry.dart';
import '../Profile.dart';

sellerSelectZipcodeDialog(BuildContext context, Function setState) async {
  List<ZipCodeModel> zipcodeList = [];
  List<ZipCodeModel> selectedZipcodes = [];
  int offset = 0;
  int total = 0;
  String searchString = '';

  // Load existing selected zipcodes from provider
  selectedZipcodes = List.from(profileProvider!.selectedZipcodesList);

  Future<void> loadData({bool isRefresh = true}) async {
    if (isRefresh) {
      offset = 0;
      zipcodeList.clear();
    }

    var result = await ZipcodeRepository.setZipCode(
      offset: offset,
      limit: perPage,
      search: searchString,
      skipAuth: true,
    );

    bool error = result['error'];
    if (!error) {
      total = int.parse(result["total"].toString());
      if (offset < total) {
        var data = result['data'];
        zipcodeList.addAll(
          (data as List).map((data) => ZipCodeModel.fromJson(data)).toList(),
        );
        offset = offset + perPage;
      }
    }
  }

  await loadData();

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, setStater) {
            ScrollController scrollController = ScrollController();
            scrollController.addListener(() async {
              if (scrollController.offset >=
                      scrollController.position.maxScrollExtent &&
                  !scrollController.position.outOfRange) {
                if (context.mounted && offset < total) {
                  await loadData(isRefresh: false);
                  setStater(() {});
                }
              }
            });

            Timer? debounce;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                  child: Text(
                    "Select ZipCode".translate(context: context),
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
                    initialValue: searchString,
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
                      debounce = Timer(
                        const Duration(milliseconds: 1000),
                        () async {
                          searchString = value;
                          await loadData(isRefresh: true);
                          setStater(() {});
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: zipcodeList.isEmpty
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
                            children: zipcodeList
                                .map(
                                  (element) => InkWell(
                                    onTap: () {
                                      final isSelected = selectedZipcodes.any(
                                        (z) => z.id == element.id,
                                      );

                                      if (isSelected) {
                                        selectedZipcodes.removeWhere(
                                          (z) => z.id == element.id,
                                        );
                                      } else {
                                        selectedZipcodes.add(element);
                                      }
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
                                                      selectedZipcodes.any(
                                                        (z) =>
                                                            z.id ==
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
                                              element.zipcode ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
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
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Ok".translate(context: context)),
                      onPressed: () {
                        // Save the list for API (IDs)
                        profileProvider!.selectedZipcodesList = selectedZipcodes;
                        // Save display value (zipcode values)
                        profileProvider!.serviceableZipcodes = selectedZipcodes
                            .map((z) => z.zipcode)
                            .join(', ');
                        setState();
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
