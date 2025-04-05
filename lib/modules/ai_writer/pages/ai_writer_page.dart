import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/widgets/ai_text_field.dart';

import 'package:mywords/common/widgets/labeled_icons_row.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiWriterPage extends StatefulWidget {
  const AiWriterPage({super.key});

  @override
  State<AiWriterPage> createState() => _AiWriterPageState();
}

class _AiWriterPageState extends State<AiWriterPage> {
  final TextEditingController aiWriterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AiWriterCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'AI Writer',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Column(
              children: [
                StepIndicator(currentStep: 1),
                SizedBox(height: 16),
                BlocConsumer<AiWriterCubit, AiWriterState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xffDADADA))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
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
                                            text: '${state.wordCount}',
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
                                    style: context.textTheme.bodySmall?.copyWith(
                                      color: context.colorScheme.onSurface,
                                      height: 1.5
                                    ),
                                  ),
                                ],
                              ),
                            ),

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
                          ],
                        ));
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
