import 'package:internship/Widget/musicplayer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CustomString {
  static const String clientId = '8679dbf3d7ee4d48b0d638ca597d3a22';
  static const String clientSecret = 'd2d0b52c47ac4b828ef1460109400fa6';
  static const String redirectUri =
      'https://helloindia.pythonanywhere.com/app/';
}

final player = AudioPlayer();
String searchartistName = "Loading...";
bool isPlaying = false;
String searchsongName = 'Loading...';
Duration searchtotalTime = const Duration(minutes: 4);

String songimageurl =
    'https://2.bp.blogspot.com/-Nc9YO_-F8yI/TcSIAB-nR-I/AAAAAAAAAGI/hPkuxqkqVcU/s1600/music-clipartMUSIC1.jpg';

Future<void> gettingsong(dynamic spotify, String playmusicTrackId) async {
  await spotify.tracks.get(playmusicTrackId).then((track) async {
    songName = track.name!;
    // isFav = searchByTitle(songName);
    artistName = track.artists!.first.name.toString();
    if (searchsongName != Null) {
      try {
        songimageurl = track.album!.images!.first.url.toString();
      } catch (e) {
        debugPrint(e.toString());
      }

      final yt = YoutubeExplode();
      final video = (await yt.search.search(searchsongName)).first;
      final videoId = video.id.value;
      searchtotalTime = video.duration!;
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.first.url;
      player.setSource(UrlSource(audioUrl.toString()));
    }
  });
  
}
