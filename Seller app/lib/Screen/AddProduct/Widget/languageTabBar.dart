// Language tab bar for multilingual (AR/EN/HI/UR) content fields.
// Tapping a language persists the current fields and swaps the visible
// text fields to that language's values (see Add/EditProductProvider).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/addProductProvider.dart';
import '../../../Provider/editProductProvider.dart';

// Shared visual builder used by both the add and edit flows.
Widget _langTabs({
  required List<Map<String, String>> languages,
  required String currentCode,
  required void Function(String code) onTap,
  void Function()? onChanged,
}) {
  return SizedBox(
    height: 42,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: languages.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, i) {
        final lang = languages[i];
        final code = lang['code'] ?? '';
        final selected = code == currentCode;
        return InkWell(
          onTap: () {
            onTap(code);
            if (onChanged != null) onChanged();
          },
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? primary : grey1,
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              border: Border.all(color: selected ? primary : grey2),
            ),
            alignment: Alignment.center,
            child: Text(
              lang['name'] ?? code,
              style: TextStyle(
                color: selected ? white : black,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    ),
  );
}

// Add-product flow. `onChanged` lets callers (e.g. the description step
// whose preview reads the provider directly) refresh after a switch.
Widget getLanguageTabBar(BuildContext context, {void Function()? onChanged}) {
  return Consumer<AddProductProvider>(
    builder: (context, provider, _) => _langTabs(
      languages: provider.contentLanguages,
      currentCode: provider.currentContentLang,
      onTap: provider.switchContentLanguage,
      onChanged: onChanged,
    ),
  );
}

// Edit-product flow
Widget getEditLanguageTabBar(BuildContext context,
    {void Function()? onChanged}) {
  return Consumer<EditProductProvider>(
    builder: (context, provider, _) => _langTabs(
      languages: provider.contentLanguages,
      currentCode: provider.currentContentLang,
      onTap: provider.switchContentLanguage,
      onChanged: onChanged,
    ),
  );
}
