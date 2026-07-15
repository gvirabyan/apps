//------------------------------------------------------------------------------
//==================== Deliverable Type Help Dialog ============================
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';

deliverableTypeHelpDialog(BuildContext context) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
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
                  Flexible(
                    child: Text(
                      "HOW_DELIVERABILITY_TYPE_WORKS".translate(context: context),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: lightBlack),
                  ),
                ],
              ),
            ),
            const Divider(color: lightBlack),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "THIS_FEATURE_ALLOWS_YOU_TO_CONTROL_WHICH_LOCATIONS_CAN_RECEIVE_THIS_PRODUCT"
                    .translate(context: context) +
                    ":",
                style: const TextStyle(fontSize: 14, color: lightBlack),
              ),
            ),
            const SizedBox(height: 16),
            _buildDeliverabilityOption(
              context: context,
              icon: Icons.block,
              iconColor: primary,
              title: "None".translate(context: context),
              description:
                  "NONE_DESCRIPTION"
                      .translate(context: context),
            ),
            _buildDeliverabilityOption(
              context: context,
              icon: Icons.public,
              iconColor: Colors.green,
              title: "All".translate(context: context),
              description:
                  "ALL_DESCRIPTION"
                      .translate(context: context),
            ),
            _buildDeliverabilityOption(
              context: context,
              icon: Icons.add_circle_outline,
              iconColor: primary,
              title: "Included".translate(context: context),
              description:
                  "INCLUDED_DESCRIPTION"
                      .translate(context: context),
            ),
            _buildDeliverabilityOption(
              context: context,
              icon: Icons.remove_circle_outline,
              iconColor: Colors.red,
              title: "Excluded".translate(context: context),
              description:
                  "EXCLUDED_DESCRIPTION"
                      .translate(context: context),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\u2022 ${"GROUPS_WISE_SYSTEM_TIP".translate(context: context)}",
                            style:
                                const TextStyle(fontSize: 12, color: lightBlack),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "\u2022 ${"GROUPS_WISE_SYSTEM_TIP_2".translate(context: context)}",
                            style:
                                const TextStyle(fontSize: 12, color: lightBlack),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "CLOSE".translate(context: context),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildDeliverabilityOption({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: lightBlack),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
