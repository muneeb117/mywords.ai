import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class AiHumanizerDialog extends StatelessWidget {
  const AiHumanizerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.cr)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.cw, vertical: 32.ch),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.cr),
          border: Border.all(color: const Color(0xffE0E0E0)),
        ),
        child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.cw, vertical: 20.ch),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AI Humanizer Output",
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(6.cw),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child:  Icon(
                            Icons.close,
                            size: 20.csp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.ch),

                  // Subtitle
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your refined text is ready:",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.ch),

                  // Output box
                  Container(
                    constraints: BoxConstraints(minHeight: 200.ch, maxHeight: 400.ch),
                    width: double.infinity,
                    padding: EdgeInsets.all(16.cw),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16.cr),
                      border: Border.all(color: const Color(0xffDADADA)),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        state.generatedText,
                        style: context.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.ch),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: state.generatedText));
                          context.showSnackBar('Copied to clipboard');
                        },
                        icon:  Icon(Icons.copy, size: 18.csp),
                        label: const Text("Copy"),
                      ),
                      SizedBox(width: 8.cw),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon:  Icon(Icons.close, size: 20.csp),
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
