import 'package:audioplayers/audioplayers.dart';
import 'package:echo/screens/all_songs.dart';
import 'package:echo/screens/now_playing_screen.dart';
import 'package:echo/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class BottomPlayer extends StatelessWidget {
  final Function _playSong;
  final SongInfo _currentSong;
  BottomPlayer(this._currentSong,this._playSong);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    return Container(
      height: _mediaQuery.size.height * 0.10,
      color: Theme.of(context).primaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              padding: EdgeInsets.only(left: 10),
              icon: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(NowPlayingScreen.route);
              }),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                _currentSong == null
                    ? 'Now Playing'
                    : _currentSong.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15, top: 0, bottom: 5),
            child: IconButton(
                icon: Icon(
                  AllSongs.audioPlayer.state == AudioPlayerState.PLAYING
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                  size: _mediaQuery.size.width * 0.1,
                ),
                onPressed: () {
                  if(AllSongs.audioPlayer.state == AudioPlayerState.PLAYING){
                    AllSongs.audioPlayer.pause();
                    AllSongs.isPlaying = false;
                  }else{
                    if(_currentSong != null){
                      AllSongs.audioPlayer.resume();
                      AllSongs.isPlaying = true;
                    }else{
                      _playSong(SplashScreen.allSongs[0],0);
                    }
                  }
                }),
          )
        ],
      ),
    );
  }
}