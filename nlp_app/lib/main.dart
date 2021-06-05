import "dart:async";
import "package:flutter/material.dart";
import 'package:nlp_app/fetchSms.dart';
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
      _requestPermissions(context)
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
  bool checkPerms = true;
  // TODO: Make stream work
  Stream<String> _fetchSms() async*{
    var sms = await _fetchSmsLoop(checkPerms);
    yield sms;
  }
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
      body: Container(
          child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 60,
              ),
              child: Center(
              child: StreamBuilder(
                  stream: _fetchSms(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Text("Waiting for sms...", textAlign: TextAlign.center, style: TextStyle(fontSize: 25));
                    }
                    if(snapshot.data != null)
                      return Text(snapshot.data.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 25));
                    return Text("Error, no data found.", textAlign: TextAlign.center, style: TextStyle(fontSize: 25));
                  }
                )
              )
          )
      )
    );
  }
}

Future _requestPermissions(BuildContext context)async{
  await Permission.sms.request();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) =>
      MainPage()));
}

Future<String> _fetchSmsLoop(bool checkPerms)async{
  if(checkPerms){
    var status = await Permission.sms.status;
    if(!status.isGranted)
      return "You need to allow SMS permissions for this app to work. Current permission settings: $status";
    checkPerms = true;
  }
  // TODO: "TODO: Make texts appear here, if not available send waiting message.
  return "TODO: Make texts appear here, if not available send waiting message.";
}