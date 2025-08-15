import 'package:flutter/material.dart';

import '../../core/model/art_object.dart';

class DetailsPage extends StatelessWidget {
  final ArtObject artObject;

  const DetailsPage({super.key, required this.artObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(artObject.headerImageUrl),
            SizedBox(height: 16),
            Text(
              artObject.longTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("By: ${artObject.principalOrFirstMaker}"),
            if (artObject.productionPlaces.isNotEmpty) ...[
              SizedBox(height: 8),
              Text("Produced in: ${artObject.productionPlaces.join(', ')}"),
            ],
          ],
        ),
      ),
    );
  }
}
