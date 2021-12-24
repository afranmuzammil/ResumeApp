import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personaldetailsapp/main.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
void loadingScreen()async{
  await main();
  Navigator.pushReplacementNamed(context, 'Home');
}
@override
void initState(){
  super.initState();
  loadingScreen();
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:  Colors.white,
      body:  SafeArea(
          child: Center(
            child:
            SpinKitCircle(
              color: Colors.black54,
              size: 80.0,
            ),
          )),
    );
  }
}





