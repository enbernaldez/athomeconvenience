import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class button extends StatelessWidget {
  final dynamic padding; //button vertical content padding
  final Function()? onPress;
  final Color? buttonColor;
  final bool? haveAdditional; //for category button's image and stroke
  final TextStyle? textType; //textStyle
  final String? image;
  final String buttonText;

  const button({
    super.key,
    this.padding,
    required this.onPress,
    this.buttonColor,
    this.haveAdditional,
    this.textType,
    this.image,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(buttonColor ?? Colors.blue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: padding ?? 12.0, horizontal: 12.0),
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Visibility(
              visible: haveAdditional ?? false,
              child: Image.asset(image ?? ''),
            ),
            Stack(
              children: [
                Visibility(
                  visible: haveAdditional ?? false,
                  child: AutoSizeText(
                    buttonText,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.lightBlue[100]!,
                        ),
                    minFontSize: 12,
                    maxLines: 1,
                  ),
                ),
                AutoSizeText(
                  buttonText,
                  style: textType ?? Theme.of(context).textTheme.titleMedium,
                  minFontSize: 12,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
