import "package:flutter/material.dart";

void main()async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "NLP Text App",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.greenAccent,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange
        )
      ),
      home: AppHome()
    );
  }
}

class MyAppDeniedPerms extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
            child:
            Text("You need to have permissions enabled to use this app.")
        )
    );
  }
}

class AppHome extends StatefulWidget{
  @override
  MyHomePageState createState() => MyHomePageState();
}

class AppHomeDeniedPerms extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Text("Permissions need to be enabled for this application.");
  }
}

class MyHomePageState extends State<AppHome>{
  String text = "Waiting for a message...";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NLP Text App")
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 100
          ),
          child: Text.rich(
            TextSpan(
              text: text,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 25)
            )
          ),
        )
      )
    );
  }
}