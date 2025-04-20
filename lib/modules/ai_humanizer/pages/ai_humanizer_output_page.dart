import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/check_for_ai_dialog.dart';
import 'package:mywords/common/widgets/step_indicator_humanizer_widget.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/home/cubit/home_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiHumanizerOutputPage extends StatefulWidget {
  const AiHumanizerOutputPage({super.key});

  @override
  State<AiHumanizerOutputPage> createState() => _AiHumanizerOutputPageState();
}

class _AiHumanizerOutputPageState extends State<AiHumanizerOutputPage> {
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
      appBar: CustomAppBar(title: 'AI Humanizer'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StepIndicatorHumanizer(activeSteps: [1, 2]),
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
                child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
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
                          child: BlocBuilder<AiHumanizerCubit, AiHumanizerState>(
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
            SizedBox(height: 16),
            // _InfoStaticWidget(),
            // SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<AiHumanizerCubit, AiHumanizerState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
            child: Row(
              children: [
                Text('${state.generatedOutputWordCount} Words', style: context.textTheme.titleMedium),
                SizedBox(width: 48),
                Expanded(
                  child: PrimaryButton.filled(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CheckForAiDialog(),
                        );
                      },
                      title: 'Check for AI',
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xffD24DEE).withOpacity(0.15),
                      textColor: context.colorScheme.primary),
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: SvgPicture.asset('assets/images/svg/ic_copy.svg'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: state.generatedText));
                    context.showSnackBar('Copied to Clipboard!');
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
