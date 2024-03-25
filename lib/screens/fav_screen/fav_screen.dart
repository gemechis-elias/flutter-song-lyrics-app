import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../song_details_screen.dart';

class FavScreeen extends StatefulWidget {
  List<Map<dynamic, dynamic>> songsData;
  FavScreeen({Key? key, required this.songsData}) : super(key: key);

  @override
  FavScreeenState createState() => FavScreeenState();
}

class FavScreeenState extends State<FavScreeen> {
  List<Map<dynamic, dynamic>> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    setState(() {
      favoriteSongs = widget.songsData
          .where((song) => favoriteIds.contains(song['title'].toString()))
          .toList();
    });
  }

  void addToFavorites(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Favorites',
              style: TextStyle(
                fontFamily: 'Satisfy',
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 25,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.94,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: ListView.builder(
                    itemCount: favoriteSongs.length,
                    itemBuilder: (context, index) {
                      final song = favoriteSongs[index];
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
                                  ),
                                ),
                                subtitle: Text(
                                  song['author'], // Author Goes here
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-ExtraLight',
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    size: 26,
                                  ),
                                  onPressed: () {
                                    // Handle remove from favorites here if needed
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
      ),
    );
  }
}
