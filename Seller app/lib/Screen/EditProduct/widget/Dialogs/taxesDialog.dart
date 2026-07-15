import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../EditProduct.dart';

taxesDialog(BuildContext context, Function update) async {
  if (editProvider!.taxesList.isNotEmpty) {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            editProvider!.taxesState = setStater;
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(circularBorderRadius25),
                  topRight: Radius.circular(circularBorderRadius25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Icon(Icons.arrow_back),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          "Select Tax".translate(context: context),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(color: primary),
                        ),
                        Container(width: 2),
                        Text(
                          "0%".translate(context: context),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(color: primary),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getTaxtList(context, update),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

List<Widget> getTaxtList(BuildContext context, Function update) {
  return editProvider!.taxesList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              if (editProvider!.selectedTax.contains(element)) {
                editProvider!.selectedTax.remove(element);
              } else {
                editProvider!.selectedTax.add(element);
              }
              editProvider!.taxesState(() {});
              update();
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    editProvider!.selectedTax.contains(element)
                        ? Container(
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
                                decoration: const BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        : Container(
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
                                decoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(editProvider!.taxesList[index].title!),
                    ),
                    Text("${editProvider!.taxesList[index].percentage!}%"),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      .values
      .toList();
}
