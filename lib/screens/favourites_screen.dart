import 'package:audioplayers/audioplayers.dart';
import 'package:echo/model/data.dart';
import 'package:echo/model/model.dart';
import 'package:echo/screens/all_songs.dart';
import 'package:echo/screens/now_playing_screen.dart';
import 'package:echo/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  static const route = 'favourites screen';
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  void _playSong(SongModel _song) async {
    int index = -1;
    index = SplashScreen.allSongs.indexWhere((test) {
      return test.id == _song.id;
    });
    if (index >= 0) {
      int result =
          await AllSongs.audioPlayer.play(_song.filePath, isLocal: true);
      if (result == 1) {
        setState(() {
          AllSongs.currIndex = index;
          AllSongs.currentSong = SplashScreen.allSongs[index];
          AllSongs.isPlaying = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: favouritesList.length == 0
                  ? Center(
                      child: Text('No Favourites'),
                    )
                  : ListView.builder(
                      itemCount: favouritesList.length,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          splashColor: Theme.of(context).accentColor,
                          onTap: () {
                            _playSong(favouritesList[index]);
                          },
                          child: Dismissible(
                            key: Key(favouritesList[index].id),
                            background: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'ComicNeue'),
                                      ),
                                      Text('from',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'ComicNeue')),
                                      Text('Favourites',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'ComicNeue'))
                                    ],
                                  )
                                ],
                              ),
                              color: Theme.of(context).accentColor,
                            ),
                            secondaryBackground: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'ComicNeue'),
                                      ),
                                      Text('from',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'ComicNeue')),
                                      Text('Favourites',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'ComicNeue'))
                                    ],
                                  )
                                ],
                              ),
                              color: Theme.of(context).accentColor,
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                favouritesList.removeAt(index);
                              });
                            },
                            child: ListTile(
                              title: Text(favouritesList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1)),
                              subtitle: Text(favouritesList[index].filePath,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1)),
                              trailing: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      })),
          Container(
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(NowPlayingScreen.route);
                      },
                      child: Text(
                        AllSongs.currentSong == null
                            ? 'Now Playing'
                            : AllSongs.currentSong.title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
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
                        if (AllSongs.audioPlayer.state ==
                            AudioPlayerState.PLAYING) {
                          AllSongs.audioPlayer.pause();
                          setState(() {
                            AllSongs.isPlaying = false;
                          });
                        } else {
                          if (AllSongs.currentSong != null) {
                            AllSongs.audioPlayer.resume();
                            setState(() {
                              AllSongs.isPlaying = true;
                            });
                          }
                        }
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
