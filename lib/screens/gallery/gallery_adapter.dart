import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletons/skeletons.dart';

class GalleryAdapter {
  List<Map<dynamic, dynamic>> items = [];
  List<Widget> itemsTile = [];

  GalleryAdapter(this.items, onItemClick);

  Widget getView(Function onClick) {
    return Container(
      //color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(left: 5, right: 5, top: 2),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 10,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: GestureDetector(
                onTap: () {
                  onClick(index, items[index]['image']);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: items[index]['image'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SkeletonItem(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF222222),
                              Color(0xFF242424),
                              Color(0xFF2B2B2B),
                              Color(0xFF242424),
                              Color(0xFF222222),
                            ],
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    );
  }
}
