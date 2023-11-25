import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final dynamic padding; //button vertical content padding
  final Function()? onPress;
  final Color? buttonColor;
  final bool? haveAdditional; //for category button's image and stroke
  final TextStyle? textType; //textStyle
  final String? image;
  final String buttonText;
  final IconData? icon;
  final Color? iconColor;

  const Button({
    super.key,
    this.padding,
    required this.onPress,
    this.buttonColor,
    this.haveAdditional,
    this.textType,
    this.image,
    required this.buttonText,
    this.icon,
    this.iconColor,
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
              visible: icon != null ? true : false,
              child: Icon(
                icon,
                color: iconColor ?? Colors.blue[50],
              ),
            ),
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
                  style: textType ??
                      Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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

class BackArrow extends StatelessWidget {
  final Function()? onTap;

  const BackArrow({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.blue,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class DialogButton extends StatelessWidget {
  final Function() onPress;
  final String buttonText;
  final Color? textColor;

  const DialogButton({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final Function() onPress;
  final String buttonText;

  const EditButton({
    super.key,
    required this.onPress,
    required this.buttonText
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

