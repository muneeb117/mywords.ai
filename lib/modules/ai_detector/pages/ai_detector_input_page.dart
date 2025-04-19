import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/ai_text_field.dart';
import 'package:mywords/common/widgets/labeled_icons_row.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/constants/ai_sample_text.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_detector/pages/ai_detector_preference_page.dart';
import 'package:mywords/modules/ai_writer/cubit/file_import/file_import_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiDetectorInputPage extends StatefulWidget {
  const AiDetectorInputPage({super.key});

  @override
  State<AiDetectorInputPage> createState() => _AiDetectorInputPageState();
}

class _AiDetectorInputPageState extends State<AiDetectorInputPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AiDetectorCubit>().reset();
  }

  void _putTextOnBoard(String text) {
    textController.text = text;
    context.read<AiDetectorCubit>().updateText(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Detector'),
      body: Column(
        children: [
          StepIndicator(
            activeSteps: [1],
            leftText: 'Input',
            centerText: 'Preference',
            rightText: 'Output',
          ),
          SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xffDADADA),
                    ),
                  ),
                  child: BlocConsumer<AiDetectorCubit, AiDetectorState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TextFieldHeader(wordCount: state.wordCount),
                          AiTextField(
                            onChanged: (nextValue) {
                              context.read<AiDetectorCubit>().updateText(nextValue);
                            },
                            textEditingController: textController,
                          ),
                          BlocConsumer<FileImportCubit, FileImportState>(
                            listener: (context, state) {
                              print('file state is :: $state');
                              if (state.fileImportStatus == FileImportStatus.success) {
                                _putTextOnBoard(state.extractedText);
                              } else if (state.fileImportStatus == FileImportStatus.failure) {
                                context.showSnackBar(state.errorMsg);
                              }
                            },
                            builder: (context, state) {
                              return LabeledIconsRow(
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
                              );
                            },
                          ),
                          // SizedBox(height: 14),
                        ],
                      );
                    },
                  )),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BlocBuilder<AiDetectorCubit, AiDetectorState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
            child: PrimaryButton.filled(
              onTap: () {
                final text = textController.text.trim();
                if (text.isEmpty) {
                  context.showSnackBar('Input field is required');
                  return;
                }
                if (state.wordCount > 800) {
                  context.showSnackBar('You have exceeded the maximum word limit of 800. Please shorten your text.');
                  return;
                }

                context.read<AiDetectorCubit>().setText(text);
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AiDetectorPreferencePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              title: 'Continue',
              textColor: context.colorScheme.primary,
              backgroundColor: Color(0xffD24DEE).withOpacity(0.15),
              fontWeight: FontWeight.w700,
            ),
          );
        },
      ),
    );
  }
}

class _TextFieldHeader extends StatelessWidget {
  const _TextFieldHeader({required this.wordCount});

  final int wordCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Input',
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: context.colorScheme.onSurface),
              ),
              Spacer(),
              Text.rich(
                TextSpan(text: '${wordCount}', style: context.textTheme.bodySmall?.copyWith(color: AppColors.orange), children: [
                  TextSpan(
                    text: '/800 Words',
                    style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurface),
                  )
                ]),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'Please briefly describe your prompt *',
            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurface, height: 1.5),
          ),
        ],
      ),
    );
  }
}
