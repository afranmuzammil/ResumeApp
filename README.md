# ResumeApp Project

This App was created as a assinment from Onivart Design Studio

* For Mobile: https://github.com/afranmuzammil/ResumeApp

## Description

A ResumeApp project created using flutter framework and dart lang. ResumeApp supports android only, as this was a task i was given basic requirements , I use it as a base and created the whole App.

**Requirements are mention below as given to me:**
* Create Application Collect Personal Data:
 Fill Form, name list, and detail about personal(First Name, Last Name, Mobile, Gender, Address, Image of the User it may be from Camera or from the gallery and finally his  resume).
 * There should be an empty screen(home page) and have a “+” at end of the screen.
 * On Tap we should have a form that taking the personal information of a user (First Name, Last Name, Mobile, Gender, Address, image, and finally resume).
 * The image of the User may be from the Camera or from the gallery both options should be shown on taping on Add Photo in a circle avatar. “The Image should store in Firebase    storage but the Image URL should be saved in the HIVE local database”
 * The resume should save in Firebase storage but the URL should be saved in the HIVE local database.
 * The Form should be validated.
 * On Adding the personal details to the HIVE LOCAL DATABASE with the user personal details including user image URL and resume URL.
 * I should see the list of Users on the home page with his profile Avatar.
 * On Tap on that, I can able to see his user details and can able to download his resume.
 * long press on the user tail the user should as permission to delete the record from HIVE DATABASE.
* Automatically the profile avatar and resume doc both should also delete from the Fire Store. 


## Getting Started

The ResumeApp contains the minimal implementation required to create a new library or project. The repository code is preloaded with some basic components like basic app architecture, app theme, constants and required dependencies to create a new project. By using boiler plate code as standard initializer, we can have same patterns in all the projects that will inherit it. This will also help in reducing setup & development time by allowing you to use same code pattern and avoid re-writing from scratch.

## How to Use 

**Step 1:**

Download or clone this repo by using the link below:

```
* https://github.com/afranmuzammil/ResumeApp
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

## ResumeApp Features:


* Home
* Routing
* Theme
* Dio
* Firebase Database
* Provider (State Management)
* Validation
* Code Generation
* File Upload & download
* Imgae Upload & display




### Libraries & Tools Used

  * google_fonts: ^2.0.0
  * image_picker: ^0.8.2
  * url_launcher: ^6.0.2
  * firebase_storage: ^10.0.1
  * cloud_firestore: ^2.4.0
  * firebase_core: ^1.0.1
  * file_picker: ^3.0.1
  * hive: ^2.0.3
  * hive_flutter: ^1.0.0
  * dio: ^4.0.0
  * path_provider: ^2.0.5
  * open_file: ^3.2.1
  * flutter_spinkit: ^5.0.0
  * provider: ^5.0.0



### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
   |- data.dart/
   |- data.g.dart/

   |- Details.dart/
   |- form.dart/
   |- home.dart/
   |- loadingPage.dart/
   |- main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- Model - This is a directary
2- data -Here the class for HIVE storage is created.
3- data.g -this was created my HIVE as an adopter 
4- Details — IN this page we have UI which will display all the details of the person you wanted to look into here you look at there photo make a call and see there resume.
5- From — Here you fill the from upload a image and resume to firebase.
6- Home — Home page you can see the data displayed in the from of grid you can see there name and phono and when you click on the tile you will be taken to Details page.
7- Loading.dart — a Loading page.
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```


### Data

All the business logic of your application will go into this directory, it represents the data layer of your application. It is sub-divided into three directories `local`, `network` and `sharedperf`, each containing the domain specific logic. Since each layer exists independently, that makes it easier to unit test. The communication between UI and data layer is handled by using central repository.

```
lib/
|- Model/
   |- data.dart/
   |- data.g.dart/
|- pages/
   |- Details.dart/
   |- form.dart/
   |- home.dart/
   |- loadingPage.dart/
|- main.dart

```

### Main

This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
           backgroundColor: Colors.white,
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

```



## Conclusion

I will be happy to answer any questions that you may have on this approach, and if you want to lend a hand with the ResumeApp then please feel free to submit an issue and/or pull request 🙂


Shaik Muzammil Ahmed [Gmail](shaikmuzammilahmed94@gmail.com)
