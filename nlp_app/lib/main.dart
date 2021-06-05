import "dart:async";
import "package:flutter/material.dart";
import 'package:nlp_app/fetchSms.dart';
import "package:permission_handler/permission_handler.dart";
String _displayText = "placeholder";

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
      home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget{
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 3), ()async => {
      requestPermissions(context)
    });
  }
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.orange,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('resources/mango.png')
          )
        )
      )
    );
  }
}

class MainPage extends StatefulWidget{
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage>{
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NLP Text App")
      ),
      body:
      Center(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 60
                ),
                child: Text.rich(
                    TextSpan(
                        text: _displayText,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)
                    )
                ),
              ),
              StreamBuilder<String>(
                stream: ,
              )
            ]
          )
        )
      )
    );
  }
}

Future requestPermissions(BuildContext context)async{
  await Permission.sms.request();
  if(await Permission.sms.isDenied)
    _displayText = "Permissions must be enabled to use this app.";
  else
    _displayText = "Waiting for a sms message...";
  Navigator.push(
      context, MaterialPageRoute(builder: (context) =>
      MainPage()));
}