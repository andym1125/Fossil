import 'package:flutter/material.dart';
import 'home_drawer/drawer_list.dart';
import 'home_navbar/profile_page.dart';
import 'home_post/post_main.dart';
import 'home_post/new_post/update_status.dart';
import 'home_post/post_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      key: _scaffoldKey,

      body: PostClass(),

      floatingActionButton: FloatingActionButton(

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPost(

                onSubmit: (text) {
                  setState(() {
                    posts.add(Post(
                      profilePic: 'images/profile_pic.png',
                      displayName: 'Aryan Patel',
                      userName: 'Aryan_Patel',
                      content: text,
                      imageContent: null,
                      gifContent: null,
                    ));
                  });
                }
              )
            )
          );
        },
        child: const Icon(Icons.rocket_launch_outlined),
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