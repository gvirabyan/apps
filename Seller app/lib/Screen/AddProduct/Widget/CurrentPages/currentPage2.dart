//==============================================================================
//============================= UI Part ========================================
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Widget/deliverableTypeHelpDialog.dart';
import '../../Add_Product.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getCommonSwitch.dart';
import '../getIconSelectionDesingWidget.dart';

currentPage2(BuildContext context, Function update, Function updateCitys) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                  "Total Allowed Quantity".translate(context: context),
                  true,
                ),
                getCommanSizedBox(),
                getCommanInputTextField(" ", 4, 0.06, 1, 3, context),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                  "Minimum Order Quantity".translate(context: context),
                  true,
                ),
                getCommanSizedBox(),
                getCommanInputTextField(" ", 5, 0.06, 1, 3, context),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                  "Quantity Step Size".translate(context: context),
                  true,
                ),
                getCommanSizedBox(),
                getCommanInputTextField(" ", 6, 0.06, 1, 3, context),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                  "Warranty Period".translate(context: context),
                  true,
                ),
                getCommanSizedBox(),
                getCommanInputTextField(" ", 7, 0.06, 1, 2, context),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                  "Guarantee Period".translate(context: context),
                  true,
                ),
                getCommanSizedBox(),
                getCommanInputTextField(" ", 8, 0.06, 1, 2, context),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      if (AppSettingsRepository.appSettings.productDeliverabilityType !=
          "group_wise") ...[
        addProvider!.currentSellectedProductIsPysical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: getPrimaryCommanText(
                          "Deliverable Type".translate(context: context),
                          true,
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
                  getCommanSizedBox(),
                  getIconSelectionDesing(
                    "(ex, all, include, exclude)".translate(context: context),
                    4,
                    context,
                    update,
                    updateCitys,
                  ),
                ],
              )
            : Container(),
        addProvider!.currentSellectedProductIsPysical
            ? addProvider!.deliverabletypeValue == "2" ||
                      addProvider!.deliverabletypeValue == "3"
                  ? getCommanSizedBox()
                  : Container()
            : Container(),
        addProvider!.deliverabletypeValue == "2" ||
                addProvider!.deliverabletypeValue == "3"
            ? getPrimaryCommanText(
                AppSettingsRepository.appSettings.isCityWiseDeliveribility
                    ? "SELECT_CITY".translate(context: context)
                    : "Select ZipCode".translate(context: context),
                false,
              )
            : Container(),
        addProvider!.deliverabletypeValue == "2" ||
                addProvider!.deliverabletypeValue == "3"
            ? getCommanSizedBox()
            : const SizedBox.shrink(),
        addProvider!.deliverabletypeValue == "2" ||
                addProvider!.deliverabletypeValue == "3"
            ? getIconSelectionDesing(
                AppSettingsRepository.appSettings.isCityWiseDeliveribility
                    ? "PLEASE_SELECT_CITIES".translate(context: context)
                    : "not Selected Yet!(ex. 791572)".translate(
                        context: context,
                      ),
                6,
                context,
                update,
                updateCitys,
              )
            : Container(),
      ] else ...[
        // Deliverable Zipcode Group Type (shown when zipcode delivery is enabled)
        addProvider!.currentSellectedProductIsPysical &&
                !AppSettingsRepository.appSettings.isCityWiseDeliveribility
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: getPrimaryCommanText(
                          "DELIVERABLE_ZIPCODE_GROUP_TYPE".translate(
                            context: context,
                          ),
                          true,
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
                  getCommanSizedBox(),
                  getIconSelectionDesing(
                    "(ex, all, include, exclude)".translate(context: context),
                    17,
                    context,
                    update,
                    updateCitys,
                  ),
                ],
              )
            : Container(),
        addProvider!.currentSellectedProductIsPysical &&
                !AppSettingsRepository.appSettings.isCityWiseDeliveribility &&
                (addProvider!.deliverableGroupType == "2" ||
                    addProvider!.deliverableGroupType == "3")
            ? getCommanSizedBox()
            : Container(),
        // Deliverable Zipcode Group Selection
        addProvider!.currentSellectedProductIsPysical &&
                !AppSettingsRepository.appSettings.isCityWiseDeliveribility &&
                (addProvider!.deliverableGroupType == "2" ||
                    addProvider!.deliverableGroupType == "3")
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getPrimaryCommanText(
                    "DELIVERABLE_ZIPCODE_GROUP".translate(context: context),
                    false,
                  ),
                  getCommanSizedBox(),
                  getIconSelectionDesing(
                    "SELECT_ZIPCODE_GROUP".translate(context: context),
                    18,
                    context,
                    update,
                    updateCitys,
                  ),
                ],
              )
            : Container(),
        // Deliverable City Group Type (shown when city delivery is enabled)
        addProvider!.currentSellectedProductIsPysical &&
                AppSettingsRepository.appSettings.isCityWiseDeliveribility
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: getPrimaryCommanText(
                          "DELIVERABLE_CITY_GROUP_TYPE".translate(context: context),
                          true,
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
                  getCommanSizedBox(),
                  getIconSelectionDesing(
                    "(ex, all, include, exclude)".translate(context: context),
                    19,
                    context,
                    update,
                    updateCitys,
                  ),
                ],
              )
            : Container(),
        addProvider!.currentSellectedProductIsPysical &&
                AppSettingsRepository.appSettings.isCityWiseDeliveribility &&
                (addProvider!.deliverableCityGroupType == "2" ||
                    addProvider!.deliverableCityGroupType == "3")
            ? getCommanSizedBox()
            : Container(),
        // Deliverable City Group Selection
        addProvider!.currentSellectedProductIsPysical &&
                AppSettingsRepository.appSettings.isCityWiseDeliveribility &&
                (addProvider!.deliverableCityGroupType == "2" ||
                    addProvider!.deliverableCityGroupType == "3")
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getPrimaryCommanText(
                    "DELIVERABLE_CITY_GROUP".translate(context: context),
                    false,
                  ),
                  getCommanSizedBox(),
                  getIconSelectionDesing(
                    "SELECT_CITY_GROUP".translate(context: context),
                    20,
                    context,
                    update,
                    updateCitys,
                  ),
                ],
              )
            : Container(),
      ],
      getCommanSizedBox(),
      getPrimaryCommanText(
        "selected category".translate(context: context),
        false,
      ),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "not Selected Yet!(ex. vegetable, Fashion)".translate(context: context),
        5,
        context,
        update,
        updateCitys,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText("Select Brand".translate(context: context), false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "not Selected Yet!(ex. TaTa, Apple, MicroSoft)".translate(
          context: context,
        ),
        13,
        context,
        update,
        updateCitys,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText(
        "Select PickUp Location".translate(context: context),
        false,
      ),
      getCommanSizedBox(),
      getIconSelectionDesing(
        "PickUp Location Not Selected Yet".translate(context: context),
        16,
        context,
        update,
        updateCitys,
      ),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPrimaryCommanText(
            "LOW_STOCK_LIMIT".translate(context: context),
            false,
          ),
          getCommanSizedBox(),
          getCommanInputTextField(" ", 24, 0.06, 1, 3, context),
        ],
      ),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: getPrimaryCommanText(
                    "Is Product Returnable?".translate(context: context),
                    true,
                  ),
                ),
                getCommanSwitch(1, update),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: getPrimaryCommanText(
                    "Is Product COD Allowed?".translate(context: context),
                    true,
                  ),
                ),
                getCommanSwitch(2, update),
              ],
            )
          : Container(),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
              "Tax included in price?".translate(context: context),
              true,
            ),
          ),
          getCommanSwitch(3, update),
        ],
      ),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: getPrimaryCommanText(
                    "Is Product Cancelable?".translate(context: context),
                    true,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "TILL_RECEIVED".translate(context: context),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                getCommanSwitch(4, update),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getPrimaryCommanText(
                  "Is Attachment Required ?".translate(context: context),
                  true,
                ),
                getCommanSwitch(6, update),
              ],
            )
          : Container(),
    ],
  );
}
