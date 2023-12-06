import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';

class WorksSection extends StatelessWidget {
  final String shopId;
  const WorksSection({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('works')
          .where('uid', isEqualTo: shopId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<String> worksImageUrl = snapshot.data!.docs.map((work) {
            return work['image_url'] as String;
          }).toList();

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: worksImageUrl.map((link) {
              return FractionallySizedBox(
                widthFactor: 0.48,
                child: FullScreenWidget(
                  disposeLevel: DisposeLevel.Low,
                  child: Center(
                    child: Hero(
                      tag: link,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: link,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }

        return const Text('No works posted yet.');
      },
    );
  }
}
