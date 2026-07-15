// Comman Input Text Field :-     .
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/cityDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/deliverableGroupTypeDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/deliverableCityGroupTypeDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/digitalProductVideoTypeButtomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/pickUpLocationBottomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/selectCityGroupDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/selectZipcodeGroupDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/IndicatorDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/brandSelectButtomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/categorySelectButtomSheet.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/countryDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/deliverableTypeDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/selectZipcode.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/stockStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/taxesDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/tillWhichStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/variantStockStatusDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/variountProductStockManagementTypeDialog.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/Dialogs/videoselectionDialog.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/settingProvider.dart';
import '../../../Widget/snackbar.dart';
import '../EditProduct.dart';

getIconSelectionDesing(
  String title,
  int index,
  BuildContext context,
  Function update,
) {
  return InkWell(
    onTap: () {
      if (index == 1) {
        taxesDialog(context, update);
      } else if (index == 2) {
        indicatorDialog(context, update);
      } else if (index == 3) {
        countryDialog(context, update);
      } else if (index == 4) {
        editProvider!.deliverableZipcodes = null;
        deliverableTypeDialog(context, update);
      } else if (index == 5) {
        categorySelectButtomSheet(context, update);
      } else if (index == 6) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          cityDialog(context, update);
        } else {
          zipcodeDialog(context, update);
        }
      } else if (index == 7) {
        tillWhichStatusDialog(context, update);
      } else if (index == 8) {
        videoselectionDialog(context, update);
      } else if (index == 9) {
        FocusScope.of(context).requestFocus(FocusNode());
        setSnackbar(
          "You can't Change Product Type".translate(context: context),
          context,
        );
      } else if (index == 10) {
        FocusScope.of(context).requestFocus(FocusNode());
        stockStatusDialog(context, update);
      } else if (index == 11) {
        variountProductStockManagementTypeDialog(context, update);
      } else if (index == 12) {
        variantStockStatusDialog("product", 0, context, update);
      } else if (index == 13) {
        brandSelectButtomSheet(context, update);
      } else if (index == 14) {
        digitalProductVideoTypeDialog(context, update);
      } else if (index == 15) {
        FocusScope.of(context).requestFocus(FocusNode());
        setSnackbar(
          "You can't Change Product Type".translate(context: context),
          context,
        );
        // productTypePDDialog(context, update);
      } else if (index == 16) {
        pickUpLocationSelectBottomSheet(context, update);
      } else if (index == 17) {
        deliverableGroupTypeDialog(context, update);
      } else if (index == 18) {
        selectZipcodeGroupDialog(context, update);
      } else if (index == 19) {
        deliverableCityGroupTypeDialog(context, update);
      } else if (index == 20) {
        selectCityGroupDialog(context, update);
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: grey1,
        borderRadius: BorderRadius.circular(circularBorderRadius5),
        border: Border.all(color: grey2, width: 1),
      ),
      width: width,
      height: height * 0.06,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: getSecondaryCommanText(
                () {
                  if (index == 1) {
                    if (editProvider!.selectedTax.isNotEmpty) {
                      return editProvider!.selectedTax
                          .map((e) => "${e.title}(${e.percentage ?? ''}%)")
                          .toList()
                          .join(', ');
                    } else {
                      return "${"Select Tax".translate(context: context)} ${"0%".translate(context: context)}";
                    }
                  } else if (index == 2) {
                    if (editProvider!.indicatorValue == '0') {
                      return "None".translate(context: context);
                    } else if (editProvider!.indicatorValue == '1') {
                      return "Veg".translate(context: context);
                    } else if (editProvider!.indicatorValue == '2') {
                      return "Non-Veg".translate(context: context);
                    }
                    return title;
                  } else if (index == 3) {
                    if (editProvider!.madeIn != null) {
                      return "${"Made In".translate(context: context)} ${editProvider!.madeIn!}";
                    }
                    return title;
                  } else if (index == 4) {
                    if (editProvider!.deliverabletypeValue == '0') {
                      return "None".translate(context: context);
                    } else if (editProvider!.deliverabletypeValue == '1') {
                      return "All".translate(context: context);
                    } else if (editProvider!.deliverabletypeValue == '2') {
                      return "Include".translate(context: context);
                    } else if (editProvider!.deliverabletypeValue == '3') {
                      return "Exclude".translate(context: context);
                    }
                  } else if (index == 5) {
                    if (editProvider!.selectedCatName != null) {
                      return editProvider!.selectedCatName!;
                    }
                  } else if (index == 6) {
                    if (AppSettingsRepository
                        .appSettings
                        .isCityWiseDeliveribility) {
                      if (editProvider!.deliverableCities.isNotEmpty) {
                        return editProvider!.deliverableCities
                            .map((e) => e.name)
                            .toList()
                            .join(', ');
                      }
                    } else {
                      if (editProvider!.deliverableZipcodes != null) {
                        return editProvider!.deliverableZipcodes!;
                      }
                    }
                  } else if (index == 7) {
                    if (editProvider!.tillwhichstatus == 'received') {
                      return "received".translate(context: context);
                    } else if (editProvider!.tillwhichstatus == 'processed') {
                      return "PROCESSED_LBL".translate(context: context);
                    } else if (editProvider!.tillwhichstatus == 'shipped') {
                      return "SHIPED_LBL".translate(context: context);
                    }
                  } else if (index == 8) {
                    if (editProvider!.selectedTypeOfVideo == 'vimeo') {
                      return "Vimeo".translate(context: context);
                    } else if (editProvider!.selectedTypeOfVideo == 'youtube') {
                      return "Youtube".translate(context: context);
                    } else if (editProvider!.selectedTypeOfVideo ==
                        'self_hosted') {
                      return "Self Hosted".translate(context: context);
                    }
                  } else if (index == 9) {
                    if (editProvider!.productType == 'simple_product') {
                      return "Simple Product".translate(context: context);
                    } else if (editProvider!.productType ==
                        'variable_product') {
                      return "Variable Product".translate(context: context);
                    } else if (editProvider!.productType == 'digital_product') {
                      return 'Digital Product';
                    }
                  } else if (index == 10) {
                    if (editProvider!.simpleproductStockStatus == '1') {
                      return "In Stock".translate(context: context);
                    } else if (editProvider!.simpleproductStockStatus != null) {
                      return "Out Of Stock".translate(context: context);
                    }
                  } else if (index == 11) {
                    if (editProvider!.variantStockLevelType ==
                        'product_level') {
                      return "Product Level (Stock Will Be Managed Generally)"
                          .translate(context: context);
                    } else if (editProvider!.variantStockLevelType != null) {
                      return "Variable Level (Stock Will Be Managed Variant Wise)"
                          .translate(context: context);
                    }
                  } else if (index == 12) {
                    if (editProvider!.stockStatus == '1') {
                      return "In Stock".translate(context: context);
                    } else {
                      return "Out Of Stock".translate(context: context);
                    }
                  } else if (index == 13) {
                    if (editProvider!.selectedBrandName != null) {
                      return editProvider!.selectedBrandName!;
                    }
                  } else if (index == 14) {
                    if (editProvider!
                            .selectedDigitalProductTypeOfDownloadLink !=
                        null) {
                      return editProvider!
                          .selectedDigitalProductTypeOfDownloadLink!;
                    }
                  } else if (index == 15) {
                    return editProvider!.currentSellectedProductIsPysical
                        ? "PHYSICAL_PRODUCT".translate(context: context)
                        : "DIGITAL_PRODUCT".translate(context: context);
                  } else if (index == 16) {
                    if (editProvider!.selectedPickUpLocation != null) {
                      return editProvider!.selectedPickUpLocation!;
                    }
                  } else if (index == 17) {
                    if (editProvider!.deliverableGroupType == '0') {
                      return "None".translate(context: context);
                    } else if (editProvider!.deliverableGroupType == '1') {
                      return "All".translate(context: context);
                    } else if (editProvider!.deliverableGroupType == '2') {
                      return "Include".translate(context: context);
                    } else if (editProvider!.deliverableGroupType == '3') {
                      return "Exclude".translate(context: context);
                    }
                  } else if (index == 18) {
                    if (editProvider!.selectedZipcodeGroups != null &&
                        editProvider!.selectedZipcodeGroups.isNotEmpty) {
                      return editProvider!.selectedZipcodeGroups
                          .map((e) {
                            final zipcodesString = e.zipcodes
                                .map((z) => z.zipcode)
                                .whereType<String>()
                                .join(', ');
                            return '${e.groupName ?? ''} (${"ZIPCODES".translate(context: context)}: $zipcodesString, ${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? ''})';
                          })
                          .join('\n');
                    }
                  } else if (index == 19) {
                    if (editProvider!.deliverableCityGroupType == '0') {
                      return "None".translate(context: context);
                    } else if (editProvider!.deliverableCityGroupType == '1') {
                      return "All".translate(context: context);
                    } else if (editProvider!.deliverableCityGroupType == '2') {
                      return "Include".translate(context: context);
                    } else if (editProvider!.deliverableCityGroupType == '3') {
                      return "Exclude".translate(context: context);
                    }
                  } else if (index == 20) {
                    if (editProvider!.selectedCityGroups.isNotEmpty) {
                      return editProvider!.selectedCityGroups
                          .map((e) {
                            final citiesString = e.cities
                                .map((c) => c.cityName)
                                .whereType<String>()
                                .join(', ');
                            return '${e.groupName ?? ''} (${"CITIES".translate(context: context)}: $citiesString, ${"CHARGES".translate(context: context)}: ${e.deliveryCharge ?? ''})';
                          })
                          .join('\n');
                    }
                  }
                  return title;
                }(),
                color: (() {
                  // condition for color
                  if (index == 1 && editProvider!.selectedTax.isNotEmpty) {
                    return Colors.black;
                  }
                  if (index == 2 && editProvider!.indicatorValue != '0') {
                    return Colors.black;
                  }
                  if (index == 3 && editProvider!.madeIn != null) {
                    return Colors.black;
                  }
                  if (index == 4 &&
                      editProvider!.deliverabletypeValue != null) {
                    return Colors.black;
                  }
                  if (index == 5 && editProvider!.selectedCatName != null) {
                    return Colors.black;
                  }
                  if (index == 6 &&
                      ((AppSettingsRepository
                                  .appSettings
                                  .isCityWiseDeliveribility &&
                              editProvider!.deliverableCities.isNotEmpty) ||
                          (!AppSettingsRepository
                                  .appSettings
                                  .isCityWiseDeliveribility &&
                              editProvider!.deliverableZipcodes != null))) {
                    return Colors.black;
                  }
                  if (index == 7 && editProvider!.tillwhichstatus != null) {
                    return Colors.black;
                  }
                  if (index == 8 && editProvider!.selectedTypeOfVideo != null) {
                    return Colors.black;
                  }
                  if (index == 9 && editProvider!.productType != null) {
                    return Colors.black;
                  }
                  if (index == 10 &&
                      editProvider!.simpleproductStockStatus != null) {
                    return Colors.black;
                  }
                  if (index == 11 &&
                      editProvider!.variantStockLevelType != null) {
                    return Colors.black;
                  }
                  if (index == 12 && editProvider!.stockStatus != null) {
                    return Colors.black;
                  }
                  if (index == 13 && editProvider!.selectedBrandName != null) {
                    return Colors.black;
                  }
                  if (index == 14 &&
                      editProvider!.selectedDigitalProductTypeOfDownloadLink !=
                          null) {
                    return Colors.black;
                  }
                  if (index == 15) return Colors.black;
                  if (index == 16 &&
                      editProvider!.selectedPickUpLocation != null) {
                    return Colors.black;
                  }
                  if (index == 17 &&
                      editProvider!.deliverableGroupType != null) {
                    return Colors.black;
                  }
                  if (index == 18 &&
                      editProvider!.selectedZipcodeGroups != null) {
                    return Colors.black;
                  }
                  if (index == 19 &&
                      editProvider!.deliverableCityGroupType != null) {
                    return Colors.black;
                  }
                  if (index == 20 &&
                      editProvider!.selectedCityGroups.isNotEmpty) {
                    return Colors.black;
                  }

                  return Colors.grey;
                })(),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Icon(Icons.arrow_drop_down_outlined),
            ),
          ],
        ),
      ),
    ),
  );
}
