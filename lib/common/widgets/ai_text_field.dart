import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiTextField extends StatelessWidget {
  const AiTextField({
    super.key,
    required this.textEditingController,
    this.onChanged,
  });

  final TextEditingController textEditingController;
  final Function(String)? onChanged;



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffDADADA)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: TextFormField(
            maxLines: null,
            expands: true,
            style: TextStyle(
              color: context.colorScheme.onSurface,
            ),
            cursorColor: context.colorScheme.onSurface.withOpacity(0.5),
            controller: textEditingController,
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: onChanged,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        Visibility(
          visible: textEditingController.text.isEmpty,
          child: Container(
            height: 300,
            child: IgnorePointer(
              child: Center(
                child: Text(
                  'Start by generating or humanizing\nyour first document.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Color(0xff616161),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}