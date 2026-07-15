import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Repository/cityListRepository.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/CityModel/CityGroupModel.dart';
import '../../../Widget/parameterString.dart';
import '../Profile.dart';

sellerSelectCityGroupDialog(BuildContext context, Function setState) async {
  final isGroupWise =
      AppSettingsRepository.appSettings.productDeliverabilityType ==
      "group_wise";

  if (isGroupWise) {
    await _showCityGroupSelectionDialog(context, setState);
  } else {
    await _showCitySelectionDialog(context, setState);
  }
}

Future<void> _showCityGroupSelectionDialog(
  BuildContext context,
  Function setState,
) async {
  // Clear and reload data before opening dialog
  profileProvider!.citySearchGroupsList.clear();

  int offset = 0;
  int total = 0;
  String searchString = '';

  Future<void> loadData({bool isRefresh = true}) async {
    if (isRefresh) {
      offset = 0;
      profileProvider!.citySearchGroupsList.clear();
    }

    var parameter = {
      LIMIT: perPage.toString(),
      OFFSET: offset.toString(),
      if (searchString.trim().isNotEmpty) SEARCH: searchString,
      'ignore_seller': '1',
      // 'seller_id': context.read<SettingProvider>().CUR_USERID ?? '',
    };

    var result = await CityListRepository.getCitiesGroup(parameter: parameter);

    bool error = result['error'];
    if (!error) {
      total = int.parse(result["total"].toString());
      if (offset < total) {
        var data = result['data'] as List;
        profileProvider!.citySearchGroupsList.addAll(
          data.map((data) => CityGroupModel.fromJson(data)).toList(),
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
        height: MediaQuery.of(context).size.height * 0.75,
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
                    "SELECT_CITY_GROUP".translate(context: context),
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
                  child: profileProvider!.citySearchGroupsList.isEmpty
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
                            children: profileProvider!.citySearchGroupsList
                                .asMap()
                                .map(
                                  (index, element) => MapEntry(
                                    index,
                                    InkWell(
                                      onTap: () {
                                        final isSelected = profileProvider!
                                            .selectedCityGroups
                                            .any((g) => g.id == element.id);

                                        if (isSelected) {
                                          profileProvider!.selectedCityGroups
                                              .removeWhere(
                                                (g) => g.id == element.id,
                                              );
                                        } else {
                                          profileProvider!.selectedCityGroups
                                              .add(element);
                                        }

                                        // Update the group IDs string
                                        profileProvider!
                                                .deliverableCitiesGroupIds =
                                            profileProvider!.selectedCityGroups
                                                .map((g) => g.id)
                                                .join(',');

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
                                                        profileProvider!
                                                            .selectedCityGroups
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
                                                  final citiesString = element
                                                      .cities
                                                      .map((c) => c.cityName)
                                                      .whereType<String>()
                                                      .join(', ');

                                                  return "${element.groupName ?? ''} (${"CITIES".translate(context: context)}: $citiesString, ${"CHARGES".translate(context: context)}: ${element.deliveryCharge ?? ''})";
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
                        profileProvider!.selectedCityGroups.clear();
                        profileProvider!.deliverableCitiesGroupIds = '';
                        setState();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Ok".translate(context: context)),
                      onPressed: () {
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

Future<void> _showCitySelectionDialog(
  BuildContext context,
  Function setState,
) async {
  // For individual city selection (not group-wise)
  TextEditingController cityController = TextEditingController(
    text: profileProvider!.serviceableCities ?? '',
  );

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
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
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                child: Text(
                  "Enter Cities".translate(context: context),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: primary),
                ),
              ),
              const Divider(color: lightBlack),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter comma separated cities".translate(
                        context: context,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: cityController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "e.g. Delhi, Mumbai, Bangalore",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
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
                      profileProvider!.serviceableCities = cityController.text;
                      setState();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
