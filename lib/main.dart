import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personaldetailsapp/pages/form.dart';
import 'package:personaldetailsapp/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Model/data.dart';
 late Box box;
Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(DataAdapter());
    box = await Hive.openBox<Data>("Details");
    await Firebase.initializeApp();
  runApp(
    //MyApp()
     MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
           primaryColor: Color(0xff048cbc),
           secondaryHeaderColor: Color(0xffe7f2f7),
           // primaryColorBrightness: ,
           // primaryColorDark: ,
           // primaryColorLight: ,
           // primaryTextTheme: ,
           backgroundColor: Colors.white,
           // buttonColor: ,
           // appBarTheme: ,
           scrollbarTheme: ScrollbarThemeData(
             thumbColor:MaterialStateProperty.all(Colors.black26),
             // trackColor:MaterialStateProperty.all(Colors.black26),
           )
       ),
       initialRoute: '/',
       routes: {
         '/':(context) => const Home(),
          //'/Form':(context) => const Forms(),
         // '/home':(context)=>MyHomePage(),
         // '/form':(context) => Forms(),
       },
    )
  );
}
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner:false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'personal details '),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//           //mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: ()=>{},
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
