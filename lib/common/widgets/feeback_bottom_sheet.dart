import 'package:flutter/material.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/urls/urls.dart';

void showFeedbackBottomSheet(BuildContext context) {
  final TextEditingController controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    'Feedback',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.purpleBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Your text goes here...',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We'll email you back as soon as we can",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton.filled(
                    fontWeight: FontWeight.w700,
                    backgroundColor:
                        controller.text.trim().isEmpty
                            ? AppColors.accent.withOpacity(0.5)
                            : AppColors.accent,
                    textColor:
                        controller.text.trim().isEmpty
                            ? AppColors.white.withOpacity(0.5)
                            : AppColors.white,
                    onTap: () {
                      if (controller.text.trim().isEmpty) {
                        return;
                      }

                      final feedback = controller.text.trim();
                      Urls.sendFeedbackEmail(context, feedback);
                    },
                    title: 'Submit',
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
