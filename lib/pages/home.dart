import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personaldetailsapp/Model/data.dart';
import 'package:personaldetailsapp/pages/Detalis.dart';
import 'package:personaldetailsapp/pages/form.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

  bool gridView = true;

  toggleSwitch() {
    if (gridView == true) {
      return const Icon(
        Icons.grid_view_outlined,
        color: Color(0xff54b4d4),
      );
    } else if (gridView == false) {
      return const Icon(
        Icons.format_list_bulleted,
        color: Color(0xff54b4d4),
      );

    }
  }

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
      body: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          // InkWell(
          //   onTap: (){
          //     print(gridView);
          //     setState(() {
          //     if(gridView == true){gridView == false;}
          //     else if(gridView == false){ gridView ==true;}
          //   });},
          //   child: toggleSwitch(),
          // ),
           Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection("Personal Details")
                  .snapshots(),
                builder: (BuildContext context,  AsyncSnapshot<QuerySnapshot>  snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                      //  valueColor: animation,
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    print("e :${snapshot.error}");
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          //Text('Error: '),
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Error: '),
                          )
                        ],
                      ),
                    );
                  }else if(gridView){
                  return GridView.count(
                      crossAxisCount: 2,
                    children: snapshot.data!.docs.map((document){
                        return Card(
                          child: InkWell(
                            hoverColor: Colors.red,
                            splashColor: Colors.red,
                            onTap: (){
                              Data datas = box.get("23456");
                              print("my name is ${datas.firstName} ${document.id}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  Details(docID: document.id),
                                  ));
                            },
                            onLongPress: ()async{
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          //checkForAd(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Do u Want to Delete this Post',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text('Once Deleted cant be Undone!'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () async {
                                          try {
                                            await firebase_storage
                                                .FirebaseStorage.instance
                                                .refFromURL(
                                                document["ImageUrl"])
                                                .delete()
                                                .then((_) => print(
                                                "File deleted successfully"));
                                            await firebase_storage
                                                .FirebaseStorage.instance
                                                .refFromURL(
                                                document["ResumeUrl"])
                                                .delete()
                                                .then((_) => print(
                                                "File deleted successfully"));
                                            FirebaseFirestore.instance
                                                .collection("Personal Details")
                                                .doc(document.id)
                                                .delete();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Could not Delete try again"),
                                              ),
                                            );
                                          }
                                          Navigator.of(context).pop();
                                          print("deleted");
                                        },
                                        // style: TextButton.styleFrom(
                                        //   primary: Colors.white,
                                        //   backgroundColor: Colors.redAccent,
                                        // ),
                                      ),
                                      TextButton(
                                        child: const Text('No!'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          print("not Deleted");
                                        },
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child:Column(
                              children:  [
                                CircleAvatar(backgroundImage: NetworkImage(document['ImageUrl']),),
                                Text(document['FirstName']),
                              ],
                            ),
                          ),

                          color: Colors.blue,
                        );
                    }).toList() ,
                  );
                  }else {
                    return ListView(
                      scrollDirection:Axis.vertical,
                      // padding: const EdgeInsets.all(8),
                      children: snapshot.data!.docs.map((document){
                        return Card(
                          child: ListTile(
                            leading:  CircleAvatar(backgroundImage: NetworkImage(document['ImageUrl']),),
                            //trailing: Icon(Icons.more_vert),
                            title:  Text(document['FirstName']),
                            onTap:(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  Details(docID: document.id),
                                ));},
                            onLongPress: ()async{
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          //checkForAd(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Do u Want to Delete this Post',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text('Once Deleted cant be Undone!'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () async {
                                          try {
                                            await firebase_storage
                                                .FirebaseStorage.instance
                                                .refFromURL(
                                                document["ImageUrl"])
                                                .delete()
                                                .then((_) => print(
                                                "File deleted successfully"));
                                            await firebase_storage
                                                .FirebaseStorage.instance
                                                .refFromURL(
                                                document["ResumeUrl"])
                                                .delete()
                                                .then((_) => print(
                                                "File deleted successfully"));
                                            FirebaseFirestore.instance
                                                .collection("Personal Details")
                                                .doc(document.id)
                                                .delete();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Could not Delete try again"),
                                              ),
                                            );
                                          }
                                          Navigator.of(context).pop();
                                          print("deleted");
                                        },
                                        // style: TextButton.styleFrom(
                                        //   primary: Colors.white,
                                        //   backgroundColor: Colors.redAccent,
                                        // ),
                                      ),
                                      TextButton(
                                        child: const Text('No!'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          print("not Deleted");
                                        },
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          elevation: 10.0,
                        );
                      }).toList(),
                    );
                  }
                }
              ),
            ),
          ),

        ],
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
