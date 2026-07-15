import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/PickUpLocationModel/PickUpLocationModel.dart';
import 'package:sellermultivendor/Model/city.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import '../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../Model/BrandModel/brandModel.dart';
import '../Model/CategoryModel/categoryModel.dart';
import '../Model/ProductModel/Variants.dart';
import '../Model/TaxesModel/TaxesModel.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Model/ZipCodesModel/ZipcodeGroupModel.dart';
import '../Model/CityModel/CityGroupModel.dart';
import '../Model/Country/countryModel.dart';
import '../Widget/api.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import 'package:http/http.dart' as http;
import '../Widget/parameterString.dart';
import '../Widget/snackbar.dart';
import '../appConstants.dart';

/// Extension to safely add fields to MultipartRequest, handling null values
extension SafeMultipartFields on http.MultipartRequest {
  /// Adds a field only if the value is not null and not empty
  void addFieldIfNotNull(String key, String? value) {
    if (value != null && value.isNotEmpty) {
      fields[key] = value;
    }
  }

  /// Adds a field with a default value if the original value is null
  void addFieldWithDefault(String key, String? value, String defaultValue) {
    fields[key] = value ?? defaultValue;
  }
}

enum AddProductStatus { initial, inProgress, isSuccsess, isFailure }

class AddProductProvider extends ChangeNotifier {
  // update status

  AddProductStatus addProductStatus = AddProductStatus.initial;

  changeStatus(AddProductStatus status) {
    addProductStatus = status;
    notifyListeners();
  }

  freshInitializationOfAddProduct() {
    hsnCode = null;
    digitalPrice = null;
    productName = null;
    sortDescription = null;
    extraDescription = null;
    digitalProductName = '';
    tags = null;
    // Multilingual: reset per-language content state
    currentContentLang = AppConstants.defaultLanguageCode;
    for (final field in fieldTranslations.keys) {
      fieldTranslations[field] = {};
    }
    // taxId = null;
    indicatorValue = null;
    madeIn = null;
    totalAllowQuantity = null;
    minOrderQuantity = null;
    quantityStepSize = null;
    warrantyPeriod = null;
    guaranteePeriod = null;
    deliverabletypeValue = "1";
    deliverableZipcodes = null;
    deliverableCities.clear();
    deliverableGroupType = "1";
    deliverableCityGroupType = "1";
    selectedZipcodeGroups.clear();
    selectedCityGroups.clear();
    zipcodeGroupsList.clear();
    cityGroupsList.clear();
    taxincludedinPrice = "0";
    isCODAllow = "0";
    isReturnable = "0";
    isCancelable = "0";
    isAttachmentRequired = "0";
    tillwhichstatus = null;
    selectedCatName = null;
    // selectedTaxID = null;
    isToggled = false;
    isreturnable = false;
    digitalProductDownloaded = false;
    isCODallow = false;
    iscancelable = false;
    taxincludedInPrice = false;
    attributeIndiacator = 0;
    selCityPos = -1;
    country = null;
    countryState = null;
    isLoadingMoreCity = null;
    countryOffset = 0;
    countryLoading = true;
    countrySearchLIst = [];
    isProgress = false;
    countryList = [];
    attrController = [];
    selectedTypeOfVideo = null;
    selectedDigitalProductTypeOfDownloadLink = null;
    videoUrl = null;
    videoOfProduct = null;
    description = null;
    selectedCatID = null;
    productType = null;
    variantStockLevelType = "product_level";
    curSelPos = 0;
    simpleproductStockStatus = "1";
    simpleproductPrice = null;
    simpleproductSpecialPrice = null;
    simpleproductSKU = null;
    simpleproductTotalStock = null;
    variantStockStatus = "0";
    finalAttList = [];
    tempAttList = [];
    variantsIds = null;
    variantPrice = null;
    variantSpecialPrice = null;
    variantImages = null;
    variantproductSKU = null;
    variantproductTotalStock = null;
    stockStatus = '1';
    variantSku = null;
    variantTotalStock = null;
    variantLevelStockStatus = null;
    isStockSelected = null;
    simpleProductSaveSettings = false;
    digitalProductSaveSettings = false;
    variantProductProductLevelSaveSettings = false;
    variantProductVariableLevelSaveSettings = false;
    selectedBrandName = null;
    selectedPickUpLocation = null;

    selectedDigitalLinkType = null;
    selectedBrandId = null;
    taxesList = [];
    attributeSetList = [];
    attributesList = [];
    attributesValueList = [];
    zipSearchList = [];
    catagorylist = [];
    variationBoolList = [];
    attrId = [];
    attrValId = [];
    attrVal = [];
    brandList = [];
    tempBrandList = [];
    brandLoading = true;
    brandOffset = 0;
    brandState = null;
    isLoadingMoreBrand = null;

    pickUpLocationList = [];
    temppickUpLocationList = [];
    locationLoading = true;
    locationOffset = 0;
    pickUpLocationState = null;
    isLoadingMoreLocation = null;

    data = null;
    suggessionisNoData = false;
    mainImageProductImage = null;
    otherPhotos = [];
    otherPhotosFromGellery = [];
    otherImageUrl = [];
    variationList = [];
    currentPage = 1;
    productNameControlller.clear();
    sortDescriptionControlller.clear();
    extraDescriptionControlller.clear();
    tagsControlller.clear();
    totalAllowController.clear();
    minOrderQuantityControlller.clear();
    quantityStepSizeControlller.clear();
    madeInControlller.clear();
    warrantyPeriodController.clear();
    guaranteePeriodController.clear();
    vidioTypeController.clear();
    simpleProductPriceController.clear();
    simpleProductSpecialPriceController.clear();
    simpleProductSKUController.clear();
    simpleProductTotalStock.clear();
    variountProductSKUController.clear();
    variountProductTotalStock.clear();
    countryController.clear();
    hsnCodeController.clear();
    digitalPriceController.clear();
    digitalSpecialController.clear();
    selfHostedDigitalProductURLController.clear();
    weightController.clear();
    heightController.clear();
    breadthController.clear();
    lengthController.clear();
    resultAttr = [];
    resultID = [];
    selectedAttributeValues = {};
    row = 1;
    height = null;
    weight = null;
    breadth = null;
    length = null;
    lowStockLimit = null;
    selectedTax.clear();
  }

  int row = 1;
  List<String> resultAttr = [];
  List<String> resultID = [];
  Map<String, List<AttributeValueModel>> selectedAttributeValues = {};

  // <===  curent selected page ===>

  int currentPage = 1;

  get currentPageValue => currentPage;

  setCurrentPageValue(int value) {
    currentPage = value;
    notifyListeners();
  }

  FocusNode? productFocus,
      sortDescriptionFocus,
      extraDescriptionFocus,
      tagFocus,
      totalAllowFocus,
      minOrderFocus,
      quantityStepSizeFocus,
      madeInFocus,
      warrantyPeriodFocus,
      guaranteePeriodFocus,
      vidioTypeFocus,
      simpleProductPriceFocus,
      simpleProductSpecialPriceFocus,
      simpleProductSKUFocus,
      simpleProductTotalStockFocus,
      variountProductSKUFocus,
      variountProductTotalStockFocus,
      hsnCodeFucosNode,
      rawKeyboardListenerFocus,
      tempFocusNode,
      attributeFocus,
      digitalPriceFocus,
      digitalSpecialFocus,
      selfHostedFocus,
      weightFocus,
      heightFocus,
      breadthFocus,
      lengthFocus,
      lowStockLimitFocus = FocusNode();

  //------------------------------------------------------------------------------
  //======================= TextEditingController ================================

  TextEditingController productNameControlller = TextEditingController();
  TextEditingController sortDescriptionControlller = TextEditingController();
  TextEditingController extraDescriptionControlller = TextEditingController();
  TextEditingController tagsControlller = TextEditingController();
  TextEditingController totalAllowController = TextEditingController();
  TextEditingController minOrderQuantityControlller = TextEditingController();
  TextEditingController quantityStepSizeControlller = TextEditingController();
  TextEditingController madeInControlller = TextEditingController();
  TextEditingController warrantyPeriodController = TextEditingController();
  TextEditingController guaranteePeriodController = TextEditingController();
  TextEditingController vidioTypeController = TextEditingController();
  TextEditingController simpleProductPriceController = TextEditingController();
  TextEditingController simpleProductSpecialPriceController =
      TextEditingController();
  TextEditingController simpleProductSKUController = TextEditingController();
  TextEditingController simpleProductTotalStock = TextEditingController();
  TextEditingController variountProductSKUController = TextEditingController();
  TextEditingController variountProductTotalStock = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final ScrollController countryScrollController = ScrollController();
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController digitalPriceController = TextEditingController();
  TextEditingController digitalSpecialController = TextEditingController();
  TextEditingController selfHostedDigitalProductURLController =
      TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController breadthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController lowStockLimitController = TextEditingController();

  // <===  product data ===>
  String? hsnCode; //hsn_code
  String? productName; //pro_input_name
  String? sortDescription; // short_description
  String? extraDescription; // extra_description
  String? tags; // Tags

  // ── Multilingual content (AR/EN/HI/UR) ──────────────────────────────
  // Language-specific fields are entered per language. The visible text
  // fields always show `currentContentLang`; each language's value is kept
  // in `fieldTranslations` and sent as translations[field][lang] on submit.
  // The default-language value also fills the plain params (pro_input_name…)
  // so existing backend logic keeps working unchanged.
  final List<Map<String, String>> contentLanguages =
      AppConstants.contentLanguages;
  String currentContentLang = AppConstants.defaultLanguageCode;
  // field key => { langCode => value }
  final Map<String, Map<String, String>> fieldTranslations = {
    'name': {},
    'short_description': {},
    'description': {},
    'extra_description': {},
    'tags': {},
  };

  bool isRtlContentLang(String code) =>
      AppConstants.rtlLanguageCodes.contains(code);

  // Read the currently visible fields into the active language slot.
  void _persistCurrentContentLang() {
    fieldTranslations['name']![currentContentLang] =
        productNameControlller.text;
    // short_description is an HTML-editor field (uses the `sortDescription`
    // variable, not the controller) — same as description/extra_description.
    fieldTranslations['short_description']![currentContentLang] =
        sortDescription ?? '';
    fieldTranslations['tags']![currentContentLang] = tagsControlller.text;
    fieldTranslations['description']![currentContentLang] = description ?? '';
    fieldTranslations['extra_description']![currentContentLang] =
        extraDescription ?? '';
  }

  // Load a language slot into the visible fields.
  void _loadContentLang(String code) {
    productNameControlller.text = fieldTranslations['name']![code] ?? '';
    productName = productNameControlller.text;
    sortDescription = fieldTranslations['short_description']![code] ?? '';
    sortDescriptionControlller.text = sortDescription ?? '';
    tagsControlller.text = fieldTranslations['tags']![code] ?? '';
    tags = tagsControlller.text;
    description = fieldTranslations['description']![code] ?? '';
    extraDescription = fieldTranslations['extra_description']![code] ?? '';
    extraDescriptionControlller.text = extraDescription ?? '';
  }

  void switchContentLanguage(String code) {
    if (code == currentContentLang) return;
    _persistCurrentContentLang();
    currentContentLang = code;
    _loadContentLang(code);
    notifyListeners();
  }

  // Prefill all language slots (edit flow) from a { field: { lang: value } } map.
  void setContentTranslations(Map<String, Map<String, String>> data) {
    for (final field in fieldTranslations.keys) {
      final incoming = data[field];
      if (incoming != null) {
        fieldTranslations[field] = Map<String, String>.from(incoming);
      }
    }
    _loadContentLang(currentContentLang);
    notifyListeners();
  }

  // Attach translations[field][lang] to the multipart request.
  void attachTranslationFields(http.MultipartRequest request) {
    _persistCurrentContentLang();
    for (final field in fieldTranslations.keys) {
      final byLang = fieldTranslations[field] ?? {};
      byLang.forEach((lang, value) {
        if (value.trim().isNotEmpty) {
          request.fields['translations[$field][$lang]'] = value;
        }
      });
    }
  }

  // Default-language value for a field (used for the plain params).
  String defaultLangValue(String field, String? fallback) {
    final v = fieldTranslations[field]?[AppConstants.defaultLanguageCode];
    if (v != null && v.trim().isNotEmpty) return v;
    return fallback ?? '';
  }

  // String? taxId; // Tax (pro_input_tax)
  String? indicatorValue; // indicator
  bool currentSellectedProductIsPysical = true;
  String? madeIn; //made_in
  String? totalAllowQuantity; // total_allowed_quantity
  String? minOrderQuantity; // minimum_order_quantity
  String? quantityStepSize; // quantity_step_size
  String? warrantyPeriod; //warranty_period
  String? guaranteePeriod; //guarantee_period
  String? deliverabletypeValue = "1"; //deliverable_type
  List<CityModel> deliverableCities = [];
  String? deliverableZipcodes; //deliverable_zipcodes
  String? deliverableZipcodeGroup;
  String? deliverableGroupType = "1"; //deliverable_group_type
  String? deliverableCityGroupType = "1"; //deliverable_city_group_type
  List<ZipcodeGroupModel> selectedZipcodeGroups = []; //selected zipcode groups
  List<ZipcodeGroupModel> zipcodeGroupsList = []; //available zipcode groups
  List<CityGroupModel> selectedCityGroups = []; //selected city groups
  List<CityGroupModel> cityGroupsList = []; //available city groups
  String? taxincludedinPrice = "0"; //is_prices_inclusive_tax
  String? isCODAllow = "0"; //cod_allowed
  String? isReturnable = "0"; //is_returnable
  String? isCancelable = "0"; //is_cancelable
  String? isAttachmentRequired = "0"; //is_attachment_required
  String? tillwhichstatus; //cancelable_till
  // => Variable For UI ...
  String? selectedCatName; // for UI
  // int? selectedTaxID; // for UI
  //on-off toggles
  bool isToggled = false;
  bool isreturnable = false;
  bool isCODallow = false;
  bool iscancelable = false;
  bool isattachmentrequired = false;
  bool taxincludedInPrice = false;
  bool digitalProductDownloaded = false;

  //for remove extra add
  int attributeIndiacator = 0;

  List<TaxesModel> selectedTax = [];

  //
  int? selCityPos = -1;
  String? country;
  StateSetter? countryState;
  bool? isLoadingMoreCity;
  int countryOffset = 0;
  bool countryLoading = true;
  List<CountryModel> countrySearchLIst = [];
  bool isProgress = false;
  List<CountryModel> countryList = [];
  String? selectedTypeOfVideo; // video_type
  String? videoUrl; //video
  File? videoOfProduct; // pro_input_video
  String? description; // pro_input_description
  String? selectedCatID; //category_id
  //attribute_values
  String? productType; //product_type
  String? variantStockLevelType =
      "product_level"; //variant_stock_level_type // defualt is product level  if not pass
  int curSelPos = 0;

  // for simple product   if(product_type == simple_product)

  String? simpleproductStockStatus = "1"; //simple_product_stock_status
  String? simpleproductPrice; //simple_price
  String? simpleproductSpecialPrice; //simple_special_price
  String? simpleproductSKU; // product_sku
  String? simpleproductTotalStock; // product_total_stock
  String? variantStockStatus =
      "0"; //variant_stock_status //fix according to riddhi mam =0 for simple product // not give any option for selection

  // for variable product
  List<List<AttributeValueModel>> finalAttList = [];
  List<List<AttributeValueModel>> tempAttList = [];
  String? variantsIds; //variants_ids
  String? variantPrice; // variant_price
  String? variantSpecialPrice; // variant_special_price
  String? variantImages; // variant_images

  //{if (variant_stock_level_type == product_level)}
  String? variantproductSKU; //sku_variant_type
  String? variantproductTotalStock; // total_stock_variant_type
  String stockStatus = '1'; // variant_status

  //{if(variant_stock_level_type == variable_level)}
  String? variantSku; // variant_sku
  String? variantTotalStock; // variant_total_stock
  String? variantLevelStockStatus; //variant_level_stock_status
  String? lowStockLimit; //low_stock_limit
  bool? isStockSelected;

  //  other
  bool simpleProductSaveSettings = false;
  bool variantProductProductLevelSaveSettings = false;
  bool variantProductVariableLevelSaveSettings = false;
  bool digitalProductSaveSettings = false;
  late StateSetter taxesState;

  // brand name
  final ScrollController brandScrollController = ScrollController();
  String? selectedBrandName;
  String? selectedBrandId;
  StateSetter? brandState;
  bool? isLoadingMoreBrand;
  int brandOffset = 0;
  bool brandLoading = true;
  List<BrandModel> brandList = [];
  List<BrandModel> tempBrandList = [];

  // pickUp location
  final ScrollController pickUpLocationScrollController = ScrollController();
  String? selectedPickUpLocation;
  StateSetter? pickUpLocationState;
  bool? isLoadingMoreLocation;
  int locationOffset = 0;
  bool locationLoading = true;
  List<PickUpLocationModel> pickUpLocationList = [];
  List<PickUpLocationModel> temppickUpLocationList = [];

  // getting data
  List<TaxesModel> taxesList = [];
  List<AttributeSetModel> attributeSetList = [];
  List<AttributeModel> attributesList = [];
  List<AttributeValueModel> attributesValueList = [];
  List<ZipCodeModel> zipSearchList = [];
  List<ZipcodeGroupModel> zipcodeSearchGroupsList = [];
  List<CategoryModel> catagorylist = [];
  List<TextEditingController> attrController = [];
  final List<TextEditingController> attrValController = [];
  List<bool> variationBoolList = [];
  List<int> attrId = [];
  List<int> attrValId = [];
  List<String> attrVal = [];
  String? data;
  bool suggessionisNoData = false;

  late String productImage,
      productImageUrl,
      uploadedVideoName,
      digitalProductName;
  var mainImageProductImage;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  List<String> otherPhotos = [];
  List<File>? otherPhotosFromGellery = [];
  List<String> otherImageUrl = [];
  List<Product_Varient> variationList = [];

  // digital product
  String? digitalPrice;
  String? digitalSpecialPrice;
  String? idDigitalProductDownladable = "0";
  String? selectedDigitalLinkType;
  String? selectedDigitalProductTypeOfDownloadLink = ''; // video_type
  String? digitalProductSelfHostedUrl;

  //shipping details
  String? weight, height, breadth, length;

  setproductName(String? value) {
    productName = value;
    notifyListeners();
  } //pro_input_name

  setDescription(String? value) {
    description = value;
    notifyListeners();
  } // short_description

  setsortDescription(String? value) {
    sortDescription = value;
    notifyListeners();
  } // short_description

  setExtraDescription(String? value) {
    extraDescription = value;
    notifyListeners();
  } // extra_description

  settags(String? value) {
    tags = value;
    notifyListeners();
  } // Tags

  // settaxId(String? value) {
  //   taxId = value;
  //   notifyListeners();
  // } // Tax (pro_input_tax)

  setindicatorValue(String? value) {
    indicatorValue = value;
    notifyListeners();
  } // indicator

  settmadeIn(String? value) {
    madeIn = value;
    notifyListeners();
  } //made_in

  settotalAllowQuantity(String? value) {
    totalAllowQuantity = value;
    notifyListeners();
  } // total_allowed_quantity

  setminOrderQuantity(String? value) {
    minOrderQuantity = value;
    notifyListeners();
  } // minimum_order_quantity

  setquantityStepSize(String? value) {
    quantityStepSize = value;
    notifyListeners();
  } // quantity_step_size

  setwarrantyPeriod(String? value) {
    warrantyPeriod = value;
    notifyListeners();
  } //warranty_period

  setguaranteePeriod(String? value) {
    guaranteePeriod = value;
    notifyListeners();
  } //guarantee_period

  Future<void> addProductAPI(
    List<String> attributesValuesIds,
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", addProductsApi);

        if (currentSellectedProductIsPysical) {
          request.addFieldIfNotNull('hsn_code', hsnCode);
          request.addFieldIfNotNull(Indicator, indicatorValue);
          request.addFieldIfNotNull(TotalAllowedQuantity, totalAllowQuantity);
          request.addFieldIfNotNull(MinimumOrderQuantity, minOrderQuantity);
          request.addFieldIfNotNull(QuantityStepSize, quantityStepSize);
          request.addFieldIfNotNull(WarrantyPeriod, warrantyPeriod);
          request.addFieldIfNotNull(GuaranteePeriod, guaranteePeriod);

          if (AppSettingsRepository.appSettings.isCityWiseDeliveribility) {
            request.addFieldWithDefault(
              DeliverableCityType,
              deliverabletypeValue,
              "1",
            );
            request.fields[DeliverableCities] = deliverableCities.isEmpty
                ? ""
                : deliverableCities.map((e) => e.id).toList().join(',');
          } else {
            request.addFieldWithDefault(
              DeliverableType,
              deliverabletypeValue,
              "1",
            );
            request.addFieldWithDefault(
              DeliverableZipcodes,
              deliverableZipcodes,
              "",
            );
          }

          // Zipcode groups fields
          request.addFieldWithDefault(
            'deliverable_group_type',
            deliverableGroupType,
            "1",
          );
          print("selectedZipcodeGroups $selectedZipcodeGroups");
          request.fields['deliverable_zipcodes_group[]'] =
              selectedZipcodeGroups.isEmpty
              ? ""
              : selectedZipcodeGroups.map((e) => e.id).toList().join(',');

          // City groups fields
          request.addFieldWithDefault(
            'deliverable_city_group_type',
            deliverableCityGroupType,
            "1",
          );
          request.fields['deliverable_cities_group[]'] =
              selectedCityGroups.isEmpty
              ? ""
              : selectedCityGroups.map((e) => e.id).toList().join(',');

          request.addFieldWithDefault(CodAllowed, isCODAllow, "0");
          request.addFieldWithDefault(IsReturnable, isReturnable, "0");
          request.addFieldWithDefault(IsCancelable, isCancelable, "0");
          request.addFieldWithDefault(
            IsAttachmentRequired,
            isAttachmentRequired,
            "0",
          );
        }

        request.headers.addAll(headers);
        // Multilingual: send per-language values, and source the plain params
        // from the default language so existing backend logic is unaffected.
        attachTranslationFields(request);
        request.addFieldIfNotNull(
            ProInputName, defaultLangValue('name', productName));
        request.addFieldIfNotNull(ShortDescription,
            defaultLangValue('short_description', sortDescription));
        request.addFieldIfNotNull(ExtraInputDesc,
            defaultLangValue('extra_description', extraDescription));
        request.addFieldIfNotNull(Tags, defaultLangValue('tags', tags));

        if (selectedTax.isNotEmpty) {
          request.fields[ProInputTax] = selectedTax
              .map((e) => e.id)
              .toList()
              .join(',');
        }

        request.addFieldIfNotNull(MadeIn, madeIn);
        request.addFieldWithDefault(
          IsPricesInclusiveTax,
          taxincludedinPrice,
          "0",
        );
        request.fields[ProInputImage] = productImage;

        if (otherPhotos.isNotEmpty) {
          request.fields[OtherImages] = otherPhotos.join(",");
        }

        request.addFieldIfNotNull(VideoType, selectedTypeOfVideo);
        request.addFieldIfNotNull(Video, videoUrl);
        if (uploadedVideoName.isNotEmpty) {
          request.fields[ProInputVideo] = uploadedVideoName;
        }
        request.addFieldWithDefault(
            ProInputDescription, defaultLangValue('description', description), "");
        request.addFieldIfNotNull('brand_id', selectedBrandId);
        request.addFieldIfNotNull(PICKUP_LOCATION, selectedPickUpLocation);
        request.addFieldIfNotNull(CategoryId, selectedCatID);
        request.addFieldIfNotNull(ProductType, productType);
        request.addFieldIfNotNull(LOW_STOCK_LIMIT, lowStockLimit);

        if (productType == 'variable_product') {
          request.addFieldWithDefault(
            VariantStockLevelType,
            variantStockLevelType,
            "product_level",
          );
        }
        request.fields[AttributeValues] = attributesValuesIds.join(",");

        if (productType == 'simple_product') {
          String? status;
          if (isStockSelected == null || !isStockSelected!) {
            status = null;
          } else {
            status = simpleproductStockStatus;
          }
          request.fields[SimpleProductStockStatus] = status ?? 'null';
          request.fields[SimplePrice] = simpleProductPriceController.text;
          request.fields[SimpleSpecialPrice] =
              simpleProductSpecialPriceController.text;

          if (isStockSelected == true) {
            request.addFieldWithDefault(ProductSku, simpleproductSKU, "");
            request.addFieldIfNotNull(
              ProductTotalStock,
              simpleproductTotalStock,
            );
          }

          request.addFieldIfNotNull(WEIGHT, weight);
          request.addFieldIfNotNull(HEIGHT, height);
          request.addFieldIfNotNull(BREADTH, breadth);
          request.addFieldIfNotNull(LENGTH, length);
        } else if (productType == 'variable_product') {
          String val = '',
              price = '',
              sprice = '',
              images = '',
              varHeight = '',
              varWeight = '',
              varLength = '',
              varBreadth = '';
          List<List<String>> imagesList = [];

          for (int i = 0; i < variationList.length; i++) {
            if (val == '') {
              val = variationList[i].id!.replaceAll(',', ' ');
              price = variationList[i].price!;
              sprice = variationList[i].disPrice ?? ' ';
            } else {
              val = "$val,${variationList[i].id!.replaceAll(',', ' ')}";
              price = "$price,${variationList[i].price!}";
              sprice = "$sprice,${variationList[i].disPrice ?? ' '}";
            }

            if (variationList[i].height != null) {
              varHeight = varHeight.isEmpty
                  ? variationList[i].height!
                  : '$varHeight,${variationList[i].height!}';
            }
            if (variationList[i].weight != null) {
              varWeight = varWeight.isEmpty
                  ? variationList[i].weight!
                  : '$varWeight,${variationList[i].weight!}';
            }
            if (variationList[i].breadth != null) {
              varBreadth = varBreadth.isEmpty
                  ? variationList[i].breadth!
                  : '$varBreadth,${variationList[i].breadth!}';
            }
            if (variationList[i].length != null) {
              varLength = varLength.isEmpty
                  ? variationList[i].length!
                  : '$varLength,${variationList[i].length!}';
            }

            if (variationList[i].imageRelativePath != null) {
              if (variationList[i].imageRelativePath!.isNotEmpty &&
                  images != '') {
                images =
                    '$images,${variationList[i].imageRelativePath!.join(",")}';
              } else if (variationList[i].imageRelativePath!.isNotEmpty &&
                  images == '') {
                images = variationList[i].imageRelativePath!.join(",");
              }

              List<String> subListofImage = images.split(',');
              images = "";
              for (int j = 0; j < subListofImage.length; j++) {
                subListofImage[j] = '"${subListofImage[j]}"';
              }
              imagesList.add(subListofImage);
            }
          }

          if (varHeight.isNotEmpty) request.fields[HEIGHT] = varHeight;
          if (varWeight.isNotEmpty) request.fields[WEIGHT] = varWeight;
          if (varLength.isNotEmpty) request.fields[LENGTH] = varLength;
          if (varBreadth.isNotEmpty) request.fields[BREADTH] = varBreadth;

          request.fields[VariantsIds] = val;
          request.fields[VariantPrice] = price;
          request.fields[VariantSpecialPrice] = sprice;
          request.fields[variant_images] = imagesList.toString();

          if (isStockSelected == true) {
            if (variantStockLevelType == 'product_level') {
              request.fields[SkuVariantType] =
                  variountProductSKUController.text;
              request.fields[TotalStockVariantType] =
                  variountProductTotalStock.text;
              request.fields[VariantStatus] = stockStatus;
            } else if (variantStockLevelType == 'variable_level') {
              String sku = '', totalStock = '', stkStatus = '';
              for (int i = 0; i < variationList.length; i++) {
                if (sku == '') {
                  sku = variationList[i].sku!;
                  totalStock = variationList[i].stock!;
                  stkStatus = variationList[i].stockStatus!;
                } else {
                  sku = "$sku,${variationList[i].sku!}";
                  totalStock = "$totalStock,${variationList[i].stock!}";
                  stkStatus = "$stkStatus,${variationList[i].stockStatus!}";
                }
              }
              request.fields[VariantSku] = sku;
              request.fields[VariantTotalStock] = totalStock;
              request.fields[VariantLevelStockStatus] = stkStatus;
            }
            request.fields[VariantStockStatus] = "0";
          }
        } else if (productType == 'digital_product') {
          request.fields['download_allowed'] = digitalProductDownloaded
              ? "1"
              : "0";
          request.fields[SimplePrice] = digitalPriceController.text;
          request.fields[SimpleSpecialPrice] = digitalSpecialController.text;

          if (digitalProductDownloaded) {
            if (selectedDigitalProductTypeOfDownloadLink == 'self_hosted') {
              request.fields['download_link_type'] = "self_hosted";
              request.fields['pro_input_zip'] = "1";
            }
            if (selectedDigitalProductTypeOfDownloadLink == 'Add Link') {
              request.fields['download_link_type'] = "add_link";
              request.fields['download_link'] =
                  selfHostedDigitalProductURLController.text;
            }
          }
        }

        print("request field******${request.fields}****${request.files}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print("resoinse statuscode***${response.statusCode}");

        // Log the response for debugging
        print("Response body: $responseString");

        // Check if response is successful
        if (response.statusCode != 200) {
          await buttonController!.reverse();
          setSnackbar(
            'Server error: ${response.statusCode}. Please try again.',
            context,
          );
          return;
        }

        // Try to decode JSON and handle errors
        dynamic getdata;
        try {
          getdata = json.decode(responseString);
        } catch (e) {
          await buttonController!.reverse();
          print("JSON decode error: $e");
          print("Response was: $responseString");
          setSnackbar(
            'Invalid server response. Please contact support.',
            context,
          );
          return;
        }

        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          await buttonController!.reverse();
          setSnackbar(msg, context);
          freshInitializationOfAddProduct();
          update();
          Navigator.pop(context, true); //go to previous page and refresh
        } else {
          await buttonController!.reverse();
          setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar('somethingMSg'.translate(context: context), context);
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        await buttonController!.reverse();
        isNetworkAvail = false;
        update();
      });
    }
  }
}
