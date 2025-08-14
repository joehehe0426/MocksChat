import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WhatsApp",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: "Helvetica Neue",
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          bodyMedium: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          titleLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
          titleMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          labelMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ),
      home: Homescreen(
        chatmodels: [],
        sourchat: ChatModel(
          name: "Me",
          isGroup: false,
          currentMessage: "Hello",
          time: "12:00",
          icon: "person.svg",
          id: 0,
          status: "Online",
          profileImage: "assets/profile_pictures/balram.jpg",
        ),
      ),
    );
  }
}
