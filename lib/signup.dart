import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fossil/home.dart';
import 'fossil.dart';
import 'package:mastodon_api/mastodon_api.dart';

class SignupPageState extends StatefulWidget {

  // ignore: prefer_typing_uninitialized_variables
  final fossil;

  const SignupPageState({super.key, required this.fossil});

  @override
  State<SignupPageState> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPageState> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  final TextEditingController password2 = TextEditingController();
  String errorText = '';
  var fossil = Fossil();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // title
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),

        title: const Text(
            'Create Account',
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

      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

          // Username, emailAddress, password text box
          Column(
            children: <Widget>[

              // User name text box
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

              // email text box
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                      controller: emailAddress,
                      decoration: InputDecoration(
                          hintText: 'email address',
                          hintStyle: const TextStyle(color: Color(0xFF8F87EC)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))
                      )
                  )
              ),

              // Password text box
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                      controller: password1,
                      obscureText: true, // to hide the password
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Color(0xFF8F87EC)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))
                      )
                  )
              ),

              // confirm password text box
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                      controller: password2,
                      obscureText: true, // to hide the password
                      decoration: InputDecoration(
                          hintText: 'Confirm password',
                          hintStyle: const TextStyle(color: Color(0xFF8F87EC)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))
                      )
                  )
              )
            ]
          ),
          const SizedBox(
            height: 16,
          ),

          // next Button
          SizedBox(
              height: 48.0,
              width: 350.0,
              child: ElevatedButton(
                  onPressed: () async {
                    String username = userName.text;
                    String email = emailAddress.text;
                    String password = password1.text;

                    if(password1.text != password2.text) {
                      setState(() {
                        errorText = 'Passwords do not match';
                      });
                      return;
                    }

                    var status = await fossil.createAccount(username, email, password);
                    if(status != HttpStatus.ok) {
                      setState(() {
                        errorText = 'Account creating failed';
                      });
                      return;
                    }

                    debugPrint('----- sent verification email');

                    var waitCount = 1;
                    var completed = (await fossil.verifyAccount()) != HttpStatus.ok;
                    while(completed) {
                      completed = (await fossil.verifyAccount()) != HttpStatus.ok;
                      waitCount++;
                      debugPrint('----- Waiting $waitCount');
                      await Future.delayed(const Duration(seconds: 1));
                    }
                    
                    setState(() {
                      errorText = 'Verification was successful';
                    });

                    await Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(fossil: fossil))
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFF211C4E))
                      ),
                      backgroundColor: Colors.white,
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
          ),
          const SizedBox(height: 5.0),
          Text(errorText, style: const TextStyle(color: Colors.red))
        ]
      ),
        ],
      )
    );
  }

}