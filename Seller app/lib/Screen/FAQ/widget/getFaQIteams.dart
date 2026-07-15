import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Screen/FAQ/faq.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';

class GetMediaWidget extends StatelessWidget {
  final int index;
  final String id;
  final Function update;
  final BuildContext parentContext;

  const GetMediaWidget({
    super.key,
    required this.index,
    required this.update,
    required this.id,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    void confirmDeleteDialog(BuildContext context, BuildContext parentContext) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('YOU_WANT_TO_DELETE_FAQ'.translate(context: context)),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'.translate(context: context)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text(
                  'Delete'.translate(context: context),
                  style: const TextStyle(
                      color: Colors.red), // Set delete text to red for emphasis
                ),
                onPressed: () {
                  // Call delete API
                  faqProvider!.deleteTagsAPI(
                    faqProvider!.tagList[index].id,
                    context,
                  );

                  // Optionally delay further actions
                  Future.delayed(const Duration(seconds: 2)).then(
                    (_) async {
                      faqProvider!.scrollLoadmore = true;
                      faqProvider!.scrollOffset = 0;
                      faqProvider!.getFaQs(parentContext, update, id);
                      update();
                      Navigator.of(context)
                          .pop(); // Close the dialog after deletion
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 15,
            left: 15,
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Q:  ',
                                  style: TextStyle(
                                    color: black.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    faqProvider!.tagList[index].question!,
                                    style: const TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "PlusJakartaSans",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'A:  ',
                                  style: TextStyle(
                                    color: black.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    faqProvider!
                                            .tagList[index].answer!.isNotEmpty
                                        ? faqProvider!.tagList[index].answer!
                                        : "No Answer Yet..!"
                                            .translate(context: context),
                                    style: TextStyle(
                                      color: black.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "PlusJakartaSans",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () => confirmDeleteDialog(context, parentContext),
                  child: SvgPicture.asset(
                    DesignConfiguration.setNewSvgPath(Assets.delete),
                    width: 20,
                    height: 20,
                    colorFilter:
                        const ColorFilter.mode(primary, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
