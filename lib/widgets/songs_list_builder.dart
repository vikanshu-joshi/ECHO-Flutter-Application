import 'package:echo/screens/all_songs.dart';
import 'package:echo/screens/splash_screen.dart';
import 'package:echo/widgets/bottom_sheet_allsongs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongsList extends StatelessWidget {
  final Function _playSong;
  SongsList(this._playSong);
  void showBottomModalSheet(BuildContext context, SongInfo song) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BottomSheetAllSongs(song);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen.allSongs.isEmpty
        ? Center(
            child: Text(
              'No Songs',
              style: TextStyle(color: Colors.black),
            ),
          )
        : ListView.builder(
            itemCount: SplashScreen.allSongs.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  _playSong(SplashScreen.allSongs[index], index);
                },
                onLongPress: () {
                  showBottomModalSheet(context, SplashScreen.allSongs[index]);
                },
                splashColor: Theme.of(context).accentColor,
                child: ListTile(
                  title: Text(
                    SplashScreen.allSongs[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  subtitle: Text(
                    SplashScreen.allSongs[index].filePath,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'ComicNeue'),
                  ),
                  trailing: (AllSongs.currIndex == index)
                      ? Icon(
                          Icons.music_note,
                          color: Theme.of(context).accentColor,
                        )
                      : Text(''),
                ),
              );
            });
  }
}
