import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/cubits/file_import/file_import_cubit.dart';
import 'package:mywords/common/widgets/ai_text_field.dart';
import 'package:mywords/common/widgets/labeled_icons_row.dart';
import 'package:mywords/common/widgets/step_indicator_detector_widget.dart';
import 'package:mywords/constants/ai_sample_text.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_detector/pages/ai_detector_output_page.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

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
    context.read<AiWriterCubit>().reset();
    context.read<AiDetectorCubit>().reset();
    context.read<AiHumanizerCubit>().reset();
    context.read<FileImportCubit>().reset();
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
          StepIndicatorDetector(activeSteps: [1]),

          SizedBox(height: 16.ch),
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.cw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.cr),
                  border: Border.all(color: Color(0xffDADADA)),
                ),
                child: BlocConsumer<AiDetectorCubit, AiDetectorState>(
                  listener: (context, state) {
                    if (state.aiDetectorStatus == AiDetectorStatus.success) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) => AiDetectorOutputPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    } else if (state.aiDetectorStatus == AiDetectorStatus.failed) {
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
                ),
              ),
            ),
          ),
          SizedBox(height: 20.ch),
        ],
      ),
      bottomNavigationBar: BlocBuilder<AiDetectorCubit, AiDetectorState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.cw),
            padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30.ch),
            child: PrimaryButton.filled(
              isLoading: state.aiDetectorStatus == AiDetectorStatus.loading,

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

                context.read<AiDetectorCubit>().setText(text);
                context.read<AiDetectorCubit>().detectText();
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
