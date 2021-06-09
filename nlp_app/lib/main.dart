import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  var channel = IOWebSocketChannel.connect('ws://192.168.1.8:6789');
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NLP Text App")
      ),
      body: Container(
        child: Column(
          children:[
            Padding(
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
                          if(snapshot.data != null)
                            return Text(snapshot.data.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 25));
                          return Text("Waiting for sms...", textAlign: TextAlign.center, style: TextStyle(fontSize: 25));
                        }
                    )
                )
            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                _testWebSocketServer(channel);
              },
            )
          ]
        )
      )
    );
  }
  @override
  void dispose(){
    channel.sink.close();
    super.dispose();
  }
}

Future _requestPermissions(BuildContext context)async{
  await Permission.sms.request();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) =>
      MainPage()));
}

void _testWebSocketServer(WebSocketChannel channel){
  try{
    channel.sink.add('Test');
    print('sent add');
  }
  catch(e){
    print(e);
  }
}