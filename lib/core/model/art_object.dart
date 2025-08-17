class ArtObject {
  ArtObject({
    required this.objectNumber,
    required this.title,
    required this.principalOrFirstMaker,
    required this.longTitle,
    required this.imageUrl,
    required this.productionPlaces,
  });

  final String objectNumber;
  final String title;
  final String longTitle;
  final String principalOrFirstMaker;
  final String imageUrl;
  final List<String> productionPlaces;
}
