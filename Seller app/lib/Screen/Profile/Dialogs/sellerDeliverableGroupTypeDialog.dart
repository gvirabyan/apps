import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../Profile.dart';

sellerDeliverableGroupTypeDialog(
  BuildContext context,
  Function setState,
  bool isCity,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Container(
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
                    child: Text(
                      "SELECT_DELIVERABLE_GROUP_TYPE".translate(
                        context: context,
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: primary),
                    ),
                  ),
                  const Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOption(context, '0', 'None', setState, isCity),
                          _buildOption(context, '1', 'All', setState, isCity),
                          _buildOption(
                            context,
                            '2',
                            'Include',
                            setState,
                            isCity,
                          ),
                          _buildOption(
                            context,
                            '3',
                            'Exclude',
                            setState,
                            isCity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildOption(
  BuildContext context,
  String value,
  String label,
  Function setState,
  bool isCity,
) {
  final currentValue = isCity
      ? profileProvider!.deliverableCityType
      : profileProvider!.deliverableZipcodeType;

  return InkWell(
    onTap: () {
      if (isCity) {
        profileProvider!.deliverableCityType = value;
        if (value == '0' || value == '1') {
          profileProvider!.selectedCityGroups.clear();
          profileProvider!.deliverableCitiesGroupIds = '';
        }
      } else {
        profileProvider!.deliverableZipcodeType = value;
        if (value == '0' || value == '1') {
          profileProvider!.selectedZipcodeGroups.clear();
          profileProvider!.deliverableZipcodesGroupIds = '';
        }
      }
      Navigator.of(context).pop();
      setState();
    },
    child: SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label.translate(context: context)),
            if (currentValue == value) const Icon(Icons.check, color: primary),
          ],
        ),
      ),
    ),
  );
}
