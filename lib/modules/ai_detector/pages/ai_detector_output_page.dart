import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/check_for_ai_dialog.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/modules/home/cubit/home_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiDetectorOutputPage extends StatefulWidget {
  const AiDetectorOutputPage({super.key});

  @override
  State<AiDetectorOutputPage> createState() => _AiDetectorOutputPageState();
}

class _AiDetectorOutputPageState extends State<AiDetectorOutputPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchDocumentHours();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Detector'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StepIndicator(
              activeSteps: [1, 2, 3],
              leftText: 'Input',
              centerText: 'Preference',
              rightText: 'Output',
            ),
            SizedBox(height: 16),
            Container(
                height: 380,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xffDADADA),
                  ),
                ),
                child: BlocConsumer<AiWriterCubit, AiWriterState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: Text(
                            'Output',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Divider(
                          color: Color(0xffDADADA),
                          height: 0,
                        ),
                        Expanded(
                          child: BlocBuilder<AiWriterCubit, AiWriterState>(
                            builder: (context, state) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: SingleChildScrollView(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: SelectableText(
                                        state.generatedText,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    )),
                                decoration: BoxDecoration(),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
        child: PrimaryButton.gradient(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const CheckForAiDialog(),
            );
          },
          title: 'Humanize Text',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
