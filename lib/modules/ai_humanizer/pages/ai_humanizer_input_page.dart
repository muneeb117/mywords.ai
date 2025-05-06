import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/cubits/file_import/file_import_cubit.dart';
import 'package:mywords/common/widgets/ai_text_field.dart';
import 'package:mywords/common/widgets/labeled_icons_row.dart';
import 'package:mywords/common/widgets/show_upgrade_dialog.dart';
import 'package:mywords/common/widgets/step_indicator_humanizer_widget.dart';
import 'package:mywords/constants/ai_sample_text.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/ai_humanizer/pages/ai_humanizer_output_page.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/modules/paywall/cubit/paywall_cubit/paywall_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class AiHumanizerInputPage extends StatefulWidget {
  const AiHumanizerInputPage({super.key});

  @override
  State<AiHumanizerInputPage> createState() => _AiHumanizerInputPageState();
}

class _AiHumanizerInputPageState extends State<AiHumanizerInputPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AiWriterCubit>().reset();
    context.read<AiDetectorCubit>().reset();
    context.read<AiHumanizerCubit>().reset();
    context.read<FileImportCubit>().reset();
  }

  void _putTextOnBoard(String text) {
    textController.text = text;
    context.read<AiHumanizerCubit>().updateText(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return BlocConsumer<FileImportCubit, FileImportState>(
      listener: (context, fileState) {
        print('file state is :: $fileState');
        if (fileState.fileImportStatus == FileImportStatus.success) {
          _putTextOnBoard(fileState.extractedText);
        } else if (fileState.fileImportStatus == FileImportStatus.failure) {
          context.showSnackBar(fileState.errorMsg);
        }
      },
      builder: (context, fileState) {
        return Scaffold(
          appBar: CustomAppBar(title: 'AI Humanizer'),
          body: Column(
            children: [
              StepIndicatorHumanizer(activeSteps: [1]),
              SizedBox(height: 16.ch),
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.cw),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.cr),
                      border: Border.all(color: Color(0xffDADADA)),
                    ),
                    child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
                      listener: (context, state) {
                        if (state.aiHumanizeStatus == AiHumanizeStatus.success) {
                          context.read<AiHumanizerCubit>().saveUserPrompt();
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      AiHumanizerOutputPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        } else if (state.aiHumanizeStatus == AiHumanizeStatus.limitExceeded) {
                          showUpgradeDialog(context, remainingWords: state.wordsLeft);
                        } else if (state.aiHumanizeStatus == AiHumanizeStatus.failed) {
                          context.showSnackBar(state.errorMsg);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TextFieldHeader(wordCount: state.wordCount),
                            AiTextField(
                              onChanged: (nextValue) {
                                context.read<AiHumanizerCubit>().updateText(nextValue);
                              },
                              textEditingController: textController,
                            ),
                            LabeledIconsRow(
                              /// On sample text selection
                              onSampleTextCallback: () {
                                final sampleText = AiSampleText.samplePrompt;
                                _putTextOnBoard(sampleText);
                              },

                              /// On upload file
                              onUploadFileCallBack: () {
                                context.read<FileImportCubit>().importFile();
                              },

                              /// On paste text
                              onPasteTextCallBack: () async {
                                final clipboardData = await Clipboard.getData('text/plain');
                                final text = clipboardData?.text;
                                if (text?.isNotEmpty ?? false) {
                                  _putTextOnBoard(text!);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.ch),
            ],
          ),
          bottomNavigationBar: BlocBuilder<AiHumanizerCubit, AiHumanizerState>(
            builder: (context, state) {
              return Builder(
                builder: (context) {
                  final paywallState = context.watch<PaywallCubit>().state;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.cw),
                    padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30.ch),
                    child: PrimaryButton.filled(
                      isLoading: state.aiHumanizeStatus == AiHumanizeStatus.loading,
                      onTap: () {
                        final text = textController.text.trim();
                        if (text.isEmpty) {
                          context.showSnackBar('Input field is required');
                          return;
                        }
                        if (state.wordCount > 800) {
                          context.showSnackBar(
                            'You have exceeded the maximum word limit of 800. Please shorten your text.',
                          );
                          return;
                        }

                        final cubit = context.read<AiHumanizerCubit>();
                        cubit.setText(text);
                        cubit
                          ..setPromptType(fileState.fileName.isNotEmpty ? 'file' : 'text')
                          ..setFileName(fileState.fileName.isNotEmpty ? fileState.fileName : '');

                        log('is user pro :: ${paywallState.isPremiumUser}');
                        cubit.humanizeText(isPremium: paywallState.isPremiumUser);
                      },
                      title: 'Continue',
                      textColor: context.colorScheme.primary,
                      backgroundColor: Color(0xffD24DEE).withOpacity(0.15),
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _TextFieldHeader extends StatelessWidget {
  const _TextFieldHeader({required this.wordCount});

  final int wordCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.cw, vertical: 12.ch),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Input',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                  text: '${wordCount}',
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.orange),
                  children: [
                    TextSpan(
                      text: '/800 Words',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.ch),
          Text(
            'Please briefly describe your prompt *',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
