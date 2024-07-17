import 'package:internship/Widget/musicplayer.dart';
import 'package:internship/back-end/spotify_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class MusicSearch extends StatefulWidget {
  const MusicSearch({super.key});

  @override
  MusicSearchState createState() => MusicSearchState();
}



class MusicSearchState extends State<MusicSearch> {
  final List<Map<String, dynamic>> searchlistofsongs = [];

  void addtolist(String title, String singer, String photourl, String duration,
      Uri songurl) {
    Map<String, dynamic> songlist = {
      'title': title,
      'singer': singer,
      'photourl': photourl,
      'duration': duration,
      'songurl': songurl
    };
    searchlistofsongs.add(songlist);
  }
  List<VideoId> videoIds=[];

  final TextEditingController _searchname = TextEditingController();

Future<void> playmusic(int i) async {
   final yt = YoutubeExplode();
  final videoId = videoIds.elementAt(i);
        totalTime=searchlistofsongs.elementAt(i)['duration'];
      songName= searchlistofsongs.elementAt(i)['title']!;
     artistName= searchlistofsongs.elementAt(i)['singer']!;
   var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.first.url;
      player.setSource(UrlSource(audioUrl.toString()));
      
     setState(() {
       
     });

}

  Future<void> search() async {
    final yt = YoutubeExplode();
    final videoList = (await yt.search
        .search("${_searchname.text} song", filter: SortFilters.relevance));
    for (int i = 0; i < videoList.toList().length; i++) {
      if (i > 10) break;
      final video = videoList.elementAt(i);
      final videoId = video.id;
      videoIds.add(videoId);
      final songname = video.title;
      final songduration = video.duration;
      final thumbnail = video.thumbnails.highResUrl;
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.first.url;
      final authorname = video.author;
      addtolist(songname, authorname, thumbnail, songduration.toString(),
          audioUrl);
      setState(() {});
    }
  }
String formatDurationString(String durationString) {
    // Split the input string into parts based on the colon and period
    List<String> parts = durationString.split(':');

    // Extract minutes and seconds parts
    int minutes = int.parse(parts[1]);
    double secondsFraction = double.parse(parts[2]);

    // Extract the whole seconds from the seconds fraction
    int seconds = secondsFraction.floor();

    // Format the minutes and seconds to the desired string format
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutesFormatted = minutes.toString();
    final secondsFormatted = twoDigits(seconds);

    return '$minutesFormatted:$secondsFormatted';
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.white,
                  controller: _searchname,
                  decoration: const InputDecoration(
                    hintText: 'Search songs...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: search,
                child: const Icon(Icons.search_rounded),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchlistofsongs.length,
              
              itemBuilder: (context, i) {
                return ListTile(
                  onTap: () {
                    print("object");
                    setState(() {
                      playmusic(i);
                      Navigator.pop(context);
                    });
                    setState(() {
                      
                    });
                  },
                  leading: listimage(searchlistofsongs.elementAt(i)['photourl']!),
                  title: Text(searchlistofsongs.elementAt(i)['title']!, overflow: TextOverflow.ellipsis,
                    maxLines: 1,),
                  subtitle: Text(searchlistofsongs.elementAt(i)['singer']!),
                  trailing: Text(formatDurationString(searchlistofsongs.elementAt(i)['duration']!)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
