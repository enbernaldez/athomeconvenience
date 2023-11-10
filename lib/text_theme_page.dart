import 'package:flutter/material.dart';

class TextThemePage extends StatefulWidget {
  const TextThemePage({super.key});

  @override
  State<TextThemePage> createState() => TextThemePageState();
}

class TextThemePageState extends State<TextThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'bodyLarge',
                    hintStyle: Theme.of(context).textTheme.bodyLarge!,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'bodyMedium',
                    hintStyle: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'bodySmall',
                    hintStyle: Theme.of(context).textTheme.bodySmall!,
                  ),
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'displayLarge',
                    hintStyle: Theme.of(context).textTheme.displayLarge!,
                  ),
                  style: Theme.of(context).textTheme.displayLarge!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'displayMedium',
                    hintStyle: Theme.of(context).textTheme.displayMedium!,
                  ),
                  style: Theme.of(context).textTheme.displayMedium!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'displaySmall',
                    hintStyle: Theme.of(context).textTheme.displaySmall!,
                  ),
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'headlineLarge',
                    hintStyle: Theme.of(context).textTheme.headlineLarge!,
                  ),
                  style: Theme.of(context).textTheme.headlineLarge!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'headlineMedium',
                    hintStyle: Theme.of(context).textTheme.headlineMedium!,
                  ),
                  style: Theme.of(context).textTheme.headlineMedium!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'headlineSmall',
                    hintStyle: Theme.of(context).textTheme.headlineSmall!,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'labelLarge',
                    hintStyle: Theme.of(context).textTheme.labelLarge!,
                  ),
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'labelMedium',
                    hintStyle: Theme.of(context).textTheme.labelMedium!,
                  ),
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'labelSmall',
                    hintStyle: Theme.of(context).textTheme.labelSmall!,
                  ),
                  style: Theme.of(context).textTheme.labelSmall!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'titleLarge',
                    hintStyle: Theme.of(context).textTheme.titleLarge!,
                  ),
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'titleMedium',
                    hintStyle: Theme.of(context).textTheme.titleMedium!,
                  ),
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'titleSmall',
                    hintStyle: Theme.of(context).textTheme.titleSmall!,
                  ),
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
