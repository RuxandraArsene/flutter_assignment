import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/injection.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider<CollectionCubit>(
      create: (context) {
        final cubit = getIt<CollectionCubit>();
        cubit.getArtCollection();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocBuilder<CollectionCubit, BaseState>(
          builder: (context, state) {
            if (state is CollectionLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CollectionRetrievedState) {
              final groupedCollection = state.groupedArtObjects;
              final sortedCollection = state.sortedGroupedObjectByKeys;

              return ListView(
                controller: _scrollController,
                children: sortedCollection.map((key) {
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
                      ...items.map(
                        (item) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailsPage(artObject: item),
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
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            } else if (state is CollectionErrorState) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
