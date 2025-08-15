class ArtObject {
  ArtObject({
    required this.objectNumber,
    required this.title,
    required this.principalOrFirstMaker,
    required this.longTitle,
    required this.headerImageUrl,
    required this.productionPlaces,
  });

  final String objectNumber;
  final String title;
  final String longTitle;
  final String principalOrFirstMaker;
  final String headerImageUrl;
  final List<String> productionPlaces;
}
