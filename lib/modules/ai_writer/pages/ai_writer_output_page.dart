import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiWriterOutputPage extends StatefulWidget {
  const AiWriterOutputPage({super.key});

  @override
  State<AiWriterOutputPage> createState() => _AiWriterOutputPageState();
}

class _AiWriterOutputPageState extends State<AiWriterOutputPage> {
  final TextEditingController aiWriterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Writer'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StepIndicator(
              activeSteps: [1, 2, 3],
              leftText: 'Prompt',
              centerText: 'Purpose',
              rightText: 'Output',
            ),
            SizedBox(height: 16),
            Container(
                height: 250,
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
                                height: 300,
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
            _InfoStaticWidget(),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
        child: PrimaryButton.gradient(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, RouteManager.home, (route) => false);
          },
          title: 'Humanize Text',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoStaticWidget extends StatelessWidget {
  const _InfoStaticWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                child: Row(
                  children: [
                    Text(
                      '100%',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Color(0xffFF3D00),
                      ),
                    ),
                    SizedBox(width: 30),
                    Text.rich(
                      TextSpan(
                        text: 'Your Text is likely to be written',
                        children: [
                          TextSpan(
                            text: ' by AI\n9/9 ',
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: Color(0xffFC5A5A)),
                            children: [
                              TextSpan(
                                text: 'sentences AI generated',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xffDADADA),
                height: 0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Third Party AI Scores',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/svg/ic_human.svg'),
                        SizedBox(width: 7),
                        Text(
                          'Human',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff45C646),
                            letterSpacing: 0,
                            wordSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 15),
                        SvgPicture.asset('assets/images/svg/ic_likely_ai.svg'),
                        SizedBox(width: 7),
                        Text(
                          'Likely AI',
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600, color: Color(0xffFABB18), letterSpacing: 0, wordSpacing: 0),
                        ),
                        SizedBox(width: 15),
                        SvgPicture.asset('assets/images/svg/ic_ai_generated.svg'),
                        SizedBox(width: 7),
                        Text(
                          'AI',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFC5A5A),
                            letterSpacing: 0,
                            wordSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AiServicesTile(
                          title: 'Content AI Scale',
                          assetPath: 'assets/images/svg/ic_human.svg',
                        ),
                        SizedBox(width: 5),
                        AiServicesTile(
                          title: 'GPTZero',
                          assetPath: 'assets/images/svg/ic_gpt_loader.svg',
                        ),
                        SizedBox(width: 5),
                        AiServicesTile(
                          title: 'ZERO GPT',
                          assetPath: 'assets/images/svg/ic_gpt_loader.svg',
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AiServicesTile(
                          title: 'OPENAI',
                          assetPath: 'assets/images/svg/ic_gpt_loader.svg',
                        ),
                        SizedBox(width: 5),
                        AiServicesTile(
                          title: 'Turnitin',
                          assetPath: 'assets/images/svg/ic_human.svg',
                        ),
                        SizedBox(width: 5),
                        AiServicesTile(
                          title: 'CopyLeaks',
                          assetPath: 'assets/images/svg/ic_human.svg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AiServicesTile extends StatelessWidget {
  const AiServicesTile({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xffB3B3B3).withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetPath),
          SizedBox(width: 6),
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
