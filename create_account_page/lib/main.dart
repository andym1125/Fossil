import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFfffff),
        elevation: 0,

          leading: CustomBackButton(),
        title: Text('Create Account',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)


      ),



      body:  Center(

        child: Column(
    mainAxisAlignment: MainAxisAlignment.center,

    children: <Widget>[

              SizedBox(height: 0.0),
    //username input textfield
    SizedBox(
    height: 70,
    width: 295.0,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Username',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),

    ),
    SizedBox(height: 44.0),
      //Email input textfield
    SizedBox(
    height: 70,
    width: 295.0,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),

    ),
      SizedBox(height: 44.0),
      //Password input textfield
      SizedBox(
        height: 70,
        width: 295.0,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

          ),
        ),

      ),
      SizedBox(height: 150.0),
      SizedBox(
          height: 50,
          width: 295.0,

      child:MaterialButton(
        elevation: 10,
          onPressed:() {},
          color: Colors.white,
        child: const Text('next',
          style: TextStyle(color:Colors.black,fontSize: 25,
            fontWeight: FontWeight.bold),),
          )
      )
          ]
      ),
      )// This trailing comma makes auto-formatting nicer for build methods.

    );



  }
}
class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back),

        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}