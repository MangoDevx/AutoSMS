import "dart:async";
import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

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
        ),
      )
    );
  }
}

class MainPage extends StatefulWidget{
  final displayText;
  MainPage(this.displayText);
  @override
  MainPageState createState() => MainPageState(displayText);
}

class MainPageState extends State<MainPage>{
  final displayText;
  MainPageState(this.displayText);
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
            bottom: 60
          ),
          child: Text.rich(
            TextSpan(
              text: displayText,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)
            )
          ),
        )
      )
    );
  }
}

Future requestPermissions(BuildContext context)async{
  var isDenied = await Permission.sms.request().isDenied;
  if(isDenied)
    Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        MainPage("Permissions must be enabled to use this app.")));
  else
    Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        MainPage("Waiting for a sms message...")));
}