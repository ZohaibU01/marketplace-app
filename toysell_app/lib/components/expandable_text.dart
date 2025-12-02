import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/theme.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;

  const ExpandableText({
    super.key,
    required this.text,
    this.style,
    this.trimLines = 3,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(
      builder: (themeController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the max width for the text
            final maxWidth = constraints.maxWidth - (Constants.screenPadding * 2);

            // Check if the text overflows
            final textPainter = TextPainter(
              text: TextSpan(
                text: widget.text,
                style: widget.style ?? DefaultTextStyle.of(context).style,
              ),
              maxLines: widget.trimLines,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(maxWidth: maxWidth);

            final isOverflowing = textPainter.didExceedMaxLines;

            if (!isOverflowing && !isExpanded) {
              return Text(
                widget.text,
                style: widget.style,
              );
            }

            final displayText = isExpanded
                ? widget.text
                : _getTrimmedText(widget.text, widget.trimLines, maxWidth);

            return RichText(
              text: TextSpan(
                style: widget.style ?? DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: displayText),
                  if (isOverflowing || isExpanded)
                    TextSpan(
                      text: isExpanded ? ' See Less' : ' See More',
                      style: TextStyle(
                        color: themeController.textcolor,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getTrimmedText(String text, int maxLines, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: widget.style ?? DefaultTextStyle.of(context).style,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );

    int low = 0;
    int high = text.length;
    int mid;

    String result = text;

    while (low <= high) {
      mid = (low + high) ~/ 2;
      final testText = text.substring(0, mid) + '...';
      textPainter.text = TextSpan(
        text: testText,
        style: widget.style ?? DefaultTextStyle.of(context).style,
      );
      textPainter.layout(maxWidth: maxWidth);

      if (textPainter.didExceedMaxLines) {
        high = mid - 1;
      } else {
        result = testText;
        low = mid + 1;
      }
    }

    return result;
  }
}
