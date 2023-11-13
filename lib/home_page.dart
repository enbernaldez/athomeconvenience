import 'package:athomeconvenience/shop_list_page.dart';
import 'package:athomeconvenience/widgets/buttons.dart';
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
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Electrical")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_electrical.png',
                  buttonText: 'Electrical',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Handyman")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_handyman.png',
                  buttonText: 'Handyman',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Body Groomer")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  image: 'images/icon_bodygroomer.png',
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  buttonText: 'Body Groomer',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Plumber")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_plumber.png',
                  buttonText: 'Plumber',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Cleaning")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_cleaning.png',
                  buttonText: 'Cleaning',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Technician")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_technician.png',
                  buttonText: 'Technician',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Greenscaping")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_greenscaping.png',
                  buttonText: 'Greenscaping',
                ),
                button(
                  padding: 8.0,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopListPage(category: "Pet Care")));
                  },
                  buttonColor: Colors.lightBlue[100],
                  haveAdditional: true,
                  textType: Theme.of(context).textTheme.titleSmall,
                  image: 'images/icon_petcare.png',
                  buttonText: 'Pet Care',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
