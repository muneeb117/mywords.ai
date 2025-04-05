import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class LabeledIconsRow extends StatelessWidget {
  const LabeledIconsRow({
    super.key,
    required this.onSampleTextCallback,
    required this.onUploadFileCallBack,
    required this.onPasteTextCallBack,
  });

  final VoidCallback onSampleTextCallback;
  final VoidCallback onUploadFileCallBack;
  final VoidCallback onPasteTextCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          LabeledIconButton(
            onPressed: onSampleTextCallback,
            text: 'Sample Text',
            assetImagePath: 'assets/images/svg/ic_sample_text.svg',
            textColor: AppColors.orange,
            bgColor: AppColors.orangeBg,
          ),
          Spacer(),
          LabeledIconButton(
            onPressed: onUploadFileCallBack,
            text: 'Upload File',
            assetImagePath: 'assets/images/svg/ic_upload_file.svg',
            textColor: AppColors.purple,
            bgColor: AppColors.purpleBg,
          ),
          Spacer(),
          LabeledIconButton(
            onPressed: onPasteTextCallBack,
            text: 'Paste Text',
            assetImagePath: 'assets/images/svg/ic_paste_text.svg',
            textColor: AppColors.green,
            bgColor: AppColors.greenBg,
          ),
        ],
      ),
    );
  }
}

class LabeledIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String assetImagePath;
  final Color textColor;
  final Color bgColor;

  const LabeledIconButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.assetImagePath,
    required this.textColor,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
            border: Border.all(
              color: Color(0xffDADADA),
            )),
        child: Row(
          children: [
            SvgPicture.asset(assetImagePath),
            SizedBox(width: 8),
            Text(
              text,
              style: context.textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.w500, fontSize: 13, letterSpacing: 0),
            ),
          ],
        ),
      ),
    );
  }
}
