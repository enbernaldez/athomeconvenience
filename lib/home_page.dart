import 'package:athomeconvenience/constants.dart';
import 'package:athomeconvenience/shop_list_page.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var serviceCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              FractionallySizedBox(
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
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 104,
                ),
                child: Container(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 0, 16),
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
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services Available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(24.0),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var entry in serviceCategoryMap.entries)
                    Button(
                      padding: 8.0,
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ShopListPage(category: entry.key),
                        ));
                      },
                      buttonColor: Colors.lightBlue[100],
                      haveAdditional: true,
                      textType: Theme.of(context).textTheme.titleSmall,
                      image: entry.value,
                      buttonText: entry.key,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
