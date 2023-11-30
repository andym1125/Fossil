import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: FossilHomepage(),
  ));
}

class FossilHomepage extends StatefulWidget {
  const FossilHomepage({Key? key}) : super(key: key);

  @override
  _FossilHomepageState createState() => _FossilHomepageState();
}

class _FossilHomepageState extends State<FossilHomepage> {
  final List<Toot> toots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Homepage',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Handle profile navigation
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings and privacy'),
              onTap: () {
                // Handle settings navigation
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: toots.length,
        itemBuilder: (context, index) {
          return TootCard(toot: toots[index]);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PopupMenuButton<String>(
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext context) => [
                'Federated',
                'Settings',
                'Mentions',
                'Favorites',
                'Notifications',
                'Search',
                'Accessibility'
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList(),
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Handle home button action
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Handle profile button action
              },
            ),
          ],
        ),
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
        child: Icon(Icons.add),
      ),
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

  TootCard({required this.toot, Key? key}) : super(key: key);

  @override
  _TootCardState createState() => _TootCardState();
}

class _TootCardState extends State<TootCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.toot.name,
                      style: TextStyle(
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
            SizedBox(height: 8),
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
