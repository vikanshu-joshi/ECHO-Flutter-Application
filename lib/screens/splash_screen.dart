import 'package:echo/screens/all_songs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class SplashScreen extends StatelessWidget {
  static const route = 'splash';
  static List<SongInfo> allSongs = [];
  void getPermission(BuildContext context) {
    PermissionsPlugin.requestPermissions([
      Permission.READ_EXTERNAL_STORAGE,
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.READ_PHONE_STATE,
      Permission.PROCESS_OUTGOING_CALLS,
    ]).then((onValue) {
      Future.delayed(Duration(seconds: 3),(){
        Navigator.of(context).pushReplacementNamed(AllSongs.route);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    getPermission(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColorDark
            ])),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ECHO',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Music Player',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
