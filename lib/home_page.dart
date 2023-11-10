import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 36, bottom: 36),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                      hintText: 'Search...',
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 104,
              ),
              child: Container(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Home services available exclusively in Ligao City!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset('images/pic.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Services Available',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset(
                                            'images/icon_electrical.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Electrical',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Electrical',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset('images/icon_handyman.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Handyman',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Handyman',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset(
                                            'images/icon_bodygroomer.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Body Groomer',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Body Groomer',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset('images/icon_plumber.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Plumber',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Plumber',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset('images/icon_cleaning.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Cleaning',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Cleaning',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset(
                                            'images/icon_technician.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Technician',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Technician',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset(
                                            'images/icon_greenscaping.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Greenscaping',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Greenscaping',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Image.asset('images/icon_petcare.png'),
                                        Stack(
                                          children: [
                                            AutoSizeText(
                                              'Pet Care',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors
                                                          .lightBlue[100]!,
                                                  ),
                                              minFontSize: 12,
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              'Pet Care',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
