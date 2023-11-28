import 'package:flutter/material.dart';
import 'federated.dart';
import 'settings.dart';
import 'accessibility.dart';
import 'favorites.dart';
import 'mentions.dart';
import 'notifications.dart';
import 'search.dart';
import 'settings.dart';
// import 'package:fossil/home_navbar/profile_page.dart';

class DrawerColumn extends StatelessWidget{
  const DrawerColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 110),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            ViewList()
          ],
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage())
            );
          },
          child: const Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings',),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MentionsPage())
            );
          },
          child: const Row(
            children: [
              Text(
                '@',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8134AF)
                )
              ),
              SizedBox(width: 8),
              Text(
                'Mentions',
              )
            ]
          )
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF), 
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage())
            );
          },
          child: const Row(
            children: [
              Icon(Icons.favorite_outline),
              SizedBox(width: 8),
              Text('Favorites'),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF), 
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage())
            );
          },
          child: const Row(
            children: [
              Icon(Icons.notifications_outlined),
              SizedBox(width: 8),
              Text('Notifications'),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF), 
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage())
            );
          },
          child: const Row(
            children: [
              Icon(Icons.search_outlined),
              SizedBox(width: 8),
              Text('Search'),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccessibilityPage())
            );
          },
          child: const Row(
            children: [
              Icon(Icons.accessibility),
              SizedBox(width: 8),
              Text('Accessibility')
            ],
          )
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.deepPurpleAccent,
          width: 300.0,
          height: 2.0,
        ),

        const SizedBox(height: 30),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8134AF), 
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Row(
            children: [
              Icon(Icons.close),
              SizedBox(width: 8),
              Text('Close Drawer'),
            ],
          ),
        )
      ],
    );
  }
}