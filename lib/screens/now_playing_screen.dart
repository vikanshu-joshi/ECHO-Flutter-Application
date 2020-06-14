import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:echo/model/data.dart';
import 'package:echo/model/model.dart';
import 'package:echo/screens/all_songs.dart';
import 'package:echo/screens/splash_screen.dart';
import 'package:echo/widgets/bottom_sheet_allsongs.dart';
import 'package:flutter/material.dart';
import 'package:seekbar/seekbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NowPlayingScreen extends StatefulWidget {
  static const route = 'now playing';
  final _random = Random();
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  void showBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BottomSheetAllSongs(AllSongs.currentSong);
        });
  }

  void playPause() async {
    if (AllSongs.audioPlayer.state == AudioPlayerState.PLAYING) {
      int result = await AllSongs.audioPlayer.pause();
      if (result == 1) {
        setState(() {
          AllSongs.isPlaying = false;
        });
      }
    } else {
      if (AllSongs.currentSong != null) {
        int result = await AllSongs.audioPlayer.resume();
        if (result == 1) {
          setState(() {
            AllSongs.isPlaying = true;
          });
        }
      }
    }
  }

  void playNext() async {
    AllSongs.prev = AllSongs.currentSong;
    if (AllSongs.shuffle) {
      int min = 0;
      int max = SplashScreen.allSongs.length - 1;
      int x = min + widget._random.nextInt(max - min);
      int result = await AllSongs.audioPlayer
          .play(SplashScreen.allSongs[x].filePath, isLocal: true);
      if (result == 1) {
        AllSongs.currIndex = x;
        setState(() {
          AllSongs.currentSong = SplashScreen.allSongs[x];
          AllSongs.isPlaying = true;
        });
      }
    } else if (AllSongs.repeatone) {
      if (AllSongs.currentSong != null) {
        AllSongs.audioPlayer.stop();
        AllSongs.audioPlayer.play(AllSongs.currentSong.filePath, isLocal: true);
      }
    } else {
      int result = await AllSongs.audioPlayer.play(
          SplashScreen.allSongs[AllSongs.currIndex + 1].filePath,
          isLocal: true);
      if (result == 1) {
        AllSongs.currIndex++;
        setState(() {
          AllSongs.currentSong = SplashScreen.allSongs[AllSongs.currIndex];
          AllSongs.isPlaying = true;
        });
      }
    }
  }

  void playPrev() async {
    if (AllSongs.prev == null) AllSongs.prev = SplashScreen.allSongs[0];
    if (AllSongs.repeatone) {
      AllSongs.audioPlayer.seek(Duration(milliseconds: 0));
    } else if (AllSongs.shuffle) {
      int result = await AllSongs.audioPlayer
          .play(AllSongs.prev.filePath, isLocal: true);
      if (result == 1) {
        setState(() {
          AllSongs.currentSong = AllSongs.prev;
          AllSongs.isPlaying = true;
        });
      }
    } else {
      AllSongs.currIndex--;
      if (AllSongs.currIndex < 0) AllSongs.currIndex = 0;
      int result = await AllSongs.audioPlayer.play(
          SplashScreen.allSongs[AllSongs.currIndex].filePath,
          isLocal: true);
      if (result == 1) {
        setState(() {
          AllSongs.currentSong = SplashScreen.allSongs[AllSongs.currIndex];
          AllSongs.isPlaying = true;
        });
      }
    }
  }

  void shuffleToggle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      AllSongs.shuffle = !AllSongs.shuffle;
      if (AllSongs.shuffle) AllSongs.repeatone = false;
    });
    prefs.setBool('shuffle', AllSongs.shuffle);
    prefs.setBool('repeat', AllSongs.repeatone);
  }

  void loopToggle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!AllSongs.repeatone && !AllSongs.loop) {
      setState(() {
        AllSongs.loop = true;
      });
    } else if (!AllSongs.repeatone && AllSongs.loop) {
      setState(() {
        AllSongs.loop = false;
        AllSongs.repeatone = true;
        AllSongs.shuffle = false;
      });
    } else if (AllSongs.repeatone && !AllSongs.loop) {
      setState(() {
        AllSongs.repeatone = false;
        AllSongs.loop = false;
      });
    }
    prefs.setBool('shuffle', AllSongs.shuffle);
    prefs.setBool('repeat', AllSongs.repeatone);
    prefs.setBool('loop', AllSongs.loop);
  }

  String _printDuration(Duration duration) {
    if (duration != null) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      if (duration.inMinutes < 60) return "$twoDigitMinutes:$twoDigitSeconds";
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "00:00";
  }

  @override
  Widget build(BuildContext context) {
    var _song = AllSongs.currentSong == null ? null : AllSongs.currentSong;
    var _fav = _song == null
        ? null
        : SongModel(
            _song.id,
            _song.title,
            _song.filePath,
            _song.artist,
            _song.album,
            _song.duration,
            _song.composer,
            _song.fileSize,
            _song.year);
    bool isFavourite = false;
    if (_song != null) {
      for (var item in favouritesList) {
        if (item.id == _fav.id) isFavourite = true;
      }
    }
    AllSongs.audioPlayer.onAudioPositionChanged.listen((onData) {
      setState(() {
        AllSongs.currentDuration = onData;
      });
    });
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('Now Playing'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color:
                    isFavourite ? Theme.of(context).accentColor : Colors.white,
              ),
              onPressed: () {
                if (_song != null) {
                  if (isFavourite) {
                    favouritesList.removeWhere((test) {
                      return test.id == _fav.id;
                    });
                    setState(() {
                      isFavourite = false;
                    });
                  } else {
                    favouritesList.add(_fav);
                    setState(() {
                      isFavourite = true;
                    });
                  }
                }
              }),
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                if (AllSongs.currentSong != null) showBottomModalSheet(context);
              })
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                AllSongs.currentSong == null
                    ? 'Now Playing'
                    : AllSongs.currentSong.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Image.asset(
                    'assets/images/disc.png',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Image.asset(
                      'assets/images/holder.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                )
              ],
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SeekBar(
                      value: AllSongs.currentSong == null
                          ? 0.5
                          : AllSongs.currentDuration.inSeconds /
                              (int.parse(AllSongs.currentSong.duration) *
                                  0.001),
                      barColor: Colors.white,
                      progressColor: Colors.amber,
                      onProgressChanged: (progress) {
                        setState(() {
                          AllSongs.currentDuration = Duration(
                              milliseconds: int.parse(((int.parse(
                                          progress.toString()) *
                                      (int.parse(
                                              AllSongs.currentSong.duration) *
                                          0.001))
                                  .toString())));
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AllSongs.currentDuration == null
                              ? '00:00'
                              : _printDuration(AllSongs.currentDuration),
                          style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AllSongs.currentSong == null
                              ? '00:00'
                              : _printDuration(Duration(
                                  milliseconds: int.parse(
                                      AllSongs.currentSong.duration))),
                          style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.shuffle,
                          color: AllSongs.shuffle
                              ? Theme.of(context).primaryColorDark
                              : Colors.white),
                      onPressed: shuffleToggle),
                  IconButton(
                      iconSize: 50,
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                      onPressed: playPrev),
                  IconButton(
                      iconSize: 80,
                      icon: Icon(
                        AllSongs.isPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        color: Colors.white,
                      ),
                      onPressed: playPause),
                  IconButton(
                      iconSize: 50,
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.white,
                      ),
                      onPressed: playNext),
                  IconButton(
                      icon: Icon(
                        AllSongs.repeatone ? Icons.repeat_one : Icons.repeat,
                        color: (AllSongs.repeatone || AllSongs.loop)
                            ? Theme.of(context).primaryColorDark
                            : Colors.white,
                      ),
                      onPressed: loopToggle),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
