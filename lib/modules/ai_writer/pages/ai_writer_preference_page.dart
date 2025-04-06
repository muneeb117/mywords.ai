import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/ai_text_field.dart';

import 'package:mywords/common/widgets/labeled_icons_row.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/modules/ai_writer/pages/ai_writer_output_page.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiWriterPreferencePage extends StatefulWidget {
  const AiWriterPreferencePage({super.key});

  @override
  State<AiWriterPreferencePage> createState() => _AiWriterPreferencePageState();
}

class _AiWriterPreferencePageState extends State<AiWriterPreferencePage> {
  final TextEditingController aiWriterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return BlocProvider(
      create: (context) => AiWriterCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'AI Preference',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
              child: PrimaryButton.filled(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => AiWriterOutputPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                title: 'Continue',
                textColor: context.colorScheme.primary,
                backgroundColor: Color(0xffD24DEE),
                fontWeight: FontWeight.w700,
              ),
            ),
            body: Column(
              children: [
                StepIndicator(activeSteps: [1, 2]),
                SizedBox(height: 16),
                Flexible(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xffDADADA),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: BlocConsumer<AiWriterCubit, AiWriterState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _TextFieldHeader(wordCount: state.wordCount),
                                  AiTextField(
                                    onChanged: (nextValue) {
                                      context.read<AiWriterCubit>().updateText(nextValue);
                                    },
                                    textEditingController: aiWriterController,
                                  ),
                                  LabeledIconsRow(
                                    onSampleTextCallback: () {},
                                    onUploadFileCallBack: () {},
                                    onPasteTextCallBack: () {},
                                  ),
                                  SizedBox(height: 14),
                                ],
                              ),
                            );
                          },
                        ),
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


class _TextFieldHeader extends StatelessWidget {
  const _TextFieldHeader({super.key,required this.wordCount});
  final int wordCount;

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Input',
                style: context.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: context.colorScheme.onSurface),
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                    text: '${wordCount}',
                    style: context.textTheme.bodySmall?.copyWith(color: AppColors.orange),
                    children: [
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
