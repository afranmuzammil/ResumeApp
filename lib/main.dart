import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personaldetailsapp/pages/form.dart';
import 'package:personaldetailsapp/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personaldetailsapp/pages/loadingPage.dart';
import 'package:provider/provider.dart';
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
          //'/Home':(context) => const Home(),

       },
    )
  );
}

