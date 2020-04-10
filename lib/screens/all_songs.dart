import 'package:echo/screens/favourites_screen.dart';
import 'package:echo/screens/splash_screen.dart';
import 'package:echo/widgets/bottom_player.dart';
import 'package:echo/widgets/songs_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';

class AllSongs extends StatefulWidget {
  static bool shuffle = false;
  static bool loop = false;
  static bool repeatone = false;
  static const route = 'all songs';
  static SongInfo currentSong;
  static AudioPlayer audioPlayer = AudioPlayer();
  static bool isPlaying = false;
  static SongInfo prev;
  static int currIndex = -1;
  static Duration currentDuration = Duration(milliseconds: 0);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  void getAllSongs() {
    FlutterAudioQuery().getSongs().then((onValue) {
      setState(() {
        SplashScreen.allSongs = onValue;
      });
    });
  }

  void _playSong(SongInfo _song, int index) async {
    AllSongs.prev = AllSongs.currentSong;
    if (AllSongs.prev == null) AllSongs.prev = SplashScreen.allSongs[0];
    int result = await AllSongs.audioPlayer.play(_song.filePath, isLocal: true);
    if (result == 1) {
      AllSongs.currIndex = index;
      setState(() {
        AllSongs.currentSong = _song;
        AllSongs.isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getAllSongs();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(FavouritesScreen.route);
              }),
          IconButton(
              tooltip: 'Refresh',
              icon: Icon(Icons.refresh),
              onPressed: () {
                getAllSongs();
              })
        ],
        title: Text('ECHO'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: SongsList(_playSong)),
          BottomPlayer(AllSongs.currentSong,_playSong),
        ],
      ),
    );
  }
}
