import 'package:deliveryboy_multivendor/Cubit/languageCubit.dart';
import 'package:deliveryboy_multivendor/Model/appLanguageModel.dart';
import 'package:deliveryboy_multivendor/Widget/bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/constant.dart';

class LanguageDialog {
  static languageDialog(BuildContext context, Function update) async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return LanguageBottomSheet();
        },
      ),
    );
  }
}

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({final Key? key}) : super(key: key);

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  String? selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    final languageState = context.read<LanguageCubit>().state;
    if (languageState is LanguageLoader) {
      selectedLanguageCode = languageState.languageCode;
    }
  }

  Column getLanguageTile({required AppLanguage appLanguage}) => Column(
    children: [
      InkWell(
        onTap: () {
          context.read<LanguageCubit>().changeLanguage(
            selectedLanguageCode: appLanguage.languageCode,
            selectedLanguageName: appLanguage.languageName,
            selectedSubLanguageName: appLanguage.subLanguageName,
          );
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              RadioGroup<String>(
                groupValue: selectedLanguageCode,
                onChanged: (String? val) {
                  if (val == null) return;
                  setState(() {
                    selectedLanguageCode = val;
                  });
                  context.read<LanguageCubit>().changeLanguage(
                    selectedLanguageCode: appLanguage.languageCode,
                    selectedLanguageName: appLanguage.languageName,
                    selectedSubLanguageName: appLanguage.subLanguageName,
                  );
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: appLanguage.languageCode,
                      fillColor: const WidgetStatePropertyAll(Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLanguage.languageName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appLanguage.subLanguageName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Radio<String>(
          //       value: appLanguage.languageCode,
          //       groupValue: selectedLanguageCode,
          //       onChanged: (value) {
          //         setState(() {
          //           selectedLanguageCode = value;
          //         });
          //         context.read<LanguageCubit>().changeLanguage(
          //               selectedLanguageCode: appLanguage.languageCode,
          //               selectedLanguageName: appLanguage.languageName,
          //               selectedSubLanguageName:
          //                   appLanguage.subLanguageName,
          //             );
          //         Navigator.pop(context);
          //       },
          //       activeColor: primary,
          //     ),
          //     const SizedBox(width: 8),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           appLanguage.languageName,
          //           style: const TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 16,
          //           ),
          //         ),
          //         const SizedBox(height: 4),
          //         Text(
          //           appLanguage.subLanguageName,
          //           style: const TextStyle(
          //             fontSize: 14,
          //             color: Colors.grey,
          //           ),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
      const Divider(height: 1, thickness: 0.5),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 10,
        right: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBottomSheet.bottomSheetHandle(context),
          CustomBottomSheet.bottomSheetLabel(context, 'CHOOSE_LANGUAGE_LBL'),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: appLanguages.length,
                  itemBuilder: (context, index) {
                    return getLanguageTile(appLanguage: appLanguages[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
