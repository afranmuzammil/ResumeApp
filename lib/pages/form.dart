
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personaldetailsapp/Model/data.dart';
import 'package:personaldetailsapp/main.dart';

class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  final ScrollController _controllerOne = ScrollController();
  final formKey = GlobalKey<FormState>();
  firebase_storage.Reference ?ref;

  @override
  void dispose(){
    Hive.box("Details").close();

    super.dispose();
  }

  File ?userImage;//imageFile
  final picker = ImagePicker();
//gets image from the gallery
  Future getImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 65,
    );
    setState(() {
      userImage = File(image!.path);
    });
  }
  //gets image from the camera
  Future getImageCam() async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 65,
    );
    setState(() {
      userImage = File(image!.path);
    });
  }
//opens the BottomSheet to select camera or gallery
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        getImage();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImageCam();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  firebase_storage.UploadTask? task;
  File? file;
//selects the file from the phone storage
  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path!));
  }
  String ?fileurls ;
  //uploads the file to firebase
  Future uploadFile() async{
    if(file == null ) return;

    final fileName = (file!.path.split("/").last);
    final destination = 'files/$fileName';

   task = FirebaseApi.uploadFile(destination,file!);

   if(task == null) return;
   final snapshot = await task!.whenComplete(() {});
   final urlDownload = await snapshot.ref.getDownloadURL();
   fileurls = urlDownload;
   print("Donwload url $urlDownload");
  }

  String ?imageLink;
  var upTime;
//uploads the image to firebase
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = userImage!.path;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  const [
           Text("Image Uploading..."),
            CircularProgressIndicator(
              //valueColor: Colors.white,
              backgroundColor: Colors.white,
              semanticsLabel: 'Linear progress indicator',
            ),
          ],
        ),
      ),
    );
    print("hello");
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads/${userImage!.path}');

    await ref!.putFile(userImage!).whenComplete(() async {
      ref?.getDownloadURL().then((value) {
        imageLink = value;
      });
    });
    //print(upTime);
    return imageLink;
  }


  //controllers
  final FirstName = TextEditingController();
  final LastName =  TextEditingController();
  final Mobile =  TextEditingController();
  final Address =  TextEditingController();

  String ?GenderValue;
  List GenderList=[
    "Male",
    "Female",
    "Others"
  ];


  bool uploadVisible = false;
  bool isEnabled = true;

  List Gender = [];



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black54,),
        backgroundColor: Colors.white,
        title: Text('Form',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54))
          // style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
       // elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey ,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor:  Colors.black54,
                            child: userImage != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                userImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      //fistname
                      TextFormField(
                        cursorColor: Colors.black54,
                        controller: FirstName,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.black54,
                              style: BorderStyle.solid,
                              width: 2,
                            )),
                            hintText: 'First Name*',
                            prefixIcon: Icon(Icons.person,color: Colors.black54,)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the appropriate details';
                          }
                          // else if (value != realId) {
                          //   return "please enter the right pass word";
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      //lastname
                      TextFormField(
                        cursorColor: Colors.black54,
                        controller: LastName,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.black54,
                              style: BorderStyle.solid,
                              width: 2,
                            )),
                            hintText: 'Last Name*',
                            prefixIcon: Icon(Icons.person,color: Colors.black54,)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the appropriate details';
                          }
                          // else if (value != realId) {
                          //   return "please enter the right pass word";
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      //mobile
                      TextFormField(
                        cursorColor: Colors.black54,
                        controller: Mobile,
                        keyboardType: TextInputType.number,
                        keyboardAppearance: Brightness.light,
                        decoration:const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.black54,
                              style: BorderStyle.solid,
                              width: 2,
                            )),
                            hintText: 'Contact No*',
                            prefixIcon: Icon(Icons.phone,color: Colors.black54,)),
                        validator: (value) {
                          if (value == null ||value.isEmpty) {
                            return 'Please enter the appropriate details';
                          } else if (value.characters.length!=10||value.characters.length<10||value.characters.length>10) {
                            return "please enter 10 digit mobile number";
                          }
                          return null;
                        },
                      ),
                      //Gender
                      const SizedBox(
                        height: 10.0,
                      ),
                      //Gender
                      DropdownButton<String>(
                        hint:  Text(
                            "Gender",
                          style:  GoogleFonts.poppins(textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400,color: Colors.black54))
                        ),
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: GoogleFonts.poppins(textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400,color: Colors.black54)),
                        value: GenderValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            GenderValue = newValue!;
                          });
                        },
                        items: GenderList.map((valueItem) {
                          return DropdownMenuItem<String>(
                            value: valueItem,
                            child: Text(valueItem,textAlign: TextAlign.center),
                          );
                        }).toList(),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        cursorColor: Colors.black54,
                        controller: Address,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        //Normal textInputField will be displayed
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                            color: Colors.black54,
                            style: BorderStyle.solid,
                            width: 2,
                          )),
                          hintText: 'Address* ',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 10.0),
                          prefixIcon: Icon(Icons.add_location_outlined,color: Colors.black54,),
                        ),
                        scrollPadding:
                        const EdgeInsets.symmetric(vertical: 50.0),
                        validator: (value) {
                          if (value == null ||value.isEmpty) {
                            return 'Please enter the appropriate details';
                          }
                          // else if (value != realId) {
                          //   return "please enter the right pass word";
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      //resumeUpload
                      Column(
                        children: [
                          Center(
                            child: file == null
                                ?  Text(
                              "UPLOAD RESUME",
                              style:GoogleFonts
                                  .poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color: Colors
                                          .black54)),
                            )
                                :  Text(
                              "File Uploaded",
                              style: GoogleFonts
                                  .poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                      color: Colors
                                          .black54)),
                            ),
                          ),
                          Builder(
                            builder: (context) => TextButton.icon(
                              onPressed: () {
                                selectFile();
                              },
                              icon: const Icon(
                                Icons.attach_file_outlined,
                                color: Colors.black54,
                              ),
                              label:  Text(
                                "Upload file",
                                style:GoogleFonts
                                    .poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: Colors
                                            .black54)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                      //SubmitButton
                      Builder(
                        builder: (context) => TextButton(
                          // color: Theme.of(context).primaryColor,
                            style: TextButton.styleFrom(
                              primary: Colors.black26,
                              backgroundColor: Colors.black87,
                              onSurface: Colors.grey,
                            ),
                            onPressed:()async{
                              if(formKey.currentState!.validate()){

                                      await uploadImageToFirebase(context);//upload image
                                      await uploadFile();//upload file
                                      await Future.delayed(const Duration(seconds: 1));
                                      print("upload done : $imageLink");
                                      if(GenderValue!=null){
                                        if (imageLink != null&&fileurls!=null) {
                                          submitFunc();
                                          setState(() {
                                            uploadVisible = true;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text("Image Uploaded"),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Image Not upload try again"),
                                            ),
                                          );
                                        }
                                      }else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Select a gender"),
                                          ),
                                        );
                                      }

                                     // submitFunc();
                              }
                              else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please enter the appropriate details"),
                                  ),
                                );
                              }
                                },
                            child:  Center(
                                child: Text(
                                  'SUBMIT',
                                  style: GoogleFonts
                                      .poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 13.0,
                                          fontWeight:
                                          FontWeight
                                              .w700,
                                          color: Colors
                                              .white70)),
                                ))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ) ,
      ),
    );
  }

  submitFunc() {
    setState(() {
      try{
        //put the data in HIVE
        box.put(Mobile.text.toString(),Data(firstName: FirstName.text.toLowerCase().toString(),
            lastName: LastName.text.toLowerCase().toString(),
            gender: GenderValue.toString(),
            mobile: Mobile.text.toLowerCase().toString(),
            address: Address.text.toLowerCase().toString(),
            fileUrl: fileurls.toString(),
            imageUrl: imageLink.toString()));
        //put the data in fireBase
        Map<String, dynamic> data ={
          "FirstName":FirstName.text.toLowerCase().toString(),
          "LastName":LastName.text.toLowerCase().toString(),
          "Mobile":Mobile.text.toLowerCase().toString(),
          "Address":Address.text.toLowerCase().toString(),
          "Gender":GenderValue.toString(),
          "ImageUrl":imageLink,
          "ResumeUrl":fileurls,
        };
        FirebaseFirestore.instance
            .collection("Personal Details")
            .add(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("yay! Uploaded! Thank You:)"),
            action: SnackBarAction(
              label: "OK",
              onPressed: () {
                //Navigator.pop(context);
              },
            ),
          ),
        );
        Navigator.pop(context, {});
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                "we Could not upload ur data check ur internet and try again"),
            action: SnackBarAction(
              label: "OK",
              onPressed: () {},
            ),
          ),
        );
        print("problam here $e");
      }
    });

  }
}
//firebase Api to upload the file to fireStore
class FirebaseApi {
  static firebase_storage.UploadTask? uploadFile(String destination, File file){
    try{
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
  }on FirebaseException catch(e){
      return null;
  }
  }
}


