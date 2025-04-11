import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_dropdown_without_icon.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
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

  String? writingPurpose = 'Essay';
  String selectedLanguage = 'English';
  TextEditingController minWordCountController = TextEditingController();
  TextEditingController maxWordCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Writer'),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepIndicator(activeSteps: [1, 2]),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select writing purpose *', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    CustomDropdownWithoutIcon(
                      items: ['Essay', 'Letter', 'Email', 'Story', 'Article', 'Discussion Board/Question Response'],
                      hint: 'Select Purpose',
                      value: writingPurpose,
                      onChanged: (value) {
                        setState(() {
                          writingPurpose = value;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    Text('Select a language *', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    CustomDropdownWithoutIcon(
                      items: ['English'],
                      hint: 'Select Language',
                      value: selectedLanguage,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 12),
                    Text('Minimum Word Count *', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    InputField(
                      hintText: 'Enter minimum word count',
                      hasPrefixIcon: false,
                      prefixIconPath: '',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: minWordCountController,
                    ),
                    SizedBox(height: 12),
                    Text('Maximum Word Count *', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    InputField(
                      hintText: 'Enter maximum word count',
                      hasPrefixIcon: false,
                      prefixIconPath: '',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: maxWordCountController,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Minimum 350 words, maximum 500 words.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
        child: BlocConsumer<AiWriterCubit, AiWriterState>(
          listener: (context, state) {
            if (state.aiWriterStatus == AiWriterStatus.success) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => AiWriterOutputPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else if (state.aiWriterStatus == AiWriterStatus.failed) {
              context.showSnackBar(state.errorMsg);
            }
          },
          builder: (context, state) {
            return PrimaryButton.gradient(
              isLoading: state.aiWriterStatus == AiWriterStatus.loading,
              onTap: () {
                final minText = minWordCountController.text.trim();
                final maxText = maxWordCountController.text.trim();

                final min = int.tryParse(minText);
                final max = int.tryParse(maxText);

                if (min == null || max == null || min < 350 || max > 500) {
                  context.showSnackBar('Please enter valid word limits!', isError: true);
                  return;
                }

                final aiWriterCubit = context.read<AiWriterCubit>();
                aiWriterCubit
                  ..setWritingPurpose(writingPurpose!)
                  ..setWritingLanguage(selectedLanguage)
                  ..setMinWordLimit(min)
                  ..setMaxWordLimit(max);

                aiWriterCubit.generateOutput();
              },
              title: 'Generate Outline',
              iconPath: 'assets/images/svg/ic_flag.svg',
              fontWeight: FontWeight.w700,
            );
          },
        ),
      ),
    );
  }
}
