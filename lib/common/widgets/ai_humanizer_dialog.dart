import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiHumanizerDialog extends StatelessWidget {
  const AiHumanizerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffE0E0E0)),
        ),
        child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AI Humanizer Output",
                        style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.green),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(6), // Increased tap area
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                          child: const Icon(Icons.close, size: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Your refined text is ready:", style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                  ),
                  const SizedBox(height: 12),

                  // Output box
                  Container(
                    constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xffDADADA)),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        state.generatedText,
                        style: context.textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.black87),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: state.generatedText));
                          context.showSnackBar('Copied to clipboard');
                        },
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text("Copy"),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 20),
                        label: const Text("Close"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
