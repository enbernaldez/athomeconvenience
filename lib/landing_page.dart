import 'package:athomeconvenience/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 640,
                  ),
                  child: Column(
                    children: [
                      Image.asset('images/icon_landingPage.png'),
                      AutoSizeText(
                        'At-Home Convenience',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Button(
                  buttonText: 'LOG IN',
                  textType: Theme.of(context).textTheme.displaySmall,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LogInPage(
                            isRegister: false,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Button(
                  buttonText: 'REGISTER',
                  buttonColor: Colors.orange,
                  textType: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.orange[50],
                      ),
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LogInPage(
                            isRegister: true,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
