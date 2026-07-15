import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Provider/pickUpLocationProvider.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/CurrentPage%204/Widget/currentSelectedPossitionBord.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage1.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage2.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage3.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommonSwitch.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getIconSelectionDesingWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommonButton.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/attribute_management.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/variant_expansion_widgets.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../../Model/BrandModel/brandModel.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Model/ProductModel/Variants.dart';
import '../../Provider/attributeSetProvider.dart';
import '../../Provider/brandProvider.dart';
import '../../Provider/categoryProvider.dart';
import '../../Provider/countryProvider.dart';
import '../../Provider/editProductProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Provider/taxProvider.dart';
import '../../Provider/zipcodeProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/api.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/snackbar.dart';
import '../HomePage/home.dart';
import '../MediaUpload/Media.dart';

class EditProduct extends StatefulWidget {
  final Product? model;

  const EditProduct({super.key, this.model});

  @override
  State<EditProduct> createState() => _EditProductState();
}

EditProductProvider? editProvider;

class _EditProductState extends State<EditProduct>
    with TickerProviderStateMixin {
  Future<void> _playAnimation() async {
    try {
      await editProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  //------------------------------------------------------------------------------
  //========================= InIt MEthod ========================================
  getAllData() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      await context.read<BrandProvider>().setBrands(false).then((value) {
        if (value == true) {
          setSnackbar(context.read<BrandProvider>().errorMessage, context);
        }
      });
      if (mounted && editProvider!.brandState != null) {
        if (mounted) {
          setState(() {});
        }
      }

      await context
          .read<PickUpLocationProvider>()
          .getPickUpLocations(context, 2)
          .then((value) {
            if (value == true) {
              setSnackbar(
                context.read<PickUpLocationProvider>().errorMessage,
                context,
              );
            }
          });
      if (mounted && editProvider!.pickUpLocationState != null) {
        if (mounted) {
          setState(() {});
        }
      }
      //getBrands();
      await context.read<CountryProvider>().setCountrys(false, false).then((
        value,
      ) {
        if (value == true) {
          setSnackbar(context.read<CountryProvider>().errorMessage, context);
        }
      });
      //get zipCode
      await context
          .read<ZipcodeProvider>()
          .setZipCode(ProductAction.editProduct)
          .then((value) {
            if (value == true) {
              setSnackbar(
                context.read<ZipcodeProvider>().errorMessage,
                context,
              );
            }
          });
      //get zipcode groups
      await context
          .read<ZipcodeProvider>()
          .setZipCodeGroup(
            ProductAction.editProduct,
            ignoreSeller: '0',
            sellerId: context.read<SettingProvider>().CUR_USERID,
          )
          .then((value) {
            if (value == true) {
              setSnackbar(
                context.read<ZipcodeProvider>().errorMessage,
                context,
              );
            }
          });
      //get city groups
      if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
        await context
            .read<CityProvider>()
            .getCitiesGroup(
              isReload: true,
              ignoreSeller: '0',
              sellerId: context.read<SettingProvider>().CUR_USERID,
            )
            .then((value) {
              if (mounted) {
                setState(() {});
              }
            });
      }
      await context.read<CategoryProvider>().setCategory(false, context).then((
        value,
      ) {
        if (value == true) {
          setSnackbar(context.read<CategoryProvider>().errorMessage, context);
        }
      });
      await context.read<TaxProvider>().setTax(false).then((value) {
        if (value == true) {
          setSnackbar(context.read<TaxProvider>().errorMessage, context);
        } else {
          //tax_id
          if (widget.model!.taxId != null) {
            List<String> taxIds = widget.model!.taxId?.split(",") ?? [];
            editProvider!.selectedTax.clear();
            for (int i = 0; i < taxIds.length; i++) {
              if (editProvider!.taxesList.any(
                (element) => element.id == taxIds[i].trim(),
              )) {
                editProvider!.selectedTax.add(editProvider!.taxesList[i]);
              }
            }
            if (mounted) {
              setState(() {});
            }
          }
        }
      });

      // get attribute set
      await context.read<AttributeProvider>().setAttributeSet(false).then((
        value,
      ) {
        if (value == true) {
          setSnackbar(context.read<AttributeProvider>().errorMessage, context);
        }
      });
      // get attribute
      await context.read<AttributeProvider>().setAttributes(false).then((
        value,
      ) {
        if (value == true) {
          setSnackbar(context.read<AttributeProvider>().errorMessage, context);
        }
      });
      // get attribute value
      await context.read<AttributeProvider>().setAttributesValue(false).then((
        value,
      ) {
        if (value == true) {
          setSnackbar(context.read<AttributeProvider>().errorMessage, context);
        }
      });

      // Initialize all variables after all API calls have completed
      initializaAllvariables();

      setState(() {});
    } else {
      setState(() {
        isNetworkAvail = false;
      });
    }
  }

  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    editProvider = Provider.of<EditProductProvider>(context, listen: false);
    editProvider!.freshInitializationOfEditProduct();
    editProvider!.productImage = "";
    editProvider!.productImageRelativePath = "";
    editProvider!.productImageUrl = "";
    // editProvider!.uploadedVideoName = "";
    editProvider!.countryScrollController.addListener(_scrollListener);
    editProvider!.brandScrollController.addListener(_brandScrollListener);
    editProvider!.pickUpLocationScrollController.addListener(
      _pickUpScrollListener,
    );
    editProvider!.uploadedVideoName = widget.model!.video;
    getAllData();
    editProvider!.buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    // editProvider!.uploadedVideoName = '';
    editProvider!.otherPhotos = [];
    editProvider!.showOtherImages = [];

    editProvider!.buttonSqueezeanimation =
        Tween(begin: double.maxFinite, end: 50.0).animate(
          CurvedAnimation(
            parent: editProvider!.buttonController!,
            curve: const Interval(0.0, 0.150),
          ),
        );
    editProvider!.currentPage = 1;
    super.initState();
  }

  _scrollListener() async {
    if (editProvider!.countryScrollController.offset >=
            editProvider!.countryScrollController.position.maxScrollExtent &&
        !editProvider!.countryScrollController.position.outOfRange) {
      if (mounted) {
        setState(() {});

        editProvider!.countryState!(() {
          editProvider!.isLoadingMoreCountry = true;
          editProvider!.isProgress = true;
        });
        await context.read<CountryProvider>().setCountrys(false, false).then((
          value,
        ) {
          if (value == true) {
            setSnackbar(context.read<CountryProvider>().errorMessage, context);
            editProvider!.countryState!(() {
              editProvider!.isLoadingMoreCountry = false;
              editProvider!.isProgress = false;
            });
          } else {
            editProvider!.countryState!(() {
              editProvider!.isLoadingMoreCountry = false;
              editProvider!.isProgress = false;
            });
          }
        });
      }
    }
  }

  _brandScrollListener() async {
    if (editProvider!.brandScrollController.offset >=
            editProvider!.brandScrollController.position.maxScrollExtent &&
        !editProvider!.brandScrollController.position.outOfRange) {
      if (mounted) {
        setState(() {});

        editProvider!.brandState!(() {
          editProvider!.isLoadingMoreBrand = true;
          editProvider!.isProgress = true;
        });

        //get Country
        await context.read<BrandProvider>().setBrands(false).then((value) {
          if (value == true) {
            setSnackbar(context.read<BrandProvider>().errorMessage, context);
          }
        });
        if (mounted && editProvider!.brandState != null) {
          editProvider!.brandState!(() {});
        }
        if (mounted) setState(() {});
      }
    }
  }

  _pickUpScrollListener() async {
    if (editProvider!.pickUpLocationScrollController.offset >=
            editProvider!
                .pickUpLocationScrollController
                .position
                .maxScrollExtent &&
        !editProvider!.pickUpLocationScrollController.position.outOfRange) {
      if (mounted) {
        setState(() {});

        editProvider!.pickUpLocationState!(() {
          editProvider!.isLoadingMoreLocation = true;
          editProvider!.isProgress = true;
        });

        //get Country
        await context
            .read<PickUpLocationProvider>()
            .getPickUpLocations(context, 2)
            .then((value) {
              if (value == true) {
                setSnackbar(
                  context.read<PickUpLocationProvider>().errorMessage,
                  context,
                );
              }
            });
        if (mounted && editProvider!.pickUpLocationState != null) {
          editProvider!.pickUpLocationState!(() {});
        }
        if (mounted) setState(() {});
      }
    }
  }

  void initializaAllvariables() {
    //pro_input_name
    editProvider!.productNameControlller.text = widget.model!.name!;
    editProvider!.productName = editProvider!.productNameControlller.text;
    //hnsCode
    editProvider!.hsnCodeController.text = widget.model!.hsnCodeValue ?? '';
    editProvider!.hsnCode = widget.model!.hsnCodeValue ?? '';
    // short_description
    (widget.model!.shortDescription == null)
        ? ""
        : editProvider!.sortDescriptionControlller.text =
              widget.model!.shortDescription!;
    editProvider!.sortDescription =
        editProvider!.sortDescriptionControlller.text;
    (widget.model!.extraDescription == null)
        ? ""
        : editProvider!.extraDescriptionControlller.text =
              widget.model!.extraDescription!;
    editProvider!.extraDescription =
        editProvider!.extraDescriptionControlller.text;
    // Tags
    editProvider!.tagsControlller.text = widget.model!.tagList!.join(',');

    editProvider!.tags = editProvider!.tagsControlller.text;

    //category_id
    editProvider!.selectedCatName = widget.model!.catName;
    editProvider!.selectedCatID = widget.model!.categoryId;

    //total allowed quantity
    if (widget.model!.totalAllow != null) {
      editProvider!.totalAllowQuantity = widget.model!.totalAllow;
      editProvider!.totalAllowController.text = widget.model!.totalAllow!;
    }
    if (widget.model!.brandName != null) {
      editProvider!.selectedBrandName = widget.model!.brandName;
    }
    if (widget.model!.brandId != null) {
      editProvider!.selectedBrandId = widget.model!.brandId;
      print("brandid form api --- ${editProvider!.selectedBrandId}");
    }
    if (widget.model!.pickupLocationName != null &&
        widget.model!.pickupLocationName!.isNotEmpty) {
      editProvider!.selectedPickUpLocation = widget.model!.pickupLocationName;
    } else if (widget.model!.pickUpLoc != null) {
      editProvider!.selectedPickUpLocation = widget.model!.pickUpLoc;
    }
    //minimam order quantity
    if (widget.model!.minimumOrderQuantity != null) {
      editProvider!.minOrderQuantity = widget.model!.minimumOrderQuantity;
      editProvider!.minOrderQuantityControlller.text =
          widget.model!.minimumOrderQuantity!;
    }
    // Minimum Order Quantity
    if (widget.model!.minimumOrderQuantity == null) {
      editProvider!.minOrderQuantity = "1";
      editProvider!.minOrderQuantityControlller.text = "1";
    }
    //quantity step size
    if (widget.model!.quantityStepSize != null) {
      editProvider!.quantityStepSize = widget.model!.quantityStepSize;
      editProvider!.quantityStepSizeControlller.text =
          widget.model!.quantityStepSize!;
    }
    // Quantity step size
    if (widget.model!.quantityStepSize == null) {
      editProvider!.quantityStepSize = "1";
      editProvider!.quantityStepSizeControlller.text = "1";
    }
    // Made In
    if (widget.model!.madeIn != null) {
      editProvider!.madeIn = widget.model!.madeIn;
      editProvider!.madeInControlller.text = widget.model!.madeIn!;
    }

    //warranty_period
    if (widget.model!.warranty != null) {
      editProvider!.warrantyPeriod = widget.model!.warranty;
      editProvider!.warrantyPeriodController.text = widget.model!.warranty!;
    }
    //guarantee_period
    if (widget.model!.gurantee != null) {
      editProvider!.guaranteePeriod = widget.model!.gurantee;
      editProvider!.guaranteePeriodController.text = widget.model!.gurantee!;
    }
    //deliverable_type

    //low_stock_limit
    if (widget.model!.lowStockLimit != null) {
      editProvider!.lowStockLimit = widget.model!.lowStockLimit;
      editProvider!.lowStockLimitController.text = widget.model!.lowStockLimit!;
    }

    //is_returnable
    if (widget.model!.isReturnable != null) {
      editProvider!.isReturnable = widget.model!.isReturnable;
      editProvider!.isreturnable = widget.model!.isReturnable == "1"
          ? true
          : false;
    }

    if (widget.model!.isAttachmentRequired != null) {
      editProvider!.isAttachmentRequired = widget.model!.isAttachmentRequired;
      editProvider!.isattachmentrequired =
          widget.model!.isAttachmentRequired == "1" ? true : false;
    }
    //is_cancelable
    if (widget.model!.isCancelable != null) {
      editProvider!.isCancelable = widget.model!.isCancelable;
      editProvider!.iscancelable = widget.model!.isCancelable == "1"
          ? true
          : false;
      if (editProvider!.iscancelable) {
        if (widget.model!.cancelableTill != "" &&
            widget.model!.cancelableTill != null) {
          editProvider!.tillwhichstatus = widget.model!.cancelableTill;
        }
      }
    }
    //cod_allowed
    if (widget.model!.isCODAllow != null) {
      editProvider!.isCODAllow = widget.model!.isCODAllow;
      editProvider!.isCODallow = widget.model!.isCODAllow == "1" ? true : false;
    }
    //taxincludedinPrice
    if (widget.model!.taxincludedInPrice != null) {
      editProvider!.taxincludedinPrice = widget.model!.taxincludedInPrice;
      editProvider!.taxincludedInPrice = widget.model!.taxincludedInPrice == "1"
          ? true
          : false;
    }
    // indicator
    if (widget.model!.indicator != null) {
      editProvider!.indicatorValue = widget.model!.indicator;
    }
    //Image
    if (widget.model!.image != null && widget.model!.image != "") {
      editProvider!.productImage = widget.model!.image!;
      editProvider!.productImageUrl = widget.model!.image!;
      editProvider!.productImageRelativePath = widget.model!.relativeImagePath!;
    }
    //video_type
    if (widget.model!.videoType != null && widget.model!.videoType != "") {
      editProvider!.selectedTypeOfVideo = widget.model!.videoType;
      if (widget.model!.video != null && widget.model!.video != "") {
        editProvider!.videoUrl = widget.model!.video;
        editProvider!.vidioTypeController.text = widget.model!.video!;
      }
    }

    //deliverable_type
    if (widget.model!.deliverableType != null) {
      editProvider!.deliverabletypeValue = widget.model!.deliverableType;
    }
    //deliverable_zipcodes
    if (widget.model!.deliverableZipcodes != "") {
      editProvider!.deliverableZipcodes = widget.model!.deliverableZipcodes;
    }
    //deliverable_group_type
    if (widget.model!.deliverableGroupType != null) {
      editProvider!.deliverableGroupType = widget.model!.deliverableGroupType;
    }
    //deliverable_zipcodes_group
    if (widget.model!.deliverableZipcodesGroup != null &&
        widget.model!.deliverableZipcodesGroup != "") {
      // Parse comma-separated IDs and match with zipcode groups fetched for edit
      List<String> groupIds = widget.model!.deliverableZipcodesGroup!.split(
        ',',
      );
      print("Product has zipcode group IDs: $groupIds");
      print(
        "Available zipcode groups: ${editProvider!.zipcodeSearchGroupsList.length}",
      );
      editProvider!.selectedZipcodeGroups = editProvider!
          .zipcodeSearchGroupsList
          .where((group) => groupIds.contains(group.id))
          .toList();
      print(
        "Selected zipcode groups: ${editProvider!.selectedZipcodeGroups.length}",
      );
    }
    //deliverable_ities
    if (widget.model!.deliverableCityType != null &&
        widget.model!.deliverableCityType != "" &&
        AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
      editProvider!.deliverabletypeValue =
          widget.model?.deliverableCityType ?? "";
      editProvider!.deliverableCities = widget.model?.deliverableCities ?? [];
    }
    //deliverable_city_group_type
    if (widget.model!.deliverableCityGroupType != null &&
        widget.model!.deliverableCityGroupType != "" &&
        AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
      editProvider!.deliverableCityGroupType =
          widget.model!.deliverableCityGroupType;
    }
    //deliverable_cities_group
    if (widget.model!.deliverableCitiesGroup != null &&
        widget.model!.deliverableCitiesGroup != "" &&
        AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
      // Parse comma-separated IDs and match with city groups fetched for edit
      List<String> groupIds = widget.model!.deliverableCitiesGroup!.split(',');
      print("Product has city group IDs: $groupIds");
      print(
        "Available city groups: ${context.read<CityProvider>().cityGroupList.length}",
      );
      editProvider!.selectedCityGroups = context
          .read<CityProvider>()
          .cityGroupList
          .where((group) => groupIds.contains(group.id))
          .toList();
      print("Selected city groups: ${editProvider!.selectedCityGroups.length}");
    }
    //Description
    if (widget.model!.description != null) {
      editProvider!.description = widget.model!.description;
    }
    // Multilingual: seed the language tabs — default language from the
    // product's own columns (set above), other languages from translations.
    editProvider!.setContentTranslations(widget.model!.translations);
    for (int i = 0; i <= widget.model!.otherImage!.length; i++) {}

    //Other Images
    if (widget.model!.otherImage != null) {
      editProvider!.otherPhotos = widget.model!.otherImage!;
      editProvider!.showOtherImages = widget.model!.showOtherImage!;
    }
    // Type Of Product
    if (widget.model!.type != null) {
      editProvider!.productType = widget.model!.type;
    }

    //------------------------------------------------------------------------------
    //========================= Simple Product =====================================

    if (editProvider!.productType == "simple_product") {
      // simple product price
      if (widget.model!.sku != null) {
        editProvider!.simpleproductSKU = widget.model!.sku;
        editProvider!.simpleProductSKUController.text = widget.model!.sku!;
      }
      if (widget.model!.stock != null) {
        editProvider!.simpleproductTotalStock = widget.model!.stock;
        editProvider!.simpleProductTotalStock.text = widget.model!.stock!;
      }
      if (widget
              .model!
              .prVarientList![widget.model!.selVarient!]
              .orignalPrice !=
          null) {
        editProvider!.simpleProductPriceController.text = widget
            .model!
            .prVarientList![widget.model!.selVarient!]
            .orignalPrice!;
        editProvider!.simpleproductPrice = widget
            .model!
            .prVarientList![widget.model!.selVarient!]
            .orignalPrice!;
      }
      // simple product special price
      if (widget
              .model!
              .prVarientList![widget.model!.selVarient!]
              .orignalSpecialPrice !=
          null) {
        editProvider!.simpleProductSpecialPriceController.text = widget
            .model!
            .prVarientList![widget.model!.selVarient!]
            .orignalSpecialPrice!;
        editProvider!.simpleproductSpecialPrice = widget
            .model!
            .prVarientList![widget.model!.selVarient!]
            .orignalSpecialPrice!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].height !=
          null) {
        editProvider!.heightController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].height!;
        editProvider!.height =
            widget.model!.prVarientList![widget.model!.selVarient!].height!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].weight !=
          null) {
        editProvider!.weightController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].weight!;
        editProvider!.weight =
            widget.model!.prVarientList![widget.model!.selVarient!].weight!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].breadth !=
          null) {
        editProvider!.breadthController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].breadth!;
        editProvider!.breadth =
            widget.model!.prVarientList![widget.model!.selVarient!].breadth!;
      }

      if (widget.model!.prVarientList![widget.model!.selVarient!].length !=
          null) {
        editProvider!.lengthController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].length!;
        editProvider!.length =
            widget.model!.prVarientList![widget.model!.selVarient!].length!;
      }

      //Enable Stock Management
      if (widget.model!.stockType != '') {
        editProvider!.isStockSelected = true;
      }
      if (widget
              .model!
              .prVarientList![widget.model!.selVarient!]
              .availability !=
          '') {
        editProvider!.simpleproductStockStatus = widget
            .model!
            .prVarientList![widget.model!.selVarient!]
            .availability;
      }
      // for save setting
      editProvider!.simpleProductSaveSettings = true;
      // for variant

      if (widget.model!.attributeList!.isNotEmpty) {
        var index = widget.model!.attributeList!.length;
        for (int i = 0; i < index; i++) {
          var oldListOfAttributeValueID = widget.model!.attributeList![i].id
              .toString()
              .split(',');

          String? oldattributename = widget.model!.attributeList![i].name;
          editProvider!.attrController.add(
            TextEditingController(text: oldattributename),
          );
          editProvider!.variationBoolList.add(true);
          // for get the value of element
          final attributes = editProvider!.attributesList
              .where((element) => element.name == oldattributename)
              .toList();
          String? attributeID;
          for (var element in attributes) {
            attributeID = element.id;
          }
          List<AttributeValueModel> tempagain = [];
          for (var element in oldListOfAttributeValueID) {
            final tempvar = editProvider!.attributesValueList
                .where((e) => e.id == element)
                .toList();
            if (tempvar.isNotEmpty) {
              tempagain.add(tempvar[0]);
            }
          }
          if (attributeID != null) {
            editProvider!.selectedAttributeValues[attributeID] = tempagain;
          }
        }
        editProvider!.attributeIndiacator = editProvider!.attrController.length;
        if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
          var index = widget.model!.prVarientList!.length;
          for (int i = 0; i < index; i++) {
            //old variant id
            editProvider!.oldVariantId = () {
              if (editProvider!.oldVariantId == "") {
                return widget.model!.prVarientList![i].id;
              } else {
                return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
              }
            }();
          }
        }
      }
    }
    //----------------------------------------------------------------------------
    //========================= Variant Product ==================================

    if (editProvider!.productType == "variable_product") {
      List<String> colCount = [];
      // logic for stock is enable or not .
      if (widget.model!.stockType == "null") {
        // product level but stock management dissable
        editProvider!.isStockSelected = false;
      }
      if (widget.model!.stockType == "") {
        editProvider!.variantProductProductLevelSaveSettings = true;
        editProvider!.isStockSelected = false;
        // For variant
        if (widget.model!.attributeList!.isEmpty.toString() == "false") {
          var index = widget.model!.attributeList!.length;
          for (int i = 0; i < index; i++) {
            var oldListOfAttributeValueID = widget.model!.attributeList![i].id
                .toString()
                .split(',');
            //old variant id

            String? oldattributename = widget.model!.attributeList![i].name;
            editProvider!.attrController.add(
              TextEditingController(text: oldattributename),
            );
            editProvider!.variationBoolList.add(true);
            // for get the value of element
            final attributes = editProvider!.attributesList
                .where((element) => element.name == oldattributename)
                .toList();
            String? attributeID;
            for (var element in attributes) {
              attributeID = element.id;
            }
            List<AttributeValueModel> tempagain = [];
            for (var element in oldListOfAttributeValueID) {
              final tempvar = editProvider!.attributesValueList
                  .where((e) => e.id == element)
                  .toList();
              if (tempvar.isNotEmpty) {
                tempagain.add(tempvar[0]);
              }
            }
            if (attributeID != null) {
              editProvider!.selectedAttributeValues[attributeID] = tempagain;
            }
          }
          editProvider!.attributeIndiacator =
              editProvider!.attrController.length;
          if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
            var index = widget.model!.prVarientList!.length;
            for (int i = 0; i < index; i++) {
              //old variant id
              editProvider!.oldVariantId = () {
                if (editProvider!.oldVariantId == "") {
                  return widget.model!.prVarientList![i].id;
                } else {
                  return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
                }
              }();
            }
          }
        }
        for (int i = 0; i < widget.model!.prVarientList!.length; i++) {
          editProvider!.variationList.add(widget.model!.prVarientList![i]);
          colCount = editProvider!.variationList[i].attr_name!.split(',');
        }
        editProvider!.col = colCount.length;
        editProvider!.row = widget.model!.prVarientList!.length;

        //===============================================================
      }
      if (widget.model!.stockType == "1") {
        // enable and product level
        editProvider!.isStockSelected = true;
        editProvider!.variantStockLevelType = 'product_level';
        editProvider!.variantProductProductLevelSaveSettings = true;
        if (widget.model!.prVarientList!.isNotEmpty) {
          if (widget.model!.prVarientList![0].sku != "") {
            editProvider!.variountProductSKUController.text =
                widget.model!.prVarientList![0].sku!;
            editProvider!.variantproductSKU =
                widget.model!.prVarientList![0].sku!;
          }
        }
        if (widget.model!.prVarientList![0].stock! != "") {
          editProvider!.variountProductTotalStock.text =
              widget.model!.prVarientList![0].stock!;
          editProvider!.variantproductTotalStock =
              widget.model!.prVarientList![0].stock!;
        }
        editProvider!.stockStatus = widget.model!.stockType!;

        // For variant =========================================================
        //======================================================================

        if (widget.model!.attributeList!.isEmpty.toString() == "false") {
          var index = widget.model!.attributeList!.length;
          for (int i = 0; i < index; i++) {
            var oldListOfAttributeValueID = widget.model!.attributeList![i].id
                .toString()
                .split(',');
            //old variant id

            String? oldattributename = widget.model!.attributeList![i].name;
            editProvider!.attrController.add(
              TextEditingController(text: oldattributename),
            );
            editProvider!.variationBoolList.add(true);
            // for get the value of element
            final attributes = editProvider!.attributesList
                .where((element) => element.name == oldattributename)
                .toList();
            String? attributeID;
            for (var element in attributes) {
              attributeID = element.id;
            }
            List<AttributeValueModel> tempagain = [];
            for (var element in oldListOfAttributeValueID) {
              final tempvar = editProvider!.attributesValueList
                  .where((e) => e.id == element)
                  .toList();
              if (tempvar.isNotEmpty) {
                tempagain.add(tempvar[0]);
              }
            }
            if (attributeID != null) {
              editProvider!.selectedAttributeValues[attributeID] = tempagain;
            }
          }
          editProvider!.attributeIndiacator =
              editProvider!.attrController.length;
          if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
            var index = widget.model!.prVarientList!.length;
            for (int i = 0; i < index; i++) {
              //old variant id
              editProvider!.oldVariantId = () {
                if (editProvider!.oldVariantId == "") {
                  return widget.model!.prVarientList![i].id;
                } else {
                  return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
                }
              }();
            }
          }
        }
        editProvider!.variationList.clear();
        for (int i = 0; i < widget.model!.prVarientList!.length; i++) {
          editProvider!.variationList.add(widget.model!.prVarientList![i]);
          colCount = editProvider!.variationList[i].attr_name!.split(',');
        }

        editProvider!.col = colCount.length;
        editProvider!.row = widget.model!.prVarientList!.length;

        //==============================================================================
        //==============================================================================
      }
      if (widget.model!.stockType == "2") {
        // enable and variable level
        // complete
        editProvider!.isStockSelected = true;
        editProvider!.variantStockLevelType = 'variable_level';
        editProvider!.variantProductVariableLevelSaveSettings = true;
        // For Atttribute Value
        //======================================================================
        if (widget.model!.attributeList!.isEmpty.toString() == "false") {
          var index = widget.model!.attributeList!.length;
          for (int i = 0; i < index; i++) {
            var oldListOfAttributeValueID = widget.model!.attributeList![i].id
                .toString()
                .split(',');
            //old variant id
            String? oldattributename = widget.model!.attributeList![i].name;
            editProvider!.attrController.add(
              TextEditingController(text: oldattributename),
            );
            editProvider!.variationBoolList.add(true);
            // for get the value of element
            final attributes = editProvider!.attributesList
                .where((element) => element.name == oldattributename)
                .toList();
            String? attributeID;
            for (var element in attributes) {
              attributeID = element.id;
            }
            List<AttributeValueModel> tempagain = [];
            for (var element in oldListOfAttributeValueID) {
              List<AttributeValueModel> tempvar = editProvider!
                  .attributesValueList
                  .where((e) => e.id == element)
                  .toList();
              if (tempvar.isNotEmpty) {
                tempagain.add(tempvar[0]);
              }
            }
            if (attributeID != null) {
              editProvider!.selectedAttributeValues[attributeID] = tempagain;
            }
          }
          editProvider!.attributeIndiacator =
              editProvider!.attrController.length;
          if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
            var index = widget.model!.prVarientList!.length;
            for (int i = 0; i < index; i++) {
              //old variant id
              editProvider!.oldVariantId = () {
                if (editProvider!.oldVariantId == "") {
                  return widget.model!.prVarientList![i].id;
                } else {
                  return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
                }
              }();
            }
          }
        }
        editProvider!.variationList.clear();
        for (int i = 0; i < widget.model!.prVarientList!.length; i++) {
          editProvider!.variationList.add(widget.model!.prVarientList![i]);
          colCount = editProvider!.variationList[i].attr_name!.split(',');
        }
        int i = 0;
        for (var _ in editProvider!.variationList) {
          i = i + 1;
        }
        editProvider!.col = colCount.length;
        editProvider!.row = widget.model!.prVarientList!.length;
      }
    }

    //----------------------------------------------------------------------------
    //========================= Variant Product ==================================

    if (editProvider!.productType == "digital_product") {
      editProvider!.currentSellectedProductIsPysical = false;
      //
      if (widget.model!.prVarientList![widget.model!.selVarient!].price !=
          null) {
        editProvider!.digitalPriceController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].price!;

        // editProvider!.simpleproductPrice =
        //     widget.model!.prVarientList![widget.model!.selVarient!].price!;
      }
      // simple product special price
      if (widget.model!.prVarientList![widget.model!.selVarient!].disPrice !=
          null) {
        editProvider!.digitalSpecialController.text =
            widget.model!.prVarientList![widget.model!.selVarient!].disPrice!;
      }
      if (widget.model!.downloadAllowed != null) {
        editProvider!.digitalProductDownloaded =
            widget.model!.downloadAllowed == "1" ? true : false;
        if (widget.model!.downloadAllowed == "1") {
          if (widget.model!.downloadType == "self_hosted") {
            editProvider!.selectedDigitalProductTypeOfDownloadLink =
                'self_hosted';
            editProvider!.digitalProductNamePathNameForSelectedFile =
                widget.model!.downloadLink!;
            // code is painding for selfhosted
          }
          if (widget.model!.downloadType == "add_link") {
            editProvider!.selectedDigitalProductTypeOfDownloadLink = 'Add Link';
            editProvider!.selfHostedDigitalProductURLController.text =
                widget.model!.downloadLink ?? "";
          }
          if (widget.model!.downloadLink == "" ||
              widget.model!.downloadLink == null) {
            editProvider!.selectedDigitalProductTypeOfDownloadLink =
                'self_hosted';
          }
        }
      }

      // for attribute
      editProvider!.digitalProductSaveSettings = true;

      if (widget.model!.attributeList!.isEmpty.toString() == "false") {
        var index = widget.model!.attributeList!.length;
        for (int i = 0; i < index; i++) {
          var oldListOfAttributeValueID = widget.model!.attributeList![i].id
              .toString()
              .split(',');

          String? oldattributename = widget.model!.attributeList![i].name;
          editProvider!.attrController.add(
            TextEditingController(text: oldattributename),
          );
          editProvider!.variationBoolList.add(true);
          // for get the value of element
          final attributes = editProvider!.attributesList
              .where((element) => element.name == oldattributename)
              .toList();
          String? attributeID;
          for (var element in attributes) {
            attributeID = element.id;
          }
          List<AttributeValueModel> tempagain = [];
          for (var element in oldListOfAttributeValueID) {
            final tempvar = editProvider!.attributesValueList
                .where((e) => e.id == element)
                .toList();
            if (tempvar.isNotEmpty) {
              tempagain.add(tempvar[0]);
            }
          }
          if (attributeID != null) {
            editProvider!.selectedAttributeValues[attributeID] = tempagain;
          }
        }
        editProvider!.attributeIndiacator = editProvider!.attrController.length;
        if (widget.model!.prVarientList!.isEmpty.toString() == "false") {
          var index = widget.model!.prVarientList!.length;
          for (int i = 0; i < index; i++) {
            //old variant id
            editProvider!.oldVariantId = () {
              if (editProvider!.oldVariantId == "") {
                return widget.model!.prVarientList![i].id;
              } else {
                return "${editProvider!.oldVariantId!},${widget.model!.prVarientList![i].id!}";
              }
            }();
          }
        }
      }
    } else {
      editProvider!.currentSellectedProductIsPysical = true;
    }
    //------------------------------------------------------------------------------
    //========================= Loading Indiacator =================================

    setState(() {
      editProvider!.isLoading = false;
    });
  }

  Future<void> getBrands() async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    var parameter = {
      // SellerId: context.read<SettingProvider>().CUR_USERID,
    };
    apiBaseHelper
        .postAPICall(getBrandsDataApi, parameter)
        .then(
          (getdata) async {
            bool error = getdata["error"];
            String? msg = getdata["message"];

            if (!error) {
              editProvider!.brandList.clear();
              var data = getdata["data"];
              editProvider!.brandList = (data as List)
                  .map((data) => BrandModel.fromJson(data))
                  .toList();
            } else {
              setSnackbar(msg!, context);
            }
          },
          onError: (error) {
            setSnackbar(error.toString(), context);
          },
        );
  }

  //------------------------------------------------------------------------------
  //========================= Other Image ========================================

  // logic painding

  //------------------------------------------------------------------------------
  //========================= Additional Info ====================================

  additionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        currentSelectedPossitionBord(context, setStateNow),
        if (editProvider!.curSelPos == 0) _buildProductTypeSection(),
        if (editProvider!.curSelPos == 1) _buildAttributesManagementSection(),
        if (editProvider!.curSelPos == 2) _buildVariantsListSection(),
      ],
    );
  }

  getCombination(List<String> att, List<String> attId, int i) {
    for (int j = 0, l = editProvider!.finalAttList[i].length; j < l; j++) {
      List<String> a = [];
      List<String> aId = [];
      if (att.isNotEmpty) {
        a.addAll(att);
        aId.addAll(attId);
      }
      a.add(editProvider!.finalAttList[i][j].value!);
      aId.add(editProvider!.finalAttList[i][j].id!);

      if (i == editProvider!.max) {
        editProvider!.resultAttr.addAll(a);
        editProvider!.resultID.addAll(aId);

        Product_Varient model = Product_Varient(
          attr_name: a.join(","),
          id: aId.join(","),
        );

        editProvider!.variationList.add(model);
      } else {
        getCombination(a, aId, i + 1);
      }
    }
  }

  // ========== variant Product Price add In side the variant price add ==========

  update() {
    setState(() {});
  }

  /// Product Type Section - Shows product type selector and relevant form fields
  Widget _buildProductTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductTypeSelector(),
        _buildSimpleProductFields(),
        _buildSimpleProductStockSection(),
        _buildVariableProductStockSection(),
        _buildDigitalProductSection(),
      ],
    );
  }

  /// Product Type Selector
  Widget _buildProductTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCommanSizedBox(),
        getPrimaryCommanText(
          "Type Of Product".translate(context: context),
          false,
        ),
        getCommanSizedBox(),
        getIconSelectionDesing(
          "Select Type".translate(context: context),
          9,
          context,
          setStateNow,
        ),
      ],
    );
  }

  /// Simple Product Fields - Price, dimensions, stock enable checkbox
  Widget _buildSimpleProductFields() {
    if (editProvider!.productType != 'simple_product') {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCommanSizedBox(),
        getCommanSizedBox(),
        // Price and Special Price Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getPrimaryCommanText(
                    "PRICE_LBL".translate(context: context),
                    true,
                  ),
                  const SizedBox(height: 5),
                  getCommanInputTextField(" ", 10, 0.06, 0.44, 3, context),
                ],
              ),
            ),
            getCommanSizedBoxWidth(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getPrimaryCommanText(
                    "Special Price".translate(context: context),
                    true,
                  ),
                  const SizedBox(height: 5),
                  getCommanInputTextField(" ", 11, 0.06, 0.44, 3, context),
                ],
              ),
            ),
          ],
        ),
        getCommanSizedBox(),
        // Weight
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText(
                "Weight (kg)".translate(context: context),
                true,
              ),
            ),
            Expanded(
              flex: 3,
              child: getCommanInputTextField(" ", 22, 0.06, 1, 3, context),
            ),
          ],
        ),
        getCommanSizedBox(),
        // Height
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText(
                "Height (cms)".translate(context: context),
                true,
              ),
            ),
            Expanded(
              flex: 3,
              child: getCommanInputTextField(" ", 23, 0.06, 1, 3, context),
            ),
          ],
        ),
        getCommanSizedBox(),
        // Breadth
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText(
                "Breadth (cms)".translate(context: context),
                true,
              ),
            ),
            Expanded(
              flex: 3,
              child: getCommanInputTextField(" ", 24, 0.06, 1, 3, context),
            ),
          ],
        ),
        getCommanSizedBox(),
        // Length
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText(
                "Length (cms)".translate(context: context),
                true,
              ),
            ),
            Expanded(
              flex: 3,
              child: getCommanInputTextField(" ", 25, 0.06, 1, 3, context),
            ),
          ],
        ),
        getCommanSizedBox(),
        getCommanSizedBox(),
        getCommanSizedBox(),
        getCommonButton(
          "Save Settings".translate(context: context),
          4,
          setStateNow,
          context,
        ),
      ],
    );
  }

  /// Simple Product Stock Section
  Widget _buildSimpleProductStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (editProvider!.productType != 'digital_product')
          Row(
            children: [
              Expanded(
                flex: 5,
                child: getPrimaryCommanText(
                  "Enable Stock Management".translate(context: context),
                  true,
                ),
              ),
              Expanded(
                flex: 2,
                child: CheckboxListTile(
                  value: editProvider!.isStockSelected ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      editProvider!.isStockSelected = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true &&
            editProvider!.productType == 'simple_product')
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        getPrimaryCommanText(
                          "SKU".translate(context: context),
                          true,
                        ),
                        const SizedBox(height: 5),
                        getCommanInputTextField(
                          " ",
                          12,
                          0.06,
                          0.44,
                          2,
                          context,
                        ),
                      ],
                    ),
                  ),
                  getCommanSizedBoxWidth(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        getPrimaryCommanText(
                          "Total Stock".translate(context: context),
                          true,
                        ),
                        const SizedBox(height: 5),
                        getCommanInputTextField(
                          " ",
                          13,
                          0.06,
                          0.44,
                          3,
                          context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              getCommanSizedBox(),
              getIconSelectionDesing(
                "Select Stock Status".translate(context: context),
                10,
                context,
                setStateNow,
              ),
            ],
          ),
      ],
    );
  }

  /// Variable Product Stock Section
  Widget _buildVariableProductStockSection() {
    if (editProvider!.productType != 'variable_product') {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true)
          getPrimaryCommanText(
            "Choose Stock Management Type".translate(context: context),
            false,
          ),
        getCommanSizedBox(),
        if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true)
          getIconSelectionDesing(
            "Select Stock Status".translate(context: context),
            11,
            context,
            setStateNow,
          ),
        if (editProvider!.variantStockLevelType == "product_level" &&
            editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCommanSizedBox(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getPrimaryCommanText(
                          "SKU".translate(context: context),
                          true,
                        ),
                        const SizedBox(height: 5),
                        getCommanInputTextField(
                          " ",
                          14,
                          0.06,
                          0.44,
                          2,
                          context,
                        ),
                      ],
                    ),
                  ),
                  getCommanSizedBoxWidth(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getPrimaryCommanText(
                          "Total Stock".translate(context: context),
                          true,
                        ),
                        const SizedBox(height: 5),
                        getCommanInputTextField(
                          " ",
                          15,
                          0.06,
                          0.44,
                          3,
                          context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              getCommanSizedBox(),
              getPrimaryCommanText(
                "STOCK_STATUS".translate(context: context),
                false,
              ),
              getCommanSizedBox(),
              getIconSelectionDesing(
                "Select Stock Status".translate(context: context),
                12,
                context,
                setStateNow,
              ),
            ],
          ),
        getCommanSizedBox(),
        getCommanSizedBox(),
        if (editProvider!.variantStockLevelType == "product_level")
          getCommonButton(
            "Save Settings".translate(context: context),
            5,
            setStateNow,
            context,
          ),
        if (editProvider!.variantStockLevelType == "variable_level")
          getCommonButton(
            "Save Settings".translate(context: context),
            6,
            setStateNow,
            context,
          ),
      ],
    );
  }

  /// Digital Product Section
  Widget _buildDigitalProductSection() {
    if (editProvider!.productType != 'digital_product') {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText(
                "PRICE_LBL".translate(context: context),
                true,
              ),
            ),
            Expanded(
              flex: 3,
              child: getCommanInputTextField(" ", 17, 0.06, 1, 3, context),
            ),
          ],
        ),
        getCommanSizedBox(),
        // Special Price
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText(
                "Special Price".translate(context: context),
                true,
              ),
            ),
            Expanded(
              flex: 3,
              child: getCommanInputTextField(" ", 18, 0.06, 1, 3, context),
            ),
          ],
        ),
        getCommanSizedBox(),
        // Download allowed
        Row(
          children: [
            Expanded(
              flex: 2,
              child: getPrimaryCommanText("Is Download allowed?", true),
            ),
            getCommanSwitch(5, setState),
          ],
        ),
        getCommanSizedBox(),
        // Download Link Type
        if (editProvider!.digitalProductDownloaded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getPrimaryCommanText('Download Link Type', false),
              getCommanSizedBox(),
              getIconSelectionDesing("Select Type", 14, context, setState),
              if (editProvider!.selectedDigitalProductTypeOfDownloadLink ==
                  'self_hosted') ...[
                getCommanSizedBox(),
                getCommanSizedBox(),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(
                        circularBorderRadius7,
                      ),
                    ),
                    width: 90,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Upload".translate(context: context),
                        style: const TextStyle(color: white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Media(
                          from: "archive,document",
                          pos: 0,
                          type: "edit",
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  },
                ),
              ],
              if (editProvider!.selectedDigitalProductTypeOfDownloadLink ==
                      'self_hosted' &&
                  editProvider!.digitalProductNamePathNameForSelectedFile != '')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.file_open_rounded),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          editProvider!
                              .digitalProductNamePathNameForSelectedFile,
                          maxLines: 10,
                          softWrap: true,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (editProvider!.selectedDigitalProductTypeOfDownloadLink ==
                  'Add Link') ...[
                getCommanSizedBox(),
                getPrimaryCommanText('Digital Product Link', false),
                getCommanSizedBox(),
                getCommanInputTextField(
                  'Paste digital product link or URL here',
                  19,
                  0.06,
                  1,
                  2,
                  context,
                ),
              ],
            ],
          ),
        getCommanSizedBox(),
        // Save Settings Button
        InkWell(
          onTap: () {
            if (editProvider!.digitalPriceController.text.isEmpty) {
              setSnackbar(
                "Please enter product price".translate(context: context),
                context,
              );
            } else if (editProvider!.digitalSpecialController.text.isEmpty) {
              editProvider!.digitalProductSaveSettings = true;
              setSnackbar(
                "Setting saved successfully".translate(context: context),
                context,
              );
              setState(() {});
            } else if (int.parse(editProvider!.digitalPriceController.text) <
                int.parse(editProvider!.digitalSpecialController.text)) {
              setSnackbar(
                "Special price must be less than original price".translate(
                  context: context,
                ),
                context,
              );
            } else {
              editProvider!.digitalProductSaveSettings = true;
              setSnackbar(
                "Setting saved successfully".translate(context: context),
                context,
              );
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius7),
              color: primary,
            ),
            height: 35,
            child: Center(
              child: Text(
                "Save Settings".translate(context: context),
                style: const TextStyle(
                  fontSize: textFontSize16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Attributes Management Section - Add/Save buttons and attribute cards
  Widget _buildAttributesManagementSection() {
    if (!(editProvider!.simpleProductSaveSettings ||
        editProvider!.variantProductVariableLevelSaveSettings ||
        editProvider!.variantProductProductLevelSaveSettings ||
        editProvider!.digitalProductSaveSettings)) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        getCommanSizedBox(),
        getCommanSizedBox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            getCommanSizedBox(),
            getPrimaryCommanText(
              "Attributes".translate(context: context),
              false,
            ),
            getCommanSizedBox(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: white,
                      side: const BorderSide(color: black),
                      minimumSize: Size(width * 0.43, height * 0.06),
                    ),
                    onPressed: () {
                      if (editProvider!.attributeIndiacator ==
                          editProvider!.attrController.length) {
                        setState(() {
                          editProvider!.attrController.add(
                            TextEditingController(),
                          );
                          editProvider!.variationBoolList.add(false);
                        });
                      } else {
                        setSnackbar(
                          "fill the box then add another".translate(
                            context: context,
                          ),
                          context,
                        );
                      }
                    },
                    child: Text(
                      "Add Attribute".translate(context: context),
                      style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                getCommanSizedBoxWidth(),
                Expanded(
                  child: OutlinedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: black,
                      minimumSize: Size(width * 0.43, height * 0.06),
                    ),
                    onPressed: () {
                      editProvider!.tempAttList.clear();
                      List<String> attributeIds = [];
                      for (
                        var i = 0;
                        i < editProvider!.variationBoolList.length;
                        i++
                      ) {
                        if (editProvider!.variationBoolList[i]) {
                          final attributes = editProvider!.attributesList
                              .where(
                                (element) =>
                                    element.name ==
                                    editProvider!.attrController[i].text,
                              )
                              .toList();
                          if (attributes.isNotEmpty) {
                            attributeIds.add(attributes.first.id!);
                          }
                        }
                      }
                      setState(() {
                        editProvider!.resultAttr = [];
                        editProvider!.resultID = [];
                        editProvider!.variationList = [];
                        editProvider!.finalAttList = [];
                        for (var key in attributeIds) {
                          editProvider!.tempAttList.add(
                            editProvider!.selectedAttributeValues[key]!,
                          );
                        }
                        for (
                          int i = 0;
                          i < editProvider!.tempAttList.length;
                          i++
                        ) {
                          editProvider!.finalAttList.add(
                            editProvider!.tempAttList[i],
                          );
                        }
                        if (editProvider!.finalAttList.isNotEmpty) {
                          editProvider!.max =
                              editProvider!.finalAttList.length - 1;

                          getCombination([], [], 0);
                          editProvider!.row = 1;
                          editProvider!.col = editProvider!.max! + 1;
                          for (int i = 0; i < editProvider!.col!; i++) {
                            int singleRow =
                                editProvider!.finalAttList[i].length;
                            editProvider!.row = editProvider!.row * singleRow;
                          }
                        }
                        setSnackbar(
                          "Attributes saved successfully".translate(
                            context: context,
                          ),
                          context,
                        );
                      });
                    },
                    child: Text(
                      "Save Attribute".translate(context: context),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        getCommanSizedBox(),
        if (editProvider!.productType == 'variable_product')
          Text(
            "Note : select checkbox if the attribute is to be used for variation"
                .translate(context: context),
          ),
        getCommanSizedBox(),
        for (int i = 0; i < editProvider!.attrController.length; i++)
          buildAttributeCard(
            context,
            editProvider!,
            i,
            width,
            setState,
            update,
          ),
      ],
    );
  }

  /// Variants List Section - Expansion tiles with variant details
  Widget _buildVariantsListSection() {
    if (editProvider!.variationList.isEmpty) {
      return Container();
    }

    return ListView.builder(
      itemCount: editProvider!.row,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        print(
          "variation attribute----->${editProvider!.variationList.first.varient_value}",
        );
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: grey1,
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              border: Border.all(color: grey2, width: 1),
            ),
            child: ExpansionTile(
              textColor: Colors.green,
              title: Row(
                children: [
                  for (int j = 0; j < editProvider!.col!; j++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          editProvider!.variationList[i].varient_value!.split(
                            ',',
                          )[j],
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.delete_outline, color: primary),
                    ),
                    onTap: () {
                      editProvider!.variationList.removeAt(i);
                      editProvider!.row = editProvider!.row - 1;
                      setState(() {});
                    },
                  ),
                ],
              ),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCommanSizedBoxWidth(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: buildExpandableContent(
                              i,
                              context,
                              editProvider!,
                            ),
                          ),
                        ),
                        getCommanSizedBoxWidth(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: buildExpandableContent2(
                              i,
                              context,
                              editProvider!,
                            ),
                          ),
                        ),
                        getCommanSizedBoxWidth(),
                      ],
                    ),
                    ...buildExpandableContent3(
                      i,
                      context,
                      editProvider!,
                      width,
                      update,
                      () => setState(() {}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //==============================================================================
  //=========================== Add Product API Call =============================

  currentPage4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [additionalInfo()],
    );
  }

  //==============================================================================
  //=========================== Description ======================================

  getButtomBarButton() {
    return Positioned.directional(
      bottom: 0.0,
      textDirection: Directionality.of(context),
      child: Container(
        width: width,
        height: 65,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
          child: Row(
            children: [
              editProvider!.currentPage != 1
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          if (editProvider!.currentPage == 1) {
                          } else if (editProvider!.currentPage == 2) {
                            editProvider!.currentPage = 1;
                          } else if (editProvider!.currentPage == 3) {
                            editProvider!.currentPage = 2;
                          } else if (editProvider!.currentPage == 4) {
                            editProvider!.currentPage = 3;
                          }
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              circularBorderRadius7,
                            ),
                            color: white,
                            border: Border.all(color: black),
                          ),
                          height: 40,
                          child: Center(
                            child: Text(
                              "Back".translate(context: context),
                              style: const TextStyle(
                                fontSize: textFontSize16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              editProvider!.currentPage != 1
                  ? const SizedBox(width: 10)
                  : const SizedBox.shrink(),
              Expanded(
                child: AppBtn(
                  onBtnSelected: () async {
                    if (editProvider!.currentPage == 1) {
                      if (editProvider!.productName == null ||
                          editProvider!.productName == '') {
                        setSnackbar(
                          "Please select product Name".translate(
                            context: context,
                          ),
                          context,
                        );
                      } else if (editProvider!.hsnCode == null) {
                        setSnackbar('Please Add HSN Code', context);
                      } else if (editProvider!.sortDescription == null ||
                          editProvider!.sortDescription == '') {
                        setSnackbar(
                          "Please Add Short Description".translate(
                            context: context,
                          ),
                          context,
                        );
                      } else {
                        setState(() {
                          editProvider!.currentPage = 2;
                        });
                      }
                    } else if (editProvider!.currentPage == 2) {
                      if (editProvider!.minOrderQuantity == null ||
                          editProvider!.minOrderQuantity == '') {
                        setSnackbar(
                          "Please Add minimam Order Quantity".translate(
                            context: context,
                          ),
                          context,
                        );
                      } else if (editProvider!.quantityStepSize == null ||
                          editProvider!.quantityStepSize == '') {
                        setSnackbar(
                          "Please Add Quantity Step Size".translate(
                            context: context,
                          ),
                          context,
                        );
                      } else if (editProvider!.selectedCatID == null ||
                          editProvider!.selectedCatID == '') {
                        setSnackbar(
                          "Please select category".translate(context: context),
                          context,
                        );
                      } else {
                        setState(() {
                          editProvider!.currentPage = 3;
                        });
                      }
                    } else if (editProvider!.currentPage == 3) {
                      if (editProvider!.productImage == "") {
                        setSnackbar(
                          "Please Add Product Main Image".translate(
                            context: context,
                          ),
                          context,
                        );
                      }
                      /*else if ((editProvider!.description == '' ||
                          editProvider!.description == null)) {
                        setSnackbar(
                          "Please Add Description".translate(context: context),
                          context,
                        );
                      }*/
                      else {
                        setState(() {
                          editProvider!.currentPage = 4;
                        });
                      }
                    } else if (editProvider!.currentPage == 4) {
                      validateAndSubmit();
                    }
                  },
                  height: 40,
                  title: editProvider!.currentPage != 4
                      ? "Next".translate(context: context)
                      : "Edit Product".translate(context: context),
                  btnAnim: editProvider!.buttonSqueezeanimation,
                  btnCntrl: editProvider!.buttonController,
                  paddingRequired: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //==============================================================================
  //=========================== Body Part ========================================

  getBodyPart() {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: editProvider!.formkey,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 20,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editProvider!.currentPage == 1
                        ? currentPage1(context, setStateNow)
                        : Container(),
                    editProvider!.currentPage == 2
                        ? currentPage2(context, setStateNow)
                        : Container(),
                    editProvider!.currentPage == 3
                        ? currentPage3(context, setStateNow)
                        : Container(),
                    editProvider!.currentPage == 4
                        ? currentPage4()
                        : Container(),
                    const SizedBox(height: 65),
                  ],
                ),
              ),
            ),
          ),
          getButtomBarButton(),
        ],
      ),
    );
  }

  void validateAndSubmit() async {
    List<String> attributeIds = [];
    List<String> attributesValuesIds = [];

    for (var i = 0; i < editProvider!.variationBoolList.length; i++) {
      if (editProvider!.variationBoolList[i]) {
        final attributes = editProvider!.attributesList
            .where(
              (element) => element.name == editProvider!.attrController[i].text,
            )
            .toList();
        if (attributes.isNotEmpty) {
          attributeIds.add(attributes.first.id!);
        }
      }
    }
    for (var key in attributeIds) {
      for (var element in editProvider!.selectedAttributeValues[key]!) {
        attributesValuesIds.add(element.id!);
      }
    }

    if (validateAndSave()) {
      _playAnimation();
      editProvider!.addProductAPI(
        attributesValuesIds,
        context,
        update,
        widget.model!.id!,
      );
    }
  }

  bool validateAndSave() {
    final form = editProvider!.formkey.currentState!;
    form.save();
    if (form.validate()) {
      if (editProvider!.productImage == '' &&
          editProvider!.mainImageProductImage == "") {
        setSnackbar(
          "Please Add product image".translate(context: context),
          context,
        );
        return false;
      } else if (editProvider!.selectedCatID == null) {
        setSnackbar(
          "Please select category".translate(context: context),
          context,
        );
        return false;
      } else if (editProvider!.selectedTypeOfVideo != null &&
          (editProvider!.selectedTypeOfVideo.toString().toLowerCase() ==
                  'vimeo' ||
              editProvider!.selectedTypeOfVideo.toString().toLowerCase() ==
                  'youtube') &&
          (editProvider!.videoUrl == null ||
              editProvider!.videoUrl.toString().trim().isEmpty)) {
        setSnackbar(
          "Please enter video url".translate(context: context),
          context,
        );
        return false;
      } else if (editProvider!.selectedTypeOfVideo != null &&
          editProvider!.selectedTypeOfVideo.toString().toLowerCase() ==
              'self_hosted' &&
          editProvider!.uploadedVideoName == '') {
        setSnackbar(
          'PLZ_SEL_SELF_HOSTED_VIDEO'.translate(context: context),
          context,
        );
        return false;
      } else if (editProvider!.productType == null) {
        setSnackbar(
          "Please select product type".translate(context: context),
          context,
        );
        return false;
      } else if (editProvider!.productType == 'simple_product') {
        if (editProvider!.simpleProductPriceController.text.isEmpty) {
          setSnackbar(
            "Please enter product price".translate(context: context),
            context,
          );
          return false;
        } else if (editProvider!.simpleProductPriceController.text.isNotEmpty &&
            editProvider!.simpleProductSpecialPriceController.text.isNotEmpty &&
            double.parse(
                  editProvider!.simpleProductSpecialPriceController.text,
                ) >
                double.parse(editProvider!.simpleProductPriceController.text)) {
          setSnackbar(
            "Special price can not greater than price".translate(
              context: context,
            ),
            context,
          );
          return false;
        } else if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true) {
          if (editProvider!.simpleproductSKU == null ||
              editProvider!.simpleproductTotalStock == null) {
            setSnackbar(
              "Please enter stock details".translate(context: context),
              context,
            );
            return false;
          }

          return true;
        }
        return true;
      } else if (editProvider!.productType == 'variable_product') {
        for (int i = 0; i < editProvider!.variationList.length; i++) {
          if (editProvider!.variationList[i].price == null ||
              editProvider!.variationList[i].price!.isEmpty) {
            setSnackbar(
              "Please enter price details".translate(context: context),
              context,
            );
            return false;
          }
        }
        if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true) {
          if (editProvider!.variantStockLevelType == "product_level" &&
              (editProvider!.variantproductSKU == null ||
                  editProvider!.variantproductTotalStock == null)) {
            setSnackbar(
              "Please enter stock details".translate(context: context),
              context,
            );
            return false;
          }

          if (editProvider!.variantStockLevelType == "variable_level") {
            for (int i = 0; i < editProvider!.variationList.length; i++) {
              if (editProvider!.variationList[i].sku == null ||
                  editProvider!.variationList[i].sku!.isEmpty ||
                  editProvider!.variationList[i].stock == null ||
                  editProvider!.variationList[i].stock!.isEmpty) {
                setSnackbar(
                  "Please enter stock details".translate(context: context),
                  context,
                );
                return false;
              }
            }

            return true;
          }
          return true;
        }
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (editProvider!.currentPage == 1) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        } else {
          setState(() {
            editProvider!.currentPage = editProvider!.currentPage - 1;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [grad1Color, grad2Color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          titleSpacing: 0,
          backgroundColor: white,
          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                // decoration: DesignConfiguration.shadow(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                  onTap: () {
                    if (editProvider!.currentPage == 1) {
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        editProvider!.currentPage =
                            editProvider!.currentPage - 1;
                      });
                    }
                  },
                  child: const Center(
                    child: Icon(Icons.arrow_back, color: white, size: 25),
                  ),
                ),
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Edit Product".translate(context: context),
                style: const TextStyle(
                  color: white,
                  fontSize: textFontSize16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: width * 0.1),
              Text(
                "${"Step".translate(context: context)} ${editProvider!.currentPage} ${"of".translate(context: context)} 4",
                style: const TextStyle(color: white, fontSize: textFontSize14),
              ),
            ],
          ),
        ),
        body: editProvider!.isLoading ? const ShimmerEffect() : getBodyPart(),
      ),
    );
  }
}
