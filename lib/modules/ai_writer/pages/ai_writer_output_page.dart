import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
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
          StepIndicator(activeSteps: [1, 2, 3]),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
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
                            BlocBuilder<AiWriterCubit, AiWriterState>(
                              builder: (context, state) {
                                return Container(
                                  width: double.infinity,
                                  height: 300,
                                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: SingleChildScrollView(
                                      child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Text(
                                      state.generatedText,
                                      style: context.textTheme.titleMedium,
                                    ),
                                  )),
                                  decoration: BoxDecoration(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
          ),
          SizedBox(height: 16),
          _InfoStaticWidget(),
        ],
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
        listener: (context, state) {
          // TODO: implement listener
        },
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
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400, color: Color(0xffFC5A5A)),
                            children: [
                              TextSpan(
                                text: 'sentences AI generated',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
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
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600, color: Color(0xff45C646), letterSpacing: 0, wordSpacing: 0),
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
                        SizedBox(width: 6),
                        AiServicesTile(
                          title: 'GPTZero',
                          assetPath: 'assets/images/svg/ic_gpt_loader.svg',
                        ),
                        SizedBox(width: 6),
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
                        SizedBox(width: 6),
                        AiServicesTile(
                          title: 'Turnitin',
                          assetPath: 'assets/images/svg/ic_human.svg',
                        ),
                        SizedBox(width: 6),
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
          SizedBox(width: 8),
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
