import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Desktop(title: 'flutter-app'),
    );
  }
}

class Desktop extends StatefulWidget {
  const Desktop({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  int _counter = 0;

  MethodChannel channel = MethodChannel("App");
  String message = "Null";
  Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  Color foregroundColor = Color.fromRGBO(0,0,0,1);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    channel.setMethodCallHandler((call){
      print("Flutter收到消息:method=${call.method},arguments=${call.arguments}");
      message = call.method;

      if(call.method == "updateAppearance"){
        if (call.arguments is Map) {
          print("isMap");
          List _bs = call.arguments['backgroundColor'];
          List _fs = call.arguments['foregroundColor'];
          backgroundColor = Color.fromRGBO(_bs[0], _bs[1], _bs[2], 1);
          foregroundColor = Color.fromRGBO(_fs[0], _fs[1], _fs[2], 1);
          print("_bs=${_bs};_fs=${_fs};_b=${backgroundColor};_f=${foregroundColor}");
        }
      }

      setState(() {
      });

      channel.invokeMethod("${call.method}-reply");

      return Future((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(

        color: backgroundColor,
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(message, style: TextStyle(color: foregroundColor, fontSize: 30)),
            Text('Presed times:$_counter', style: TextStyle(color: foregroundColor, fontSize: 17)),
            GestureDetector(
              onTapUp: (detail){
                channel.invokeMethod("exit");
              },
              child: Text("退出", style: TextStyle(color: foregroundColor, fontSize: 17),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
