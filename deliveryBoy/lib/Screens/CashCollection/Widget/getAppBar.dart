import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Screens/CashCollection/cash_collection.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/bottomsheet.dart';
import '../../../Widget/parameterString.dart';

class GradientAppBar2 extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;
  final Function update;
  final bool? customback;

  GradientAppBar2(this.title, this.context, this.update, {this.customback});

  @override
  State<GradientAppBar2> createState() => _GradientAppBar2State();

  @override
  Size get preferredSize => Size(deviceWidth!, 50);
}

class _GradientAppBar2State extends State<GradientAppBar2> {
  bool serachIsEnable = false;

  void _handleSearchEnd() {
    if (!mounted) return;
    setState(
      () {
        serachIsEnable = false;
        cashCollectionProvider!.controllerText.clear();
      },
    );
  }

  void _handleSearchStart() {
    if (!mounted) return;
    setState(
      () {},
    );
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
                  right: 10),
              child: Column(
                children: [
                  CustomBottomSheet.bottomSheetHandle(context),
                  CustomBottomSheet.bottomSheetLabel(
                    context,
                    ORDER_BY_TXT.translate(context: context),
                  ),
                  Divider(),
                  CustomBottomSheet.button(
                    context,
                    ASC_TXT.translate(context: context),
                    icon: Icons.sort,
                    onBtnSelected: () {
                      cashCollectionProvider!.currentSortOrder =
                          "ASC"; // ✅ Set current order
                      cashCollectionProvider!.cashList.clear();
                      cashCollectionProvider!.offset = 0;
                      cashCollectionProvider!.total = 0;
                      cashCollectionProvider!.isLoading = true;
                      widget.update();
                      cashCollectionProvider!.getOrder(
                        cashCollectionProvider!.currentCashCollectionBy ==
                                "admin"
                            ? "admin"
                            : "delivery",
                        cashCollectionProvider!
                            .currentSortOrder, // ✅ Use dynamic value
                        widget.update,
                        context,
                      );
                      Navigator.pop(context, 'option 1');
                    },
                  ),
                  CustomBottomSheet.button(
                    context,
                    DESC_TXT.translate(context: context),
                    icon: Icons.sort,
                    onBtnSelected: () {
                      cashCollectionProvider!.currentSortOrder =
                          "DESC"; // ✅ Set current order
                      cashCollectionProvider!.cashList.clear();
                      cashCollectionProvider!.offset = 0;
                      cashCollectionProvider!.total = 0;
                      cashCollectionProvider!.isLoading = true;
                      widget.update();
                      cashCollectionProvider!.getOrder(
                        cashCollectionProvider!.currentCashCollectionBy ==
                                "admin"
                            ? "admin"
                            : "delivery",
                        cashCollectionProvider!
                            .currentSortOrder, // ✅ Use dynamic value
                        widget.update,
                        context,
                      );
                      Navigator.pop(context, 'option 1');
                    },
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50))
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [grad1Color, grad2Color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    serachIsEnable
                        ? Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 8.0),
                            child: SizedBox(
                              width: deviceWidth! * 0.7,
                              child: TextField(
                                controller:
                                    cashCollectionProvider!.controllerText,
                                autofocus: true,
                                style: const TextStyle(
                                  color: white,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.search, color: white),
                                  hintText: 'Search...',
                                  hintStyle: const TextStyle(color: white),
                                  disabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: white,
                                    ),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                top: 10.0,
                                start: 20,
                                end: 5,
                              ),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: white,
                                  fontSize: textFontSize20,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 10, end: 15.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (serachIsEnable == false) {
                                serachIsEnable = true;

                                _handleSearchStart();
                              } else {
                                serachIsEnable = false;
                                cashCollectionProvider!.controllerText.clear();
                                _handleSearchEnd();
                              }
                            });
                          },
                          child: Icon(
                            serachIsEnable ? Icons.close : Icons.search,
                            color: white,
                            size: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 10, end: 15.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _showBottomSheet();
                              },
                              child: Icon(
                                Icons.swap_vert,
                                color: white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
