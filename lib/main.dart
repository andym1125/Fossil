import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

        home: Scaffold(

            appBar: AppBar(
                backgroundColor: const Color(0xFF211C4E),
                elevation: 0,

                actions: const [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('🦮', style: TextStyle(fontSize: 30.0))
                  )
                ]
            ),

            body: Center(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    const Text(
                        'Fossil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8F87EC),
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          height: 0,
                        )
                    ),

                    const SizedBox(height: 150.0),
                    // Log in button
                    SizedBox(
                      height: 48.0,
                      width: 295.0,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPageState())
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Log in',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              height: 0,
                            ),
                          )
                      ),
                    ),

                    const SizedBox(height: 44.0),
                    // Sign Up button
                    SizedBox(
                        height: 48.0,
                        width: 295.0,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignupPageState())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text('Sign Up',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                height: 0,
                              ),
                            )
                        )
                    )
                  ],
                )
            ),
            backgroundColor: const Color(0xFF211C4E)
        )
    );
  }
}