import 'package:echo/screens/all_songs.dart';
import 'package:echo/screens/favourites_screen.dart';
import 'package:echo/screens/now_playing_screen.dart';
import 'package:echo/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECHO',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 3, 42, 1),
        accentColor: Color.fromRGBO(255, 64, 129, 1),
        primaryColorDark: Color.fromRGBO(0, 4, 42, 1),
        fontFamily: 'Aclonica'
      ),
      home: SplashScreen(),
      routes: {
        SplashScreen.route: (ctx) => SplashScreen(),
        AllSongs.route: (ctx) => AllSongs(),
        NowPlayingScreen.route: (ctx) => NowPlayingScreen(),
        FavouritesScreen.route: (ctx) => FavouritesScreen()
      },
    );
  }
}
