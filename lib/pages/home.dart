import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personaldetailsapp/Model/data.dart';
import 'package:personaldetailsapp/pages/Detalis.dart';
import 'package:personaldetailsapp/pages/form.dart';

import '../main.dart';

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

        child: InkWell(
          hoverColor: Colors.red,
          splashColor: Colors.red,
          onTap: (){
            Data datas = box.get("23456");
            print("my name is ${datas.firstName} ${datas.imageUrl}");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Details(),
                ));
          },
          child: GridView.count(
            crossAxisCount: 2 ,
            children: List.generate(4,(index){
              return Card(
                child: Column(
                  children: const [
                    CircleAvatar(backgroundColor:Colors.lightGreen ,),
                    Text('Full Name'),

                  ],
                ),
                color: Colors.blue,
              );
            }),
          ),
        )

        // ListView(
        //   scrollDirection:Axis.vertical,
        //   padding: const EdgeInsets.all(8),
        //   children:  <Widget>[
        //     Card(
        //       child: ListTile(
        //         leading: const CircleAvatar(backgroundColor:Colors.lightGreen ,),
        //         //trailing: Icon(Icons.more_vert),
        //         title: const Text('Full Name'),
        //         onTap:(){},
        //         onLongPress: (){},
        //       ),
        //       elevation: 10.0,
        //     )
        //
        //   ],
        // ),
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
