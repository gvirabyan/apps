import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/Profile/Profile.dart';
import 'package:sellermultivendor/Screen/Profile/Widget/commonfield.dart';
import 'package:sellermultivendor/Widget/deliverableTypeHelpDialog.dart';
import '../Dialogs/sellerDeliverableTypeDialog.dart';
import '../Dialogs/sellerDeliverableGroupTypeDialog.dart';
import '../Dialogs/sellerSelectZipcodeGroupDialog.dart';
import '../Dialogs/sellerSelectCityGroupDialog.dart';
import '../Dialogs/sellerSelectZipcodeDialog.dart';
import '../Dialogs/sellerSelectCityDialog.dart';

class DeliverabilitySection extends StatelessWidget {
  final Function setStateNow;

  const DeliverabilitySection({super.key, required this.setStateNow});

  String _getTypeLabel(String? type, BuildContext context) {
    switch (type) {
      case '0':
        return 'None'.translate(context: context);
      case '1':
        return 'All'.translate(context: context);
      case '2':
        return 'Include'.translate(context: context);
      case '3':
        return 'Exclude'.translate(context: context);
      default:
        return 'None'.translate(context: context);
    }
  }

  bool get isGroupWise =>
      AppSettingsRepository.appSettings.productDeliverabilityType ==
      "group_wise";

  // Always city-wise — zipcode logic removed per delivery requirements
  bool get isCityWise => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // When NOT group_wise (Individual mode)
        if (!isGroupWise) ...[
          // Deliverable Type
          Row(
            children: [
              Flexible(
                child: CommonText(text: 'Deliverable Type'.translate(context: context)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => deliverableTypeHelpDialog(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "HOW_IT_WORKS".translate(context: context),
                      style: const TextStyle(
                        fontSize: 12,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildSelectableField(
            context: context,
            value: _getTypeLabel(
              isCityWise
                  ? profileProvider!.deliverableCityType
                  : profileProvider!.deliverableZipcodeType,
              context,
            ),
            onTap: () {
              sellerDeliverableTypeDialog(context, setStateNow, isCityWise);
            },
          ),

          // Show zipcode/city selection if type is Include or Exclude
          if ((isCityWise &&
                  (profileProvider!.deliverableCityType == '2' ||
                      profileProvider!.deliverableCityType == '3')) ||
              (!isCityWise &&
                  (profileProvider!.deliverableZipcodeType == '2' ||
                      profileProvider!.deliverableZipcodeType == '3'))) ...[
            CommonText(
              text: isCityWise
                  ? 'SELECT_CITY'.translate(context: context)
                  : 'Select ZipCode'.translate(context: context),
            ),
            _buildSelectableField(
              context: context,
              value: isCityWise
                  ? _getCitiesDisplayValue(context)
                  : _getZipcodesDisplayValue(context),
              onTap: () {
                if (isCityWise) {
                  sellerSelectCityDialog(context, setStateNow);
                } else {
                  sellerSelectZipcodeDialog(context, setStateNow);
                }
              },
            ),
          ],
        ] else ...[
          // Group-wise mode
          // Zipcode Group (when city wise is disabled)
          if (!isCityWise) ...[
            Row(
              children: [
                Flexible(
                  child: CommonText(
                    text: 'DELIVERABLE_ZIPCODE_GROUP_TYPE'.translate(
                      context: context,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => deliverableTypeHelpDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "HOW_IT_WORKS".translate(context: context),
                        style: const TextStyle(
                          fontSize: 12,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildSelectableField(
              context: context,
              value: _getTypeLabel(
                profileProvider!.deliverableZipcodeType,
                context,
              ),
              onTap: () {
                sellerDeliverableGroupTypeDialog(context, setStateNow, false);
              },
            ),

            // Zipcode Group Selection (if type is Include or Exclude)
            if (profileProvider!.deliverableZipcodeType == '2' ||
                profileProvider!.deliverableZipcodeType == '3') ...[
              CommonText(
                text: 'DELIVERABLE_ZIPCODE_GROUP'.translate(context: context),
              ),
              _buildSelectableField(
                context: context,
                value: _getZipcodeGroupsDisplayValue(context)!,
                onTap: () {
                  sellerSelectZipcodeGroupDialog(context, setStateNow);
                },
              ),
            ],
          ] else ...[
            // City Group (when city wise is enabled)
            Row(
              children: [
                Flexible(
                  child: CommonText(
                    text: 'DELIVERABLE_CITY_GROUP_TYPE'.translate(context: context),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => deliverableTypeHelpDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "HOW_IT_WORKS".translate(context: context),
                        style: const TextStyle(
                          fontSize: 12,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildSelectableField(
              context: context,
              value: _getTypeLabel(
                profileProvider!.deliverableCityType,
                context,
              ),
              onTap: () {
                sellerDeliverableGroupTypeDialog(context, setStateNow, true);
              },
            ),

            // City Group Selection (if type is Include or Exclude)
            if (profileProvider!.deliverableCityType == '2' ||
                profileProvider!.deliverableCityType == '3') ...[
              CommonText(
                text: 'DELIVERABLE_CITY_GROUP'.translate(context: context),
              ),
              _buildSelectableField(
                context: context,
                value: _getCityGroupsDisplayValue(context)!,
                onTap: () {
                  sellerSelectCityGroupDialog(context, setStateNow);
                },
              ),
            ],
          ],
        ],
      ],
    );
  }

  // // Get display value for zipcode groups (same format as Add Product)
  // String? _getZipcodeGroupsDisplayValue(BuildContext context) {
  //   if (profileProvider!.selectedZipcodeGroups.isNotEmpty) {
  //     return profileProvider!.selectedZipcodeGroups
  //         .map((e) {
  //           final zipcodesString = e.zipcodes
  //               .map((z) => z.zipcode)
  //               .whereType<String>()
  //               .join(', ');
  //           return '${e.groupName ?? ''} (${"ZIPCODES".translate(context: context)}: $zipcodesString, ${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? ''})';
  //         })
  //         .join('\n');
  //   }
  //   return profileProvider!.deliverableZipcodesGroupIds;
  // }

  String? _getZipcodeGroupsDisplayValue(BuildContext context) {
    // 1️⃣ Priority: Show loaded/selected groups (formatted)
    if (profileProvider!.selectedZipcodeGroups.isNotEmpty) {
      return profileProvider!.selectedZipcodeGroups
          .map((e) {
            final zipcodesString = e.zipcodes
                .map((z) => z.zipcode)
                .whereType<String>()
                .join(', ');

            return '${e.groupName ?? ''} '
                '(${"ZIPCODES".translate(context: context)}: $zipcodesString, '
                '${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? ''})';
          })
          .join(' , ');
    }

    // 2️⃣ Fallback: Show saved IDs if not loaded yet
    if (profileProvider!.deliverableZipcodesGroupIds != null &&
        profileProvider!.deliverableZipcodesGroupIds!.isNotEmpty) {
      return profileProvider!.deliverableZipcodesGroupIds;
    }

    return 'SELECT_ZIPCODE_GROUP'.translate(context: context);
  }

  // Get display value for individual zipcodes (non-group mode)
  String _getZipcodesDisplayValue(BuildContext context) {
    if (profileProvider!.serviceableZipcodes?.isNotEmpty == true) {
      return '${"ZIPCODES".translate(context: context)}: ${profileProvider!.serviceableZipcodes}';
    }
    return 'SELECT_ZIPCODE'.translate(context: context);
  }

  // Get display value for individual cities (non-group mode)
  String _getCitiesDisplayValue(BuildContext context) {
    if (profileProvider!.serviceableCities?.isNotEmpty == true) {
      return '${"CITIES".translate(context: context)}: ${profileProvider!.serviceableCities}';
    }
    return 'PLEASE_SELECT_CITIES'.translate(context: context);
  }

  // Get display value for city groups (same format as Add Product)
  String? _getCityGroupsDisplayValue(BuildContext context) {
    // 1️⃣ Priority: Show loaded/selected groups (formatted)
    if (profileProvider!.selectedCityGroups.isNotEmpty) {
      return profileProvider!.selectedCityGroups
          .map((e) {
            final citiesString = e.cities
                .map((c) => c.cityName)
                .whereType<String>()
                .join(', ');

            return '${e.groupName ?? ''} '
                '(${"CITIES".translate(context: context)}: $citiesString, '
                '${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? ''})';
          })
          .join(' , ');
    }

    // 2️⃣ Fallback: Show saved IDs if not loaded yet
    if (profileProvider!.deliverableCitiesGroupIds != null &&
        profileProvider!.deliverableCitiesGroupIds!.isNotEmpty) {
      return profileProvider!.deliverableCitiesGroupIds;
    }

    return 'SELECT_CITY_GROUP'.translate(context: context);
  }

  Widget _buildSelectableField({
    required BuildContext context,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: grey2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const Icon(Icons.arrow_drop_down, color: lightBlack),
          ],
        ),
      ),
    );
  }
}
