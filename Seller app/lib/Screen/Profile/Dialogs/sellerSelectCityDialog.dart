import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/city.dart';
import '../../../Repository/cityListRepository.dart';
import '../../../Widget/parameterString.dart';
import '../Profile.dart';

sellerSelectCityDialog(BuildContext context, Function setState) async {
  List<CityModel> cityList = [];
  List<CityModel> selectedCities = [];
  int offset = 0;
  int total = 0;
  String searchString = '';

  // Load existing selected cities from provider
  selectedCities = List.from(profileProvider!.selectedCitiesList);

  Future<void> loadData({bool isRefresh = true}) async {
    if (isRefresh) {
      offset = 0;
      cityList.clear();
    }

    var parameter = {
      LIMIT: perPage.toString(),
      OFFSET: offset.toString(),
      if (searchString.trim().isNotEmpty) SEARCH: searchString,
    };

    var result = await CityListRepository.getCities(parameter: parameter, skipAuth: true);

    bool error = result['error'];
    if (!error) {
      total = int.parse(result["total"].toString());
      if (offset < total) {
        var data = result['data'];
        cityList.addAll(
          (data as List).map((data) => CityModel.fromMap(data)).toList(),
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
                    "SELECT_CITY".translate(context: context),
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
                  child: cityList.isEmpty
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
                            children: cityList
                                .map(
                                  (element) => InkWell(
                                    onTap: () {
                                      final isSelected = selectedCities.any(
                                        (c) => c.id == element.id,
                                      );

                                      if (isSelected) {
                                        selectedCities.removeWhere(
                                          (c) => c.id == element.id,
                                        );
                                      } else {
                                        selectedCities.add(element);
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
                                                      selectedCities.any(
                                                        (c) =>
                                                            c.id ==
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
                                              element.name,
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
                        profileProvider!.selectedCitiesList = selectedCities;
                        // Save display value (city names)
                        profileProvider!.serviceableCities = selectedCities
                            .map((c) => c.name)
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
