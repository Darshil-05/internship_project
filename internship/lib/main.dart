import 'package:internship/searchpage.dart';
import 'package:internship/weather.dart';
import 'package:flutter/material.dart';
import 'package:internship/music.dart';
import 'package:internship/tvremote.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/remote': (context) => const TvRemote(), // Define route for login page
      '/music': (context) => const MusicPage(), // Define route for home page
      '/search' : (context) =>  const MusicSearch(),  // Define route for home page
      '/weather' : (context) =>  const WeatherPage(),  // Define route for home page
      '/home': (context) => const Home(),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          surfaceTintColor: MaterialStatePropertyAll(Color(0xff222222)),
          backgroundColor: MaterialStatePropertyAll(
            Color(0xff222222),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xff0a0a0a)),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff0a0a0a),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff0a0a0a),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: const Color(0xff0a0a0a),
        primaryContainer: const Color(0xFF1f2029),
        secondary: const Color(0xff222222),
        secondaryContainer: Colors.white,
      ),
    ),
    home: const TvRemote(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/remote");
              },
              child: const Text("T.V. Remote" , style: TextStyle(color: Colors.white , fontSize: 25),),
            ),ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/music");
              },
              child: const Text("music", style: TextStyle(color: Colors.white , fontSize: 25),),
            ),ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/weather");
              },
              child: const Text("weather", style: TextStyle(color: Colors.white , fontSize: 25),),
            ),
          ],
        ),
      ),
    );
  }
}
