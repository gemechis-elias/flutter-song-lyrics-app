// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'song_details_screen.dart';

class HomeScreen extends StatefulWidget {
  List<Map<dynamic, dynamic>> songsData;
  HomeScreen({Key? key, required this.songsData}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<String> favoriteIds = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds = prefs.getStringList('favoriteIds') ?? [];
      print("========== Loaded favorites: ");
    });
  }

  void addToFavorites(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> updatedFavorites = List<String>.from(favoriteIds);

    if (updatedFavorites.contains(itemId)) {
      updatedFavorites.remove(itemId);
      print("Removed from favorites " + itemId);
    } else {
      updatedFavorites.add(itemId);
      print("Added to favorites " + itemId);
    }

    prefs.setStringList('favoriteIds', updatedFavorites);

    setState(() {
      favoriteIds = updatedFavorites;
    });
  }

  bool isFavorite(String itemId) {
    return favoriteIds.contains(itemId);
  }

  @override
  Widget build(BuildContext context) {
    log("Home State======== ");

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Song Lyrics',
            style: TextStyle(
              fontFamily: 'Satisfy',
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          Switch(
            value: AdaptiveTheme.of(context).mode.isDark,
            onChanged: (value) {
              if (value) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // search bar
            Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.94,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(58, 237, 237, 237),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "Search a lyrics ...",
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins-ExtraLight',
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 10, top: 12, bottom: 12),
                    border: InputBorder.none,
                    suffixIcon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 32,
                        ),
                        color: const Color(0xFF292C31),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.94,
                height: MediaQuery.of(context).size.height * 0.82,
                child: ListView.builder(
                  itemCount: widget.songsData.length,
                  itemBuilder: (context, index) {
                    final song = widget.songsData[index];
                    if (searchController.text.isNotEmpty &&
                        !song['title']
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase())) {
                      return Container();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongDetailsScreen(
                                title: song['title'],
                                chord: song['chord'],
                                author: song['author'],
                                lyrics: song['lyrics'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA9DED8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(190, 196, 202, 0.2),
                                blurRadius: 14,
                                offset: Offset(0, 9),
                              ),
                            ],
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: ListTile(
                              title: Text(
                                song['title'], // Title Goes here
                                style: const TextStyle(
                                  fontFamily: 'Poppins-ExtraLight',
                                  fontSize: 17,
                                  // color: Color(0xFF292C31),
                                ),
                              ),
                              subtitle: Text(
                                song['author'] ?? "", // Author Goes here
                                style: const TextStyle(
                                  fontFamily: 'Poppins-ExtraLight',
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 58, 61, 66),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isFavorite(song['title'].toString())
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  size: 26,
                                ),
                                onPressed: () {
                                  addToFavorites(song['title'].toString());
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
