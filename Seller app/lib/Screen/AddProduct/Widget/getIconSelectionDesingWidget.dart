// Comman Input Text Field :-     .
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/AddProduct/Widget/Dialogs/pickUpLocationBottomSheet.dart';
import 'package:sellermultivendor/Screen/AddProduct/Widget/Dialogs/selectCityDialog.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/settingProvider.dart';
import '../Add_Product.dart';
import 'Dialogs/IndicatorDialog.dart';
import 'Dialogs/brandSelectButtomSheet.dart';
import 'Dialogs/categorySelectButtomSheet.dart';
import 'Dialogs/countryDialog.dart';
import 'Dialogs/deliverableGroupTypeDialog.dart';
import 'Dialogs/deliverableCityGroupTypeDialog.dart';
import 'Dialogs/deliverableTypeDialog.dart';
import 'Dialogs/digitalProductVideoTypeButtomSheet.dart';
import 'Dialogs/productPDTypeDialog.dart';
import 'Dialogs/productTypeDialog.dart';
import 'Dialogs/selectZipcode.dart';
import 'Dialogs/selectZipcodeGroupDialog.dart';
import 'Dialogs/selectCityGroupDialog.dart';
import 'Dialogs/stockStatusDialog.dart';
import 'Dialogs/taxesDialog.dart';
import 'Dialogs/tillWhichStatusDialog.dart';
import 'Dialogs/variantStockStatusDialog.dart';
import 'Dialogs/variountProductStockManagementTypeDialog.dart';
import 'Dialogs/videoselectionDialog.dart';
import 'getCommanWidget.dart';

getIconSelectionDesing(
  String title,
  int index,
  BuildContext context,
  Function setState,
  Function updateCity,
) {
  return InkWell(
    onTap: () {
      if (index == 1) {
        taxesDialog(context, setState);
      } else if (index == 2) {
        indicatorDialog(context, setState);
      } else if (index == 3) {
        countryDialog(context, setState, updateCity);
      } else if (index == 4) {
        addProvider!.deliverableZipcodes = null;
        deliverableTypeDialog(context, setState);
      } else if (index == 5) {
        categorySelectButtomSheet(context, setState);
      } else if (index == 6) {
        if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
          cityDialog(context, setState);
        } else {
          zipcodeDialog(context, setState);
        }
      } else if (index == 7) {
        tillWhichStatusDialog(context, setState);
      } else if (index == 8) {
        videoselectionDialog(context, setState);
      } else if (index == 9) {
        FocusScope.of(context).requestFocus(FocusNode());
        productTypeDialog(context, setState);
      } else if (index == 10) {
        FocusScope.of(context).requestFocus(FocusNode());
        stockStatusDialog(context, setState);
      } else if (index == 11) {
        variountProductStockManagementTypeDialog(context, setState);
      } else if (index == 12) {
        variantStockStatusDialog("product", 0, context, setState);
      } else if (index == 13) {
        brandSelectButtomSheet(context, setState);
      } else if (index == 14) {
        digitalProductVideoTypeDialog(context, setState);
      } else if (index == 15) {
        productTypePDDialog(context, setState);
      } else if (index == 16) {
        pickUpLocationSelectButtomSheet(context, setState);
      } else if (index == 17) {
        deliverableGroupTypeDialog(context, setState);
      } else if (index == 18) {
        selectZipcodeGroupDialog(context, setState);
      } else if (index == 19) {
        deliverableCityGroupTypeDialog(context, setState);
      } else if (index == 20) {
        selectCityGroupDialog(context, setState);
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: grey1,
        borderRadius: BorderRadius.circular(circularBorderRadius7),
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
                    if (addProvider!.selectedTax.isNotEmpty) {
                      return addProvider!.selectedTax
                          .map((e) => "${e.title}(${e.percentage ?? ''}%)")
                          .toList()
                          .join(', ');
                    } else {
                      return "${"Select Tax".translate(context: context)} ${"0%".translate(context: context)}";
                    }
                  } else if (index == 2) {
                    if (addProvider!.indicatorValue == '0') {
                      return "None".translate(context: context);
                    } else if (addProvider!.indicatorValue == '1') {
                      return "Veg".translate(context: context);
                    } else if (addProvider!.indicatorValue == '2') {
                      return "Non-Veg".translate(context: context);
                    }
                    return title;
                  } else if (index == 3) {
                    if (addProvider!.madeIn != null) {
                      return "${"Made In".translate(context: context)} ${addProvider!.madeIn!}";
                    }
                    return title;
                  } else if (index == 4) {
                    if (addProvider!.deliverabletypeValue == '0') {
                      return "None".translate(context: context);
                    } else if (addProvider!.deliverabletypeValue == '1') {
                      return "All".translate(context: context);
                    } 
                    else if (addProvider!.deliverabletypeValue == '2') {
                      return "Include".translate(context: context);
                    }
                    else if (addProvider!.deliverabletypeValue == '3') {
                      return "Exclude".translate(context: context);
                    }
                  } else if (index == 5) {
                    if (addProvider!.selectedCatName != null) {
                      return addProvider!.selectedCatName!;
                    }
                  } else if (index == 6) {
                    if (AppSettingsRepository
                        .appSettings
                        .isCityWiseDeliveribility) {
                      if (addProvider!.deliverableCities.isNotEmpty) {
                        return addProvider!.deliverableCities
                            .map((e) => e.name)
                            .toList()
                            .join(', ');
                      }
                    } else {
                      if (addProvider!.deliverableZipcodes != null) {
                        return addProvider!.deliverableZipcodes!;
                      }
                    }
                  } else if (index == 7) {
                    if (addProvider!.tillwhichstatus == 'received') {
                      return "received".translate(context: context);
                    } else if (addProvider!.tillwhichstatus == 'processed') {
                      return "PROCESSED_LBL".translate(context: context);
                    } else if (addProvider!.tillwhichstatus == 'shipped') {
                      return "SHIPED_LBL".translate(context: context);
                    }
                  } else if (index == 8) {
                    if (addProvider!.selectedTypeOfVideo == 'vimeo') {
                      return "Vimeo".translate(context: context);
                    } else if (addProvider!.selectedTypeOfVideo == 'youtube') {
                      return "Youtube".translate(context: context);
                    } else if (addProvider!.selectedTypeOfVideo ==
                        'self_hosted') {
                      return "self_hosted";
                    }
                  } else if (index == 9) {
                    if (addProvider!.productType == 'simple_product') {
                      return "Simple Product".translate(context: context);
                    } else if (addProvider!.productType == 'variable_product') {
                      return "Variable Product".translate(context: context);
                    } else if (addProvider!.productType == 'digital_product') {
                      return "Digital Product";
                    }
                  } else if (index == 10) {
                    if (addProvider!.simpleproductStockStatus == '1') {
                      return "In Stock".translate(context: context);
                    } else if (addProvider!.simpleproductStockStatus != null) {
                      return "Out Of Stock".translate(context: context);
                    }
                  } else if (index == 11) {
                    if (addProvider!.variantStockLevelType == 'product_level') {
                      return "Product Level (Stock Will Be Managed Generally)"
                          .translate(context: context);
                    } else if (addProvider!.variantStockLevelType != null) {
                      return "Variable Level (Stock Will Be Managed Variant Wise)"
                          .translate(context: context);
                    }
                  } else if (index == 12) {
                    if (addProvider!.stockStatus == '1') {
                      return "In Stock".translate(context: context);
                    } else {
                      return "Out Of Stock".translate(context: context);
                    }
                  } else if (index == 13) {
                    if (addProvider!.selectedBrandName != null) {
                      return addProvider!.selectedBrandName!;
                    }
                  } else if (index == 14) {
                    if (addProvider!.selectedDigitalProductTypeOfDownloadLink !=
                        null) {
                      return addProvider!
                          .selectedDigitalProductTypeOfDownloadLink!;
                    }
                  } else if (index == 15) {
                    return addProvider!.currentSellectedProductIsPysical
                        ? "PHYSICAL_PRODUCT".translate(context: context)
                        : "DIGITAL_PRODUCT".translate(context: context);
                  } else if (index == 16) {
                    if (addProvider!.selectedPickUpLocation != null) {
                      return addProvider!.selectedPickUpLocation!;
                    }
                  } else if (index == 17) {
                    if (addProvider!.deliverableGroupType == '0') {
                      return "None".translate(context: context);
                    } else if (addProvider!.deliverableGroupType == '1') {
                      return "All".translate(context: context);
                    } 
                    else if (addProvider!.deliverableGroupType == '2') {
                      return "Include".translate(context: context);
                    }
                    else if (addProvider!.deliverableGroupType == '3') {
                      return "Exclude".translate(context: context);
                    }
                  } else if (index == 18) {
                    if (addProvider!.selectedZipcodeGroups.isNotEmpty) {
                      return addProvider!.selectedZipcodeGroups
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
                    if (addProvider!.deliverableCityGroupType == '0') {
                      return "None".translate(context: context);
                    } else if (addProvider!.deliverableCityGroupType == '1') {
                      return "All".translate(context: context);
                    }
                    else if (addProvider!.deliverableCityGroupType == '2') {
                      return "Include".translate(context: context);
                    }
                    else if (addProvider!.deliverableCityGroupType == '3') {
                      return "Exclude".translate(context: context);
                    }
                  } else if (index == 20) {
                    if (addProvider!.selectedCityGroups.isNotEmpty) {
                      return addProvider!.selectedCityGroups
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
                  // ✅ dynamic color condition
                  if (index == 1 && addProvider!.selectedTax.isNotEmpty) {
                    return Colors.black;
                  }
                  if (index == 2 && addProvider!.indicatorValue != '0') {
                    return Colors.black;
                  }
                  if (index == 3 && addProvider!.madeIn != null) {
                    return Colors.black;
                  }
                  if (index == 4 && addProvider!.deliverabletypeValue != null) {
                    return Colors.black;
                  }
                  if (index == 5 && addProvider!.selectedCatName != null) {
                    return Colors.black;
                  }
                  if (index == 6 &&
                      ((AppSettingsRepository
                                  .appSettings
                                  .isCityWiseDeliveribility &&
                              addProvider!.deliverableCities.isNotEmpty) ||
                          (!AppSettingsRepository
                                  .appSettings
                                  .isCityWiseDeliveribility &&
                              addProvider!.deliverableZipcodes != null))) {
                    return Colors.black;
                  }
                  if (index == 7 && addProvider!.tillwhichstatus != null) {
                    return Colors.black;
                  }
                  if (index == 8 && addProvider!.selectedTypeOfVideo != null) {
                    return Colors.black;
                  }
                  if (index == 9 && addProvider!.productType != null) {
                    return Colors.black;
                  }
                  if (index == 10 &&
                      addProvider!.simpleproductStockStatus != null) {
                    return Colors.black;
                  }
                  if (index == 11 &&
                      addProvider!.variantStockLevelType != null) {
                    return Colors.black;
                  }
                  if (index == 12 && addProvider!.stockStatus != null) {
                    return Colors.black;
                  }
                  if (index == 13 && addProvider!.selectedBrandName != null) {
                    return Colors.black;
                  }
                  if (index == 14 &&
                      addProvider!.selectedDigitalProductTypeOfDownloadLink !=
                          null) {
                    return Colors.black;
                  }
                  if (index == 15) return Colors.black;
                  if (index == 16 &&
                      addProvider!.selectedPickUpLocation != null) {
                    return Colors.black;
                  }
                  if (index == 17 &&
                      addProvider!.deliverableGroupType != null) {
                    return Colors.black;
                  }
                  if (index == 18 &&
                      addProvider!.selectedZipcodeGroups.isNotEmpty) {
                    return Colors.black;
                  }
                  if (index == 19 &&
                      addProvider!.deliverableCityGroupType != null) {
                    return Colors.black;
                  }
                  if (index == 20 &&
                      addProvider!.selectedCityGroups.isNotEmpty) {
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
