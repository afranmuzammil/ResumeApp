import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personaldetailsapp/pages/form.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title:Text('Personal Details',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70))
          // style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Center(

        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'done:',
            ),
            Text(
              '_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => const Forms(),
        ))
        },
        tooltip: 'Add data',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
