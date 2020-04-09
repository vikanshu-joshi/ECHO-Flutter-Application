import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class BottomSheetAllSongs extends StatelessWidget {
  final SongInfo song;
  BottomSheetAllSongs(this.song);

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inMinutes < 60) return "$twoDigitMinutes:$twoDigitSeconds";
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                title: Text(
              'Title : ${song.title}',
              style: TextStyle(fontFamily: 'ComicNeue'),
            )),
            ListTile(
                title: Text(
              'Artist : ${song.artist}',
              style: TextStyle(fontFamily: 'ComicNeue'),
            )),
            ListTile(
                title: Text('Album : ${song.album}',
                    style: TextStyle(fontFamily: 'ComicNeue'))),
            ListTile(
                title: Text('Composer : ${song.composer}',
                    style: TextStyle(fontFamily: 'ComicNeue'))),
            ListTile(
                title: Text(
                    'Size : ${(int.parse(song.fileSize) / (1024 * 1024)).toStringAsFixed(2)} MB',
                    style: TextStyle(fontFamily: 'ComicNeue'))),
            ListTile(
                title: Text(
                    'Duration : ${_printDuration(Duration(milliseconds: int.parse(song.duration)))}',
                    style: TextStyle(fontFamily: 'ComicNeue'))),
            ListTile(
                title: Text('Year : ${song.year}',
                    style: TextStyle(fontFamily: 'ComicNeue'))),
            ListTile(
                title: Text('Location : ${song.filePath}',
                    style: TextStyle(fontFamily: 'ComicNeue'))),
          ],
        ),
      ),
    );
  }
}
