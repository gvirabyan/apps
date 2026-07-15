import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Screen/AddProduct/Add_Product.dart';
import 'package:sellermultivendor/Screen/EditProduct/EditProduct.dart';
import 'package:sellermultivendor/Screen/FAQ/faq.dart';
import 'package:sellermultivendor/Screen/ProductList/widget/getAppBar.dart';
import 'package:sellermultivendor/Screen/ProductList/widget/getCommanButton.dart';
import 'package:sellermultivendor/Widget/bottomsheet.dart';
import '../../Helper/Constant.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Provider/ProductListProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/systemChromeSettings.dart';
import '../../Widget/noNetwork.dart';
import '../HomePage/home.dart';
import '../ReviewList/ReviewList.dart';

class ProductList extends StatefulWidget {
  final String? flag;
  final bool fromNavbar;

  const ProductList({super.key, this.flag, required this.fromNavbar});

  @override
  State<StatefulWidget> createState() => StateProduct();
}

ProductListProvider? productListProvider;

class StateProduct extends State<ProductList>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProductList> {
  int selectedValue = 1;
  final List<Map<String, dynamic>> sortOptions = [
    {
      "key": 1,
      "label": "TopRated",
      "sortBy": "",
      "orderBy": "DESC",
      "flag": "",
      "productType": "1",
      "popResult": "option 1",
    },
    {
      "key": 2,
      "label": "NewestFirst",
      "sortBy": "p.date_added",
      "orderBy": "DESC",
      "flag": "",
      "productType": "0",
      "popResult": "option 1",
    },
    {
      "key": 3,
      "label": "OldestFirst",
      "sortBy": "p.date_added",
      "orderBy": "ASC",
      "flag": "",
      "productType": "0",
      "popResult": "option 2",
    },
    {
      "key": 4,
      "label": "LOWTOHIGH",
      "sortBy": "pv.price",
      "orderBy": "ASC",
      "flag": "",
      "productType": "0",
      "popResult": "option 3",
    },
    {
      "key": 5,
      "label": "HIGHTOLOW",
      "sortBy": "pv.price",
      "orderBy": "DESC",
      "flag": "",
      "productType": "0",
      "popResult": "option 4",
    },
  ];
  setStateNow() {
    if (!mounted) return;

    // Use SchedulerBinding to ensure setState is called at the right time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
  bool serachIsEnable = false;
  int currentSelected = 0;

  @override
  void initState() {
    if (widget.flag == "sold") {
      currentSelected = 1;
    }
    if (widget.flag == "low") {
      currentSelected = 2;
    }
    super.initState();
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    productListProvider = Provider.of<ProductListProvider>(
      context,
      listen: false,
    );
    productListProvider!.initializaedVariableWithDefualtValue();

    productListProvider!.controller.addListener(_scrollListener);
    productListProvider!.flag = widget.flag;
    productListProvider!.getProduct("0", context, setStateNow);

    productListProvider!.buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    productListProvider!.buttonSqueezeanimation =
        Tween(begin: width * 0.7, end: 50.0).animate(
          CurvedAnimation(
            parent: productListProvider!.buttonController!,
            curve: const Interval(0.0, 0.150),
          ),
        );
    productListProvider!.controllerForText.addListener(() {
      if (productListProvider!.controllerForText.text.isEmpty) {
        productListProvider!.productList.clear();

        if (mounted) {
          setState(() {
            productListProvider!.searchText = "";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            productListProvider!.searchText =
                productListProvider!.controllerForText.text;
          });
        }
      }

      if (productListProvider!.lastsearch != productListProvider!.searchText &&
          (productListProvider!.searchText == '' ||
              productListProvider!.searchText.isNotEmpty)) {
        productListProvider!.lastsearch = productListProvider!.searchText;
        productListProvider!.isLoading = true;
        productListProvider!.offset = 0;
        productListProvider!.productList.clear();
        productListProvider!.getProduct("0", context, setStateNow);
      }
    });
  }

  @override
  void dispose() {
    productListProvider!.buttonController!.dispose();
    productListProvider!.controller.removeListener(() {});
    for (int i = 0; i < productListProvider!.controllers.length; i++) {
      productListProvider!.controllers[i].dispose();
    }
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await productListProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> _showBulkDeleteConfirmation() async {
    // Capture the widget's context before entering the dialog builder
    final widgetContext = context;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: Text(
            "DELETE_PRODUCTS".translate(context: dialogContext),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textFontSize16,
            ),
          ),
          content: Text(
            "${"sure".translate(context: dialogContext)} ${productListProvider!.selectedProductIds.length} ${"SELECTED_PRODUCT(S)?".translate(context: dialogContext)}",
            style: const TextStyle(fontSize: textFontSize14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "CANCEL".translate(context: dialogContext),
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize14,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                "Delete".translate(context: dialogContext),
                style: const TextStyle(
                  color: red,
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize14,
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await productListProvider!.bulkDeleteProducts(
                  widgetContext,
                  setStateNow,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightWhite,
      floatingActionButton: SizedBox(
        height: 40.0,
        width: 40.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: newPrimary,
            child: const Icon(Icons.add, size: 32, color: white),
            onPressed: () async {
              final value = await Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const AddProduct()),
              );
              //refresh the page if user adds a product
              if (value != null && value) {
                Future.delayed(Duration.zero, () {
                  _refresh();
                });
              }
            },
          ),
        ),
      ),
      //refresh the page if user edits a product
      appBar: GradientAppBar2(
        appName,
        context,
        setStateNow,
        widget.fromNavbar,
        Material(
          color: Colors.transparent,
          child: PopupMenuButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
              size: 25,
            ),
            onSelected: (dynamic value) {
              switch (value) {
                case 0:
                  return filterDialog();
                case 1:
                  _showBottomSheet();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 0,
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: 0.0,
                    end: 0.0,
                  ),
                  leading: const Icon(Icons.tune, color: primary, size: 25),
                  title: Text("Filter".translate(context: context)),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: 0.0,
                    end: 0.0,
                  ),
                  leading: const Icon(Icons.sort, color: primary, size: 20),
                  title: Text("Sort".translate(context: context)),
                ),
              ),
            ],
          ),
        ),
      ),
      key: productListProvider!.scaffoldKey,
      body: isNetworkAvail
          ? Stack(
              children: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentSelected = 0;
                                productListProvider!.flag = '';
                                setState(() {
                                  productListProvider!.isLoading = true;
                                  productListProvider!.total = 0;
                                  productListProvider!.offset = 0;
                                  productListProvider!.productList.clear();
                                });
                                productListProvider!.getProduct(
                                  "0",
                                  context,
                                  setStateNow,
                                );
                              },
                              child: CommanButton(
                                selected: currentSelected == 0 ? true : false,
                                title: 'All'.translate(context: context),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentSelected = 1;
                                productListProvider!.flag = 'sold';
                                setState(() {
                                  productListProvider!.isLoading = true;
                                  productListProvider!.total = 0;
                                  productListProvider!.offset = 0;
                                  productListProvider!.productList.clear();
                                });
                                productListProvider!.getProduct(
                                  "0",
                                  context,
                                  setStateNow,
                                );
                              },
                              child: CommanButton(
                                selected: currentSelected == 1 ? true : false,
                                title: 'Soldout'.translate(context: context),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                currentSelected = 2;
                                productListProvider!.flag = 'low';
                                setState(() {
                                  productListProvider!.isLoading = true;
                                  productListProvider!.total = 0;
                                  productListProvider!.offset = 0;
                                  productListProvider!.productList.clear();
                                });
                                productListProvider!.getProduct(
                                  "0",
                                  context,
                                  setStateNow,
                                );
                              },
                              child: CommanButton(
                                selected: currentSelected == 2 ? true : false,
                                title: 'Low in Stock'.translate(
                                  context: context,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Delete Selected Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 8.0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                productListProvider!.selectedProductIds.isEmpty
                                ? grey
                                : primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline, color: white),
                          label: Text(
                            productListProvider!.selectedProductIds.isEmpty
                                ? "SELECT_PRODUCTS_TO_DELETE".translate(
                                    context: context,
                                  )
                                : "${"DELETE_SELECTED".translate(context: context)} (${productListProvider!.selectedProductIds.length})"
                                      .translate(context: context),
                            style: const TextStyle(
                              color: white,
                              fontSize: textFontSize14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed:
                              productListProvider!.selectedProductIds.isEmpty
                              ? null
                              : _showBulkDeleteConfirmation,
                        ),
                      ),
                    ),
                    Flexible(child: _showForm()),
                  ],
                ),
                DesignConfiguration.showCircularProgress(
                  productListProvider!.isProgress,
                  primary,
                ),
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              productListProvider!.buttonSqueezeanimation,
              productListProvider!.buttonController,
            ),
    );
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then((_) async {
      isNetworkAvail = await isNetworkAvailable();
      print("--->$isNetworkAvail");
      if (isNetworkAvail) {
        productListProvider!.offset = 0;
        productListProvider!.total = 0;
        productListProvider!.flag = '';
        productListProvider!.getProduct("0", context, setStateNow);
      } else {
        await productListProvider!.buttonController!.reverse();
        if (mounted) setState(() {});
      }
    });
  }

  Widget listItem(int index) {
    // double? price;
    if (index < productListProvider!.productList.length) {
      Product? model = productListProvider!.productList[index];
      productListProvider!.totalProduct = model.total;

      if (productListProvider!.controllers.length < index + 1) {
        productListProvider!.controllers.add(TextEditingController());
      }

      if (model.prVarientList!.isNotEmpty) {
        productListProvider!.controllers[index].text =
            model.prVarientList![model.selVarient!].cartCount!;
        double price = double.parse(
          model.prVarientList![model.selVarient!].disPrice!,
        );
        if (price == 0) {
          price = double.parse(model.prVarientList![model.selVarient!].price!);
        }
      }
      productListProvider!.items = List<String>.generate(
        model.totalAllow != "" ? int.parse(model.totalAllow!) : 10,
        (i) => (i + 1).toString(),
      );

      return Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 13),
        child: InkWell(
          onTap: () async {
            final value = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EditProduct(model: model),
              ),
            );

            //refresh the page if user edits a product
            if (value != null && value) {
              Future.delayed(Duration.zero, () {
                _refresh();
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(
                Radius.circular(circularBorderRadius10),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              child: ListTile(
                // leading: Checkbox(
                //   value: productListProvider!.isProductSelected(model.id!),
                //   onChanged: (bool? value) {
                //     productListProvider!.toggleProductSelection(model.id!);
                //     setState(() {});
                //   },
                //   activeColor: primary,
                // ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.9,
                      child: Checkbox(
                        value: productListProvider!.isProductSelected(
                          model.id!,
                        ),
                        onChanged: (bool? value) {
                          productListProvider!.toggleProductSelection(
                            model.id!,
                          );
                          setState(() {});
                        },
                        activeColor: primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        productDeletDialog(model.name!, model.id!, context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SvgPicture.asset(
                          DesignConfiguration.setNewSvgPath(Assets.delete),
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 12.0,
                        // start: 12.0,
                        end: 12.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: 12.0,
                            ),
                            child: Hero(
                              tag: "$index${model.id}+ $index${model.name}",
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  circularBorderRadius5,
                                ),
                                child: DesignConfiguration.getCacheNotworkImage(
                                  boxFit: BoxFit.cover,
                                  context: context,
                                  heightvalue: 70.0,
                                  placeHolderSize: 70.0,
                                  imageurlString: model.image!,
                                  widthvalue: 70.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    model.name!,
                                    style: const TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "PlusJakartaSans",
                                      fontStyle: FontStyle.normal,
                                      fontSize: textFontSize14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                model.prVarientList!.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "${'PRICE_LBL'.translate(context: context)} : ",
                                              style: const TextStyle(
                                                color: lightBlack2,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "PlusJakartaSans",
                                                fontStyle: FontStyle.normal,
                                                fontSize: textFontSize14,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            model.prVarientList!.isNotEmpty
                                                ? Text(
                                                    double.parse(
                                                              model
                                                                  .prVarientList![model
                                                                      .selVarient!]
                                                                  .disPrice!,
                                                            ) !=
                                                            0
                                                        ? DesignConfiguration.getPriceFormat(
                                                            context,
                                                            double.parse(
                                                              model
                                                                  .prVarientList![model
                                                                      .selVarient!]
                                                                  .disPrice!,
                                                            ),
                                                          )!
                                                        : DesignConfiguration.getPriceFormat(
                                                            context,
                                                            double.parse(
                                                              model
                                                                  .prVarientList![model
                                                                      .selVarient!]
                                                                  .price!,
                                                            ),
                                                          )!,
                                                    style: const TextStyle(
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          "PlusJakartaSans",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: textFontSize14,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                if (model.stockType != "")
                                  Row(
                                    children: [
                                      Text(
                                        '${'Quantity'.translate(context: context)} : ',
                                        style: const TextStyle(
                                          color: lightBlack2,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PlusJakartaSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: textFontSize14,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        model.stockType == "2"
                                            ? model.totalStock == null ||
                                                      model.totalStock! == ""
                                                  ? "0"
                                                  : model.totalStock!
                                            : model.stockType == "1"
                                            ? model.prVarientList == null ||
                                                      model
                                                          .prVarientList!
                                                          .isEmpty ||
                                                      model
                                                              .prVarientList![0]
                                                              .stock ==
                                                          null ||
                                                      model
                                                              .prVarientList![0]
                                                              .stock ==
                                                          ""
                                                  ? "0"
                                                  : model
                                                        .prVarientList![0]
                                                        .stock!
                                            : model.stock == null ||
                                                  model.stock! == ""
                                            ? "0"
                                            : model.stock!,
                                        style: const TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PlusJakartaSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: textFontSize14,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 11.0,
                        bottom: 10.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute<String>(
                                    builder: (context) =>
                                        AddFAQs(model.id, model),
                                  ),
                                );
                              },
                              child: commanBtn(
                                "Product FAQ".translate(context: context),
                                false,
                                model.availability == "0" ||
                                    model.availability == null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute<String>(
                                    builder: (context) =>
                                        ReviewList(model.id, model),
                                  ),
                                );
                              },
                              child: commanBtn(
                                "Review".translate(context: context),
                                false,
                                model.availability == "0",
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (model.status != "1") {
                                  productListProvider!.updateProductStatus(
                                    model.id!,
                                    "1",
                                    context,
                                    setStateNow,
                                  );
                                } else {
                                  productListProvider!.updateProductStatus(
                                    model.id!,
                                    "0",
                                    context,
                                    setStateNow,
                                  );
                                }
                              },
                              child: commanBtn(
                                model.status == "1"
                                    ? 'Enable'.translate(context: context)
                                    : "Disable".translate(context: context),
                                true,
                                model.status != "1",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _showBottomSheet() async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Center(child: CustomBottomSheet.bottomSheetHandle(context)),
                    CustomBottomSheet.bottomSheetLabel(
                      context,
                      "SortBy".translate(context: context),
                    ),
                    const Divider(),
                    RadioGroup<int>(
                      groupValue: selectedValue,
                      onChanged: (int? value) {
                        if (value == null) return;
                        final option = sortOptions.firstWhere(
                          (o) => o["key"] == value,
                        );

                        setState(() {
                          selectedValue = value;
                          productListProvider!
                            ..sortBy = option["sortBy"]
                            ..orderBy = option["orderBy"]
                            ..flag = option["flag"]
                            ..isLoading = true
                            ..total = 0
                            ..offset = 0
                            ..productList.clear();
                        });

                        productListProvider!.getProduct(
                          option["productType"],
                          context,
                          setStateNow,
                        );
                        Navigator.pop(context, option["popResult"]);
                      },
                      child: Column(
                        children: sortOptions.map((option) {
                          return RadioListTile<int>(
                            value: option["key"],
                            title: Text(
                              option["label"].toString().translate(
                                context: context,
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            activeColor: Theme.of(context).colorScheme.primary,
                            controlAffinity: ListTileControlAffinity.trailing,
                            // Note: do *not* use groupValue or onChanged here — those are managed by RadioGroup
                            selected: selectedValue == option["key"],
                          );
                        }).toList(),
                      ),
                    ),
                    Platform.isIOS
                        ? const Padding(padding: EdgeInsets.only(bottom: 20))
                        : const Padding(padding: EdgeInsets.zero),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _scrollListener() {
    if (productListProvider!.controller.offset >=
            productListProvider!.controller.position.maxScrollExtent &&
        !productListProvider!.controller.position.outOfRange) {
      if (mounted) {
        if (mounted) {
          setState(() {
            isLoadingmore = true;

            if (productListProvider!.offset < productListProvider!.total) {
              productListProvider!.getProduct("0", context, setStateNow);
            }
          });
        }
      }
    }
  }

  Future<void> _refresh() {
    if (mounted) {
      setState(() {
        productListProvider!.isLoading = true;
        isLoadingmore = true;
        productListProvider!.offset = 0;
        productListProvider!.total = 0;
        productListProvider!.productList.clear();
      });
    }
    return productListProvider!.getProduct("0", context, setStateNow);
  }

  _showForm() {
    return productListProvider!.isLoading
        ? const ShimmerEffect()
        : productListProvider!.productList.isEmpty
        ? DesignConfiguration.getNoItem(context)
        : RefreshIndicator(
            key: productListProvider!.refreshIndicatorKey,
            onRefresh: _refresh,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                shrinkWrap: true,
                controller: productListProvider!.controller,
                itemCount:
                    (productListProvider!.offset < productListProvider!.total)
                    ? productListProvider!.productList.length + 1
                    : productListProvider!.productList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return (index == productListProvider!.productList.length &&
                          isLoadingmore)
                      ? const Center(child: CircularProgressIndicator())
                      : listItem(index);
                },
              ),
            ),
          );
  }

  productDeletDialog(String productName, String id, BuildContext cntx) async {
    String pName = productName;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Text(
                "${"sure".translate(context: context)} \"  $pName \" ${"PRODUCTS".translate(context: context)}",
                style: Theme.of(
                  this.context,
                ).textTheme.titleMedium!.copyWith(color: primary),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "LOGOUTNO".translate(context: context),
                    style: Theme.of(this.context).textTheme.titleSmall!
                        .copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    "LOGOUTYES".translate(context: context),
                    style: Theme.of(this.context).textTheme.titleSmall!
                        .copyWith(color: primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await productListProvider!.deleteProductApi(
                      id,
                      cntx,
                      setStateNow,
                    );
                    setState(() {
                      productListProvider!.isLoading = true;
                      isLoadingmore = true;
                      productListProvider!.offset = 0;
                      productListProvider!.total = 0;
                      productListProvider!.productList.clear();
                    });
                    if (context.mounted) {
                      productListProvider!.getProduct(
                        "0",
                        context,
                        setStateNow,
                      );
                      Routes.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void filterDialog() {
    if (productListProvider!.filterList!.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 30.0),
                    child: AppBar(
                      backgroundColor: lightWhite,
                      title: Text(
                        "Filter".translate(context: context),
                        style: const TextStyle(color: fontColor),
                      ),
                      elevation: 5,
                      leading: Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: DesignConfiguration.shadow(),
                            child: Card(
                              elevation: 0,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  circularBorderRadius5,
                                ),
                                onTap: () => Navigator.of(context).pop(),
                                child: const Padding(
                                  padding: EdgeInsetsDirectional.only(end: 4.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(end: 10.0),
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Text(
                              "ClearFilters".translate(context: context),
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: fontColor,
                                  ),
                            ),
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  productListProvider!.selectedId.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: lightWhite,
                      padding: const EdgeInsetsDirectional.only(
                        start: 7.0,
                        end: 7.0,
                        top: 7.0,
                      ),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: lightWhite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsetsDirectional.only(
                                    top: 10.0,
                                  ),
                                  itemCount:
                                      productListProvider!.filterList!.length,
                                  itemBuilder: (context, index) {
                                    productListProvider!
                                        .attsubList = productListProvider!
                                        .filterList![index]['attribute_values']
                                        .split(',');

                                    productListProvider!
                                        .attListId = productListProvider!
                                        .filterList![index]['attribute_values_id']
                                        .split(',');

                                    if (productListProvider!.filter == "") {
                                      productListProvider!.filter =
                                          productListProvider!
                                              .filterList![0]["name"];
                                    }

                                    return InkWell(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            productListProvider!.filter =
                                                productListProvider!
                                                    .filterList![index]['name'];
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                              start: 20,
                                              top: 10.0,
                                              bottom: 10.0,
                                            ),
                                        decoration: BoxDecoration(
                                          color:
                                              productListProvider!.filter ==
                                                  productListProvider!
                                                      .filterList![index]['name']
                                              ? white
                                              : lightWhite,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(
                                              circularBorderRadius7,
                                            ),
                                            bottomLeft: Radius.circular(7),
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          productListProvider!
                                              .filterList![index]['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color:
                                                    productListProvider!
                                                            .filter ==
                                                        productListProvider!
                                                            .filterList![index]['name']
                                                    ? fontColor
                                                    : lightBlack,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsetsDirectional.only(
                                  top: 10.0,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    productListProvider!.filterList!.length,
                                itemBuilder: (context, index) {
                                  if (productListProvider!.filter ==
                                      productListProvider!
                                          .filterList![index]["name"]) {
                                    productListProvider!
                                        .attsubList = productListProvider!
                                        .filterList![index]['attribute_values']
                                        .split(',');

                                    productListProvider!
                                        .attListId = productListProvider!
                                        .filterList![index]['attribute_values_id']
                                        .split(',');
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: productListProvider!
                                          .attListId!
                                          .length,
                                      itemBuilder: (context, i) {
                                        return CheckboxListTile(
                                          dense: true,
                                          title: Text(
                                            productListProvider!.attsubList![i],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: lightBlack,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                          value: productListProvider!.selectedId
                                              .contains(
                                                productListProvider!
                                                    .attListId![i],
                                              ),
                                          activeColor: primary,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (bool? val) {
                                            if (mounted) {
                                              setState(() {
                                                if (val == true) {
                                                  productListProvider!
                                                      .selectedId
                                                      .add(
                                                        productListProvider!
                                                            .attListId![i],
                                                      );
                                                } else {
                                                  productListProvider!
                                                      .selectedId
                                                      .remove(
                                                        productListProvider!
                                                            .attListId![i],
                                                      );
                                                }
                                              });
                                            }
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: white,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productListProvider!.total.toString()),
                              Text("Productsfound".translate(context: context)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SimBtn(
                          size: 0.4,
                          title: "Apply".translate(context: context),
                          onBtnSelected: () {
                            productListProvider!.selId = productListProvider!
                                .selectedId
                                .join(',');

                            if (mounted) {
                              setState(() {
                                productListProvider!.isLoading = true;
                                productListProvider!.total = 0;
                                productListProvider!.offset = 0;
                                productListProvider!.productList.clear();
                              });
                            }
                            productListProvider!.getProduct(
                              "0",
                              context,
                              setStateNow,
                            );
                            Navigator.pop(context, 'Product Filter');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      setSnackbar("DONT_HAVE_ANY_FILTER".translate(context: context), context);
    }
  }
}
