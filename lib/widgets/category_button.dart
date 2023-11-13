import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String image;
  final String category;

  const CategoryButton({
    super.key,
    required this.image,
    required this.category,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {},
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image.asset(widget.image),
                Stack(
                  children: [
                    AutoSizeText(
                      widget.category,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.lightBlue[100]!,
                          ),
                      minFontSize: 12,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      widget.category,
                      style: Theme.of(context).textTheme.titleSmall,
                      minFontSize: 12,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
