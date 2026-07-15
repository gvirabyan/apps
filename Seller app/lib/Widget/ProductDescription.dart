import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import '../Helper/Constant.dart';
import '../Provider/settingProvider.dart';
import '../Repository/aiDescriptionRepository.dart';
import 'appBar.dart';
import 'simmerEffect.dart';
import 'snackbar.dart';

class ProductDescription extends StatefulWidget {
  final String? description;
  final String title;
  final String? productTitle;
  final String? fieldType;

  const ProductDescription(
    this.description,
    this.title, {
    super.key,
    this.productTitle,
    this.fieldType,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String result = '';
  bool isLoading = true;
  bool isGeneratingAI = false;
  bool isGeneratingCustomPrompt = false;
  bool hasSetInitialText = false;
  bool showCustomPromptField = false;
  bool isLoadingPrompts = false;
  final HtmlEditorController controller = HtmlEditorController();
  final AIDescriptionRepository _aiRepository = AIDescriptionRepository();
  final TextEditingController customPromptController = TextEditingController();

  @override
  void initState() {
    setValue();

    super.initState();
    setValueNow();
  }

  setValueNow() async {
    Future.delayed(Duration.zero, () {
      // Initial text will be set in build method first time only
    });
  }

  setValue() async {
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });

    // Future.delayed(const Duration(seconds: 6), () {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    customPromptController.dispose();
    super.dispose();
  }

  Future<void> _showPromptSuggestions() async {
    // Validate product title
    if (widget.productTitle == null || widget.productTitle!.trim().isEmpty) {
      setSnackbar(
        "PRODUCT_TITLE_REQUIRED_FOR_PROMPT_SUGGESTIONS".translate(
          context: context,
        ),
        context,
      );
      return;
    }

    setState(() {
      isLoadingPrompts = true;
    });

    try {
      final response = await _aiRepository.suggestProductPrompts(
        title: widget.productTitle!,
      );

      setState(() {
        isLoadingPrompts = false;
      });

      if (response['error'] == false && response['prompts'] != null) {
        final prompts = response['prompts'] as List;

        if (prompts.isEmpty) {
          setSnackbar(
            "NO_PROMPT_SUGGESTIONS_AVAILABLE".translate(context: context),
            context,
          );
          return;
        }

        // Show prompts in bottom sheet
        _showPromptsBottomSheet(prompts);
      } else {
        setSnackbar(
          response['message']?.toString() ??
              "FAILED_TO_GET_PROMPT_SUGGESTIONS".translate(context: context),
          context,
        );
      }
    } catch (e) {
      setState(() {
        isLoadingPrompts = false;
      });
      setSnackbar(
        "Error: ${e.toString()}".translate(context: context),
        context,
      );
    }
  }

  void _showPromptsBottomSheet(List prompts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SELECT_A_PROMPT".translate(context: context),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: prompts.length,
                    itemBuilder: (context, index) {
                      final prompt = prompts[index].toString();
                      return ListTile(
                        leading: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber,
                        ),
                        title: Text(prompt),
                        onTap: () {
                          customPromptController.text = prompt;
                          Navigator.pop(context);
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _generateAIDescription({bool useCustom = false}) async {
    // Validate product title
    if (widget.productTitle == null || widget.productTitle!.trim().isEmpty) {
      setSnackbar(
        "PRODUCT_TITLE_REQUIRED_FOR_AI_DESCRIPTION".translate(context: context),
        context,
      );
      return;
    }

    // Validate field type
    if (widget.fieldType == null || widget.fieldType!.trim().isEmpty) {
      setSnackbar("FIELD_TYPE_REQUIRED".translate(context: context), context);
      return;
    }

    setState(() {
      if (useCustom) {
        isGeneratingCustomPrompt = true;
      } else {
        isGeneratingAI = true;
      }
    });

    try {
      final response = await _aiRepository.generateProductDescription(
        title: widget.productTitle!,
        fieldType: widget.fieldType!,
        customPrompt: useCustom ? customPromptController.text.trim() : '',
        useCustomPrompt: useCustom ? '1' : '0',
      );

      if (response['error'] == false && response['data'] != null) {
        final generatedText = response['data']['generated_text'] ?? '';

        if (generatedText.isNotEmpty) {
          controller.setText(generatedText);
          result = generatedText;

          setSnackbar(
            "AI_DESCRIPTION_GENERATED_SUCCESSFULLY".translate(context: context),
            context,
            backgroundColor: Colors.green,
          );
        } else {
          setSnackbar(
            "NO_DESCRIPTION_GENERATED".translate(context: context),
            context,
          );
        }
      } else {
        setSnackbar(
          response['message'] ??
              "FAILED_TO_GENERATE_DESCRIPTION".translate(context: context),
          context,
        );
      }
    } catch (e) {
      setSnackbar(
        "Error: ${e.toString()}".translate(context: context),
        context,
      );
    } finally {
      setState(() {
        if (useCustom) {
          isGeneratingCustomPrompt = false;
          customPromptController.clear();
          showCustomPromptField = false;
        } else {
          isGeneratingAI = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus(); // for close keybord
        }
      },
      child: Scaffold(
        appBar: getAppBar(appName, context),
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        body: isLoading
            ? const ShimmerEffect()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (AI_SETTINGS_STATUS == "1") ...[
                      // Two Buttons Row at the top
                      if (widget.productTitle != null &&
                          widget.productTitle!.trim().isNotEmpty &&
                          widget.fieldType != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Generate AI Description Button
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: isGeneratingAI
                                      ? null
                                      : _generateAIDescription,
                                  child: isGeneratingAI
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome,
                                              color: white,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "AI".translate(context: context),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: textFontSize14,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Use Custom Prompt Button
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showCustomPromptField = true;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.edit_note,
                                        color: white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "CUSTOM_PROMPT".translate(
                                          context: context,
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: textFontSize14,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Custom Prompt TextField (shown when button clicked)
                      if (showCustomPromptField &&
                          widget.productTitle != null &&
                          widget.productTitle!.trim().isNotEmpty &&
                          widget.fieldType != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: customPromptController,
                            enabled: !isGeneratingCustomPrompt && !isLoadingPrompts,
                            decoration: InputDecoration(
                              hintText: "ENTER_OR_SELECT_CUSTOM_AI_PROMPT"
                                  .translate(context: context),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isLoadingPrompts)
                                    const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(
                                        Icons.lightbulb_outline,
                                        color: Colors.amber,
                                      ),
                                      tooltip: "GET_PROMPT_SUGGESTIONS"
                                          .translate(context: context),
                                      onPressed: _showPromptSuggestions,
                                    ),
                                  if (isGeneratingCustomPrompt)
                                    const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.deepPurple,
                                      ),
                                      tooltip: "AI"
                                          .translate(context: context),
                                      onPressed: () => _generateAIDescription(
                                        useCustom: true,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            maxLines: 3,
                            minLines: 1,
                          ),
                        ),
                    ],
                    const SizedBox(height: 8),
                    HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: HtmlEditorOptions(
                        autoAdjustHeight: true,
                        hint: 'Please Enter Product Description here...!'
                            .translate(context: context),
                        shouldEnsureVisible: true,
                        adjustHeightForKeyboard: true,
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.aboveEditor,
                        toolbarType: ToolbarType.nativeScrollable,
                        //by default
                        defaultToolbarButtons: [
                          const StyleButtons(),
                          const FontSettingButtons(fontSizeUnit: true),
                          const FontButtons(clearAll: false),
                          const ColorButtons(),
                          const ListButtons(listStyles: false),
                          const ParagraphButtons(
                            textDirection: true,
                            lineHeight: true,
                            caseConverter: false,
                          ),
                        ],
                        gridViewHorizontalSpacing: 0,
                        gridViewVerticalSpacing: 0,
                        // dropdownBackgroundColor: white,
                        toolbarItemHeight: 30,
                        buttonColor: black,
                        buttonFocusColor: fontColor,
                        buttonBorderColor: fontColor,
                        buttonFillColor: secondary,
                        dropdownIconColor: black,
                        dropdownIconSize: 15,
                        textStyle: const TextStyle(
                          // fontSize: textFontSize16,
                          color: black,
                        ),
                        onDropdownChanged:
                            (
                              DropdownType type,
                              dynamic changed,
                              Function(dynamic)? updateSelectedItem,
                            ) {
                              return true;
                            },
                        mediaLinkInsertInterceptor:
                            (String url, InsertFileType type) {
                              return true;
                            },
                        mediaUploadInterceptor:
                            (PlatformFile file, InsertFileType type) async {
                              return true;
                            },
                      ),
                      otherOptions: OtherOptions(height: height * 0.7),
                      callbacks: Callbacks(
                        onInit: () {
                          // Set initial text when editor is initialized
                          if (!hasSetInitialText &&
                              widget.description != null &&
                              widget.description!.isNotEmpty) {
                            controller.setText(widget.description!);
                            hasSetInitialText = true;
                          }
                        },
                        onBeforeCommand: (String? currentHtml) {},
                        onChangeContent: (String? changed) {
                          result = changed!;
                        },
                        onChangeCodeview: (String? changed) {
                          result = changed!;
                        },
                        onNavigationRequestMobile: (String url) {
                          return NavigationActionPolicy.ALLOW;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: lightBlack2,
                              ),
                              onPressed: () {
                                controller.clear();
                              },
                              child: Text(
                                "Clear".translate(context: context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize14,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop(result);
                              },
                              child: Text(
                                "SAVE_LBL".translate(context: context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize14,
                                  color: white,
                                ),
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
    );
  }
}
