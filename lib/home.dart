import 'package:flutter/material.dart';
import 'home_drawer/drawer_list.dart';
import 'home_navbar/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Toot> toots = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      key: _scaffoldKey,

      body: ListView.builder(
        itemCount: toots.length,
        itemBuilder: (context, index) {
          return TootCard(toot: toots[index]);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger adding a new Toot
          setState(() {
            toots.add(
              Toot(
                name: 'New User',
                username: '@newuser@mastodon.social',
                text: 'New post',
              ),
            );
          });
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top:Radius.circular(20.0), bottom: Radius.circular(20.0)),

        child: BottomAppBar(
          elevation: 90,
          color: Colors.white,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              IconButton(
                tooltip: 'Open side bar',
                icon: const Icon(Icons.menu_rounded),
                onPressed: _openDrawer
              ),
              IconButton(
                tooltip: 'Home button',
                icon: const Icon(Icons.home_rounded),
                onPressed: () {

                },
              ),

              IconButton(
                tooltip: 'OpenProfile',
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage())
                  );
                }
              ),
            ],
          )
        )
      ),

      drawer: const Drawer(
        backgroundColor: Colors.white,
        child: DrawerColumn(),
      )
    );
  }
}

class Toot {
  final String name;
  final String username;
  final String text;
  int likeCount;

  Toot({
    required this.name,
    required this.username,
    required this.text,
    this.likeCount = 0,
  });
}

class TootCard extends StatefulWidget {
  final Toot toot;

  const TootCard({required this.toot, Key? key}) : super(key: key);

  @override
  _TootCardState createState() => _TootCardState();
}

class _TootCardState extends State<TootCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.toot.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.toot.username,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.toot.text,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment, color: Colors.black26),
                    SizedBox(width: 4),
                    Text('0'), // You can replace '0' with the actual comment count
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.toot.likeCount++; // Increment like count
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.black26), // Change to filled heart icon
                      SizedBox(width: 4),
                      Text(widget.toot.likeCount.toString()), // Display the like count
                    ],
                  ),
                ),
                Icon(Icons.cached, color: Colors.black26),
                Icon(Icons.ios_share, color: Colors.black26),
              ],
            ),
          ],
        ),
      ),
    );
  }
}