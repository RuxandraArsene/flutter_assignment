import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/base_state.dart';
import '../cubit/collection/collection_cubit.dart';
import '../cubit/collection/collection_state.dart';
import 'art_collection_details_page.dart';

class ArtCollectionPage extends StatefulWidget {
  const ArtCollectionPage({super.key});

  @override
  State<ArtCollectionPage> createState() => _ArtCollectionPageState();
}

class _ArtCollectionPageState extends State<ArtCollectionPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CollectionCubit>(context).getArtCollection();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        BlocProvider.of<CollectionCubit>(context).loadMoreGroups();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rijksmuseum Art Collection',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: BlocBuilder<CollectionCubit, BaseState>(
          builder: (context, state) {
            if (state is CollectionLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CollectionRetrievedState) {
              final groupedCollection = state.groupedArtObjects;
              final sortedCollection = state.sortedGroupedObjectByKeys;
              final hasMoreItems = state.hasMoreGroupsToLoad ? 1 : 0;

              return ListView.builder(
                controller: _scrollController,
                itemCount: sortedCollection.length + hasMoreItems,
                itemBuilder: (context, index) {
                  if (index == sortedCollection.length) {
                    return state.isLoadingMoreData
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }

                  final key = sortedCollection[index];
                  final items = groupedCollection[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          key,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...items
                          .map(
                            (item) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailsPage(artObject: item),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      item.headerImageUrl,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              height: 200,
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      SizedBox(height: 12),
                    ],
                  );
                },
              );
            } else if (state is CollectionErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          state.errorMessage,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
