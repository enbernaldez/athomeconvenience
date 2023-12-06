import 'package:flutter/material.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "OR",
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
