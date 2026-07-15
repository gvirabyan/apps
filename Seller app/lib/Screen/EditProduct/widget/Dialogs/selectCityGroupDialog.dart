import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/EditProduct/EditProduct.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';

selectCityGroupDialog(BuildContext context, Function setState) async {
  final cityProvider = Provider.of<CityProvider>(context, listen: false);
  if (cityProvider.searchString.isNotEmpty) {
    cityProvider.searchString = "";
    cityProvider.getCitiesGroup(
      ignoreSeller: '0',
      sellerId: context.read<SettingProvider>().CUR_USERID,
    );
  } else if (cityProvider.cityGroupList.isEmpty) {
    context.read<CityProvider>().getCitiesGroup(
      ignoreSeller: '0',
      sellerId: context.read<SettingProvider>().CUR_USERID,
    );
  }
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
        child: Consumer<CityProvider>(
          builder: (context, cityGroupData, child) {
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
                  child: TextField(
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
                      //auto search after 1 second of typing
                      debounce = Timer(const Duration(milliseconds: 1000), () {
                        cityGroupData.searchString = value;
                        context.read<CityProvider>().getCitiesGroup(
                          ignoreSeller: '0',
                          sellerId: context.read<SettingProvider>().CUR_USERID,
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: cityGroupData.isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : StatefulBuilder(
                          builder: (context, setStater) {
                            ScrollController scrollController =
                                ScrollController();
                            scrollController.addListener(() async {
                              if (scrollController.offset >=
                                      scrollController
                                          .position
                                          .maxScrollExtent &&
                                  !scrollController.position.outOfRange) {
                                if (context.mounted) {
                                  await context
                                      .read<CityProvider>()
                                      .getCitiesGroup(
                                        isReload: false,
                                        ignoreSeller: '0',
                                        sellerId: context
                                            .read<SettingProvider>()
                                            .CUR_USERID,
                                      );
                                }
                              }
                            });
                            return SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  if (cityGroupData.cityGroupList.isEmpty) ...[
                                    Center(
                                      child: Text(
                                        "NO_DATA_FOUND".translate(
                                          context: context,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: primary),
                                      ),
                                    ),
                                  ] else ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: () {
                                        return cityGroupData.cityGroupList
                                            .asMap()
                                            .map(
                                              (index, element) => MapEntry(
                                                index,
                                                InkWell(
                                                  onTap: () {
                                                    final isSelected =
                                                        editProvider!
                                                            .selectedCityGroups
                                                            .any(
                                                              (g) =>
                                                                  g.id ==
                                                                  element.id,
                                                            );

                                                    if (isSelected) {
                                                      editProvider!
                                                          .selectedCityGroups
                                                          .removeWhere(
                                                            (g) =>
                                                                g.id ==
                                                                element.id,
                                                          );
                                                    } else {
                                                      editProvider!
                                                          .selectedCityGroups
                                                          .add(element);
                                                    }
                                                    setState();
                                                    setStater(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child:
                                                            editProvider!
                                                                .selectedCityGroups
                                                                .any(
                                                                  (g) =>
                                                                      g.id ==
                                                                      element
                                                                          .id,
                                                                )
                                                            ? Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                      color:
                                                                          grey2,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                child: Center(
                                                                  child: Container(
                                                                    height: 16,
                                                                    width: 16,
                                                                    decoration: const BoxDecoration(
                                                                      color:
                                                                          primary,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                      color:
                                                                          grey2,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                child: Center(
                                                                  child: Container(
                                                                    height: 16,
                                                                    width: 16,
                                                                    decoration: const BoxDecoration(
                                                                      color:
                                                                          white,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                      Expanded(
                                                        flex: 8,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            () {
                                                              final citiesString =
                                                                  element.cities
                                                                      .map(
                                                                        (c) => c
                                                                            .cityName,
                                                                      )
                                                                      .whereType<
                                                                        String
                                                                      >()
                                                                      .join(
                                                                        ', ',
                                                                      );

                                                              return "${element.groupName ?? ''} (${"CITIES".translate(context: context)}: $citiesString, ${"CHARGES".translate(context: context)}: ${element.deliveryCharge ?? ''})";
                                                            }(),
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .values
                                            .toList();
                                      }(),
                                    ),
                                  ],
                                  DesignConfiguration.showCircularProgress(
                                    cityGroupData.isLoadingmore,
                                    primary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        "CANCEL".translate(context: context),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        editProvider!.selectedCityGroups.clear();
                        setState();
                        Routes.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Ok".translate(context: context)),
                      onPressed: () {
                        Routes.pop(context);
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

// selectCityGroupDialog(BuildContext context, Function update) async {
//   await showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return Container(
//         height: 500,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(circularBorderRadius25),
//             topRight: Radius.circular(circularBorderRadius25),
//           ),
//         ),
//         child: StatefulBuilder(
//           builder: (BuildContext context, setStater) {
//             ScrollController scrollController = ScrollController();
//             scrollController.addListener(() async {
//               if (scrollController.offset >=
//                       scrollController.position.maxScrollExtent &&
//                   !scrollController.position.outOfRange) {
//                 if (context.mounted) {
//                   await context.read<CityProvider>().getCitiesGroup();
//                   setStater(() {});
//                 }
//               }
//             });
//             addProvider!.taxesState = setStater;
//             Timer? debounce;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
//                   child: Text(
//                     "SELECT_CITY_GROUP".translate(context: context),
//                     style: Theme.of(
//                       context,
//                     ).textTheme.titleMedium!.copyWith(color: primary),
//                   ),
//                 ),
//                 const Divider(color: lightBlack),
//                 const SizedBox(height: 5),
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(circularBorderRadius5),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: blarColor,
//                         offset: Offset(0, 0),
//                         blurRadius: 4,
//                         spreadRadius: 0,
//                       ),
//                     ],
//                     color: white,
//                   ),
//                   child: TextFormField(
//                     initialValue: context.read<CityProvider>().searchString,
//                     decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       prefixIconConstraints: const BoxConstraints(
//                         minWidth: 40,
//                         maxHeight: 20,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 10,
//                       ),
//                       prefixIcon: const Icon(Icons.search),
//                       hintText: "SEARCH".translate(context: context),
//                       hintStyle: TextStyle(
//                         color: black.withValues(alpha: 0.3),
//                         fontWeight: FontWeight.normal,
//                       ),
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 0,
//                           style: BorderStyle.none,
//                         ),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       if (debounce?.isActive ?? false) debounce?.cancel();
//                       //auto search after 1 second of typing
//                       debounce = Timer(
//                         const Duration(milliseconds: 1000),
//                         () async {
//                           context.read<CityProvider>().searchString = value;
//                           await context.read<CityProvider>().getCitiesGroup(
//                             isReload: true,
//                           );
//                           setStater(() {});
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Expanded(
//                   child: addProvider!.cityGroupsList.isEmpty
//                       ? Center(
//                           child: Text(
//                             "NO_DATA_FOUND".translate(context: context),
//                             style: Theme.of(
//                               context,
//                             ).textTheme.titleMedium!.copyWith(color: primary),
//                           ),
//                         )
//                       : SingleChildScrollView(
//                           controller: scrollController,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: addProvider!.cityGroupsList
//                                 .asMap()
//                                 .map(
//                                   (index, element) => MapEntry(
//                                     index,
//                                     InkWell(
//                                       onTap: () {
//                                         // Toggle selection
//                                         if (addProvider!.selectedCityGroups.any(
//                                           (g) => g.id == element.id,
//                                         )) {
//                                           addProvider!.selectedCityGroups
//                                               .removeWhere(
//                                                 (g) => g.id == element.id,
//                                               );
//                                         } else {
//                                           addProvider!.selectedCityGroups.add(
//                                             element,
//                                           );
//                                         }
//                                         update();
//                                         setStater(() {});
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 20.0,
//                                           vertical: 12.0,
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               height: 20,
//                                               width: 20,
//                                               decoration: const BoxDecoration(
//                                                 color: grey2,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Center(
//                                                 child: Container(
//                                                   height: 16,
//                                                   width: 16,
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         addProvider!
//                                                             .selectedCityGroups
//                                                             .any(
//                                                               (g) =>
//                                                                   g.id ==
//                                                                   element.id,
//                                                             )
//                                                         ? primary
//                                                         : white,
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 12),
//                                             Expanded(
//                                               child: Text(
//                                                 element.groupName ?? '',
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .values
//                                 .toList(),
//                           ),
//                         ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       child: Text(
//                         "CANCEL".translate(context: context),
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                       onPressed: () {
//                         addProvider!.selectedCityGroups.clear();
//                         update();
//                         Navigator.pop(context);
//                       },
//                     ),
//                     TextButton(
//                       child: Text("Ok".translate(context: context)),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//     },
//   );
// }
