
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  final ScrollController _controllerOne = ScrollController();
  final formKey = GlobalKey<FormState>();
  firebase_storage.Reference ?ref;

  File ?userImage;
  final picker = ImagePicker();

  Future getImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 65,
    );
    setState(() {
      userImage = File(image!.path);
    });
  }
  Future getImageCam() async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 65,
    );
    setState(() {
      userImage = File(image!.path);
    });
  }

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

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path!));
  }
  String ?fileurl ;
  Future uploadFile() async{
    if(file == null ) return;

    final fileName = (file!.path.split("/").last);
    final destination = 'files/$fileName';

   task = FirebaseApi.uploadFile(destination,file!);

   if(task == null) return;
   final snapshot = await task!.whenComplete(() {});
   final urlDownload = await snapshot.ref.getDownloadURL();
   fileurl = urlDownload;
   print("Donwload url $urlDownload");
  }

  String ?imageLink;
  var upTime;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = userImage!.path;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
           Text("Image Uploading..."),
            // CircularProgressIndicator(
            //   valueColor: Colors.white,
            //   backgroundColor: Colors.white,
            //   semanticsLabel: 'Linear progress indicator',
            // ),
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
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Form',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70))
          // style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey ,
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    //fistname
                    TextFormField(
                      controller: FirstName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                          hintText: 'First Name*',
                          prefixIcon: Icon(Icons.person)),
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
                    //lastname
                    TextFormField(
                      controller: LastName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                          hintText: 'Last Name*',
                          prefixIcon: Icon(Icons.person)),
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
                    //mobile
                    TextFormField(
                      controller: Mobile,
                      keyboardType: TextInputType.number,
                      keyboardAppearance: Brightness.light,
                      decoration:const InputDecoration(
                        //border: InputBorder.none,
                          hintText: 'Contact No*',
                          prefixIcon: Icon(Icons.phone)),
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
                    //Gender
                    const SizedBox(
                      height: 30.0,
                    ),
                    //Gender
                    DropdownButton<String>(
                      hint: const Text("Gender"),
                      dropdownColor: Theme.of(context).secondaryHeaderColor,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                      value: GenderValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          GenderValue = newValue!;
                        });
                      },
                      items: GenderList.map((valueItem) {
                        return DropdownMenuItem<String>(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                    //male
                    // CheckboxListTile(
                    //   secondary: const Icon(Icons.male_outlined),
                    //   title: const Text('Male'),
                    //   //subtitle: Text('Ringing after 12 hours'),
                    //   value: Male,
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       Male = value!;
                    //     });
                    //     if(Male==true){
                    //       Gender.add("Male");
                    //     }else if(value==false){
                    //       Gender.remove("Male");
                    //     }
                    //   },
                    //   // onChanged: (bool value) {
                    //   //   setState(() {
                    //   //     this.Male = value;
                    //   //   });
                    //   //   if (Male == true) {
                    //   //     typeOfInstitutionList.add("MADRSA");
                    //   //   } else if (valueMadrsa == false) {
                    //   //     typeOfInstitutionList.remove("MADRSA");
                    //   //   }
                    //   // },
                    // ),
                    // //female
                    // CheckboxListTile(
                    //   secondary: const Icon(Icons.female_outlined),
                    //   title: const Text('Female'),
                    //   //subtitle: Text('Ringing after 12 hours'),
                    //   value: Female,
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       Female = value!;
                    //     });
                    //     if(Female==true){
                    //       Gender.add("Female");
                    //     }else if(value==false){
                    //       Gender.remove("Female");
                    //     }
                    //   },
                    // ),
                    // //others
                    // CheckboxListTile(
                    //   secondary: const Icon(Icons.transgender_outlined),
                    //   title: const Text('Others'),
                    //   //subtitle: Text('Ringing after 12 hours'),
                    //   value: Others,
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       Others = value!;
                    //     });
                    //     if(Female==true){
                    //       Gender.add("Others");
                    //     }else if(value==false){
                    //       Gender.remove("Others");
                    //     }
                    //   },
                    // ),
                    //Address
                    TextFormField(
                      controller: Address,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      //Normal textInputField will be displayed
                      maxLines: 5,
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                        hintText: 'Address* ',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.add_location_outlined),
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
                    Column(
                      children: [
                        Center(
                          child: userImage == null
                              ? const Text(
                            "UPLOAD PLACE IMAGE",
                            style: TextStyle(
                                color: Colors.black54),
                          )
                              : Image.file(userImage!),
                        ),
                        Builder(
                          builder: (context) => TextButton.icon(
                            onPressed: () {
                              //getImage();
                              _showPicker(context);
                            },
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Add pic*",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: uploadVisible,
                            child: const Icon(
                              Icons.cloud_upload_rounded,
                              color: Colors.green,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    //upload Image button
                    // Builder(
                    //   builder: (context) => TextButton(
                    //     // color: Theme.of(context).primaryColor,
                    //     style: TextButton.styleFrom(
                    //       primary: Colors.black26,
                    //       backgroundColor:
                    //       Theme.of(context).primaryColor,
                    //       onSurface: Colors.blue,
                    //     ),
                    //     onPressed: () async {
                    //       await uploadImageToFirebase(context);
                    //       await Future.delayed(Duration(seconds: 1));
                    //       print("upload done : $imageLink");
                    //       if (imageLink != null) {
                    //         setState(() {
                    //           uploadVisible = true;
                    //         });
                    //         ScaffoldMessenger.of(context)
                    //             .showSnackBar(
                    //           SnackBar(
                    //             content: Text("Image Uploaded"),
                    //           ),
                    //         );
                    //       } else {
                    //         ScaffoldMessenger.of(context)
                    //             .showSnackBar(
                    //           SnackBar(
                    //             content: Text(
                    //                 "Image Not upload try again"),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //     child: Text('upload image',
                    //         style: TextStyle(color: Colors.white)),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    //resumeUpload
                    Column(
                      children: [
                        Center(
                          child: file == null
                              ? const Text(
                            "UPLOAD RESUME",
                            style: TextStyle(
                                color: Colors.black54),
                          )
                              : const Text("File Uploaded"),
                        ),
                        Builder(
                          builder: (context) => TextButton.icon(
                            onPressed: () {
                              selectFile();
                            },
                            icon: const Icon(
                              Icons.attach_file_outlined,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Upload file",
                              style: TextStyle(color: Colors.grey),
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
                            backgroundColor: Theme.of(context).primaryColor,
                            onSurface: Colors.grey,
                          ),
                          onPressed:()async{
                            if(formKey.currentState!.validate()){

                                    await uploadImageToFirebase(context);
                                    await uploadFile();
                                    await Future.delayed(const Duration(seconds: 1));
                                    print("upload done : $imageLink");
                                    if (imageLink != null) {
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
                          child: const Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white70),
                              ))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ) ,
      ),
    );
  }

  submitFunc() {
    setState(() {
      try{
        Map<String, dynamic> data ={
          "FirstName":FirstName.text.toLowerCase().toString(),
          "LastName":LastName.text.toLowerCase().toString(),
          "Mobile":Mobile.text.toLowerCase().toString(),
          "Address":Address.text.toLowerCase().toString(),
          "Gender":GenderValue.toString(),
          "ImageUrl":imageLink,
          "ResumeUrl":fileurl,
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


