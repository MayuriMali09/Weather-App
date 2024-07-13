import 'package:flutter/material.dart';
import 'Weather_Screen.dart';
import 'dart:io';//for certificate only

class MyHttpOverrides extends HttpOverrides{//to solve certificate verify failed error
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
        ..badCertificateCallback=(X509Certificate cert,String host,int port)=>true;
  }
}
void main() {
  HttpOverrides.global=MyHttpOverrides();//for certificate only
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//it will remove the debug tag on our app
      theme: ThemeData.fallback(useMaterial3: true),
      //theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}

