import 'dart:async';
import 'dart:math'; // Import the dart:math package

import 'package:internship/Widget/musicplayer.dart';
import 'package:internship/back-end/spotify_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:vibration/vibration.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  //basic variables
  double currentSliderValue = 0.0;
  Duration currentTime = Duration.zero;
  bool isFav = false;
  int currentIndex = 0;
  bool isSliderThumbVisible = false; // Add this line
  bool isHovered = false; // Add this line

  Timer? _hideThumbTimer;
   dynamic credentials ;
    dynamic spotify ;
  
  List<String> musicTrackId = [
    '2Di7IM4TqsQfn52XV2lpfI?si=ee512582e7a54a98',
    '2ulKbV2d3ZKRaA2CnjNhmx?si=559586610fb8432b',
    '500H9ENeR5AYbKU1ScK6ME?si=4369cc708fa74371',
    '5LSAafg2oH9YPgf3EG17iw?si=c7f9597da4a948ae',
    '5zCnGtCl5Ac5zlFHXaZmhy?si=97239175284448b0'
  ];
  final List<Map<String, String>> favorites = [];

//song playing methods



  Future<void> playnext() async {
    currentTime = Duration.zero;
    currentSliderValue = 0;

    if (isPlaying == true) {
      player.stop();
    }
    currentIndex++;
    if (currentIndex >= musicTrackId.length) {
      currentIndex = 0;
    }
    await gettingsong(spotify,musicTrackId[currentIndex]);
    setState(() {});
    
  }

  Future<void> previous() async {
    currentTime = Duration.zero;
    isFav = searchByTitle(songName);
    currentSliderValue = 0;
    if (isPlaying == true) {
      player.stop();
    }
    currentIndex--;
    if (currentIndex < 0) {
      currentIndex = musicTrackId.length - 1;
    }
    await gettingsong(spotify,musicTrackId[currentIndex]);
    setState(() {});
  }

  void togglePlayPause() async {
    if (isPlaying == true) {
      await player.pause();
    } else {
      await player.resume();
    }

    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        // Simulate song playing
        Future.delayed(const Duration(seconds: 1), updateSlider);
      }
    });
  }

  void selectSong(int index) {
    setState(() {
      gettingsong(spotify,musicTrackId[index]);
      currentIndex = index;
      currentTime = Duration.zero;
      currentSliderValue = 0;
      isPlaying = false;
    });
  }

  void shuffleSong() {
    final random = Random();
    final randomIndex = random.nextInt(musicTrackId.length);
    selectSong(randomIndex);
  }

  //basic type conversion methods and searching and insering methods
  Duration doubleToDuration(double seconds) {
    int wholeSeconds = seconds.floor();
    int milliseconds = ((seconds - wholeSeconds) * 1000).round();

    return Duration(seconds: wholeSeconds, milliseconds: milliseconds);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  bool searchByTitle(String title) {
    for (var favorite in favorites) {
      if (favorite['title'] == title) {
        return true;
      }
    }
    return false;
  }

  void addFavorite(String title, String singer, String cover, String duration) {
    Map<String, String> favorite = {
      'title': title,
      'singer': singer,
      'cover': cover,
      'duration': duration,
    };
    favorites.add(favorite);
  }

  bool removeByTitle(String title) {
    for (var i = 0; i < favorites.length; i++) {
      if (favorites[i]['title'] == title) {
        favorites.removeAt(i);
        return true;
      }
    }
    return false;
  }

  void toggleFavorite(String title) {
    if (isFav) {
      removeByTitle(title);
    } else {
      addFavorite(songName, artistName, songimageurl, totalTime.toString());
    }

    setState(() {});
    isFav = !isFav;
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

  //slider update logic with animation
  void updateSlider() {
    if (isPlaying) {
      setState(() {
        currentTime += const Duration(seconds: 1);
        currentSliderValue = currentTime.inSeconds.toDouble();
        if (currentTime >= totalTime) {
          playnext();
          currentTime = Duration.zero;
          currentSliderValue = 0;
          isPlaying = false;
        } else {
          Future.delayed(const Duration(seconds: 1), updateSlider);
        }
      });
    }
  }

  void showSliderThumb() {
    setState(() {
      isSliderThumbVisible = true;
      isHovered = true;
    });
  }

  void hideSliderThumb() {
    setState(() {
      isSliderThumbVisible = false;
      isHovered = false;
    });
  }

  void delayedHideSliderThumb() {
    _hideThumbTimer?.cancel(); // Cancel any existing timer
    _hideThumbTimer = Timer(const Duration(seconds: 2), hideSliderThumb);
  }

  @override
  void initState() {
    super.initState();
     credentials =
        SpotifyApiCredentials(CustomString.clientId, CustomString.clientSecret);
    spotify = SpotifyApi(credentials);
    gettingsong(spotify,musicTrackId[currentIndex]);
    setState(() {
      
    });
  }

  @override
  void dispose() {
    _hideThumbTimer?.cancel();
    player.dispose(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Music Player'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
             Navigator.pushNamed(context, "/search");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
                height: screenHeight * 0.34,
                width: screenWidth * 0.8,
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 30, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: songimage(songimageurl)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songName,
                          style: const TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          artistName,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Vibration.vibrate(duration: 50);
                      toggleFavorite(songName);
                    },
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: const Icon(Icons.sync_alt_rounded,
                      size: 30, color: Colors.white),
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    // Logic for sync action
                  },
                ),
                GestureDetector(
                  child: const Icon(Icons.skip_previous,
                      size: 40, color: Colors.white),
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    // Logic for previous song
                    previous();
                  },
                ),
                GestureDetector(
                  child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 60,
                      color: Colors.white),
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    togglePlayPause();
                  },
                ),
                GestureDetector(
                  child: const Icon(Icons.skip_next,
                      size: 40, color: Colors.white),
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    playnext();
                    // Logic for next song
                  },
                ),
                GestureDetector(
                  child:
                      const Icon(Icons.shuffle, size: 30, color: Colors.white),
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    shuffleSong();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor:
                          isHovered ? Colors.blue[300] : Colors.white,
                      inactiveTrackColor: Colors.white30,
                      thumbColor: Colors.blue[300],
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: isSliderThumbVisible ? 7 : 0,
                      ),
                      trackHeight: 2.5,
                    ),
                    child: Slider(
                      value: currentSliderValue,
                      min: 0.0,
                      max: totalTime.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          player.seek(doubleToDuration(value));
                          currentSliderValue = value;
                          player.getCurrentPosition();
                          currentTime = Duration(seconds: value.toInt());
                        });
                        showSliderThumb();
                        delayedHideSliderThumb();
                      },
                      onChangeStart: (value) {
                        showSliderThumb();
                      },
                      onChangeEnd: (value) {
                        delayedHideSliderThumb();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(currentTime),
                            style: const TextStyle(color: Colors.white)),
                        Text(formatDuration(totalTime),
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  favorites.isEmpty ? " " : "Liked songs",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final song = favorites.elementAt(index);
                final favsongname = song['title'];
                final favartistname = song['singer'];
                final favsongduration = song['duration'];
                final coverimage = song['cover'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: listimage(coverimage!),
                      title: Text(favsongname!,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(favartistname ?? "Unknown",
                          style: const TextStyle(color: Colors.white70)),
                      trailing: Text(formatDurationString(favsongduration!),
                          style: const TextStyle(color: Colors.white70)),
                      onTap: () {
                        Vibration.vibrate(duration: 50);
                        selectSong(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}