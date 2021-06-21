import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
final channel = IOWebSocketChannel.connect('ws://192.168.1.8:6789');

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
                        stream: channel.stream,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Text("Waiting for sms...", textAlign: TextAlign.center, style: TextStyle(fontSize: 25));
                          }
                          return Text(snapshot.hasData ? '${snapshot.data}' : 'No data returned yet', textAlign: TextAlign.center, style: TextStyle(fontSize: 25) );
                        }
                    )
                )
            )
        )
    );
  }
  @override
  void dispose(){
    channel.sink.close();
    print('Sink closed');
    super.dispose();
  }
}

Future _requestPermissions(BuildContext context)async{
  await Permission.sms.request();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) =>
      MainPage()));
}

Future _getSmsData()async{

}