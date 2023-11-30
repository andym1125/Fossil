import 'package:flutter/material.dart';

class LoginPageState extends StatefulWidget {
  const LoginPageState({super.key});

  @override
  State<LoginPageState> createState() => _LoginPageStateState();
}

class _LoginPageStateState extends State<LoginPageState> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();

  String user = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // title
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),

        title: const Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            height: 0,
          )
        ),
        backgroundColor: const Color(0xFF8F87EC),
        // elevation: 0,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          // Text
          const SizedBox(height: 10.0),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Log in the server @mastodon.social.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                height: 0,
              )
            )
          ),

          // Username and Password text boxes
          Column(
            children: <Widget>[

              // Username text box
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                 controller: userName,
                 decoration: InputDecoration(
                   hintText: 'Username @Mastodon.social',
                   hintStyle: const TextStyle(color: Color(0xFF8F87EC)),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))
                 )
                )
              ),

              // Password text box
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: password,
                  obscureText: true, // to hide the password
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Color(0xFF8F87EC)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))
                  )
                )
              )
            ],
          ),

          // Text for debugging purpose
          // TODO: Remove this in future
          // Text('Entered username: $user'),
          // Text('Entered password: $pass'),

          // next Button
          // TODO: Need to verify the username and password
          // TODO: Need to show error if authentication fails
          // TODO: Need to take user to home page if authentication succeed
          // TODO: Show error if user has left any of the text box empty
          // TODO: Show error when the servers are down
          const SizedBox(height: 20.0),
          SizedBox(
            height: 48.0,
            width: 370.0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  user = userName.text;
                  pass = password.text;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFF211C4E))
                ),
                backgroundColor: Colors.white
              ),
              child: const Text(
                'next',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 0,
                )
              )
            )
          )
        ]
      )
    );
  }
}