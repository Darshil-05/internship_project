import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibration/vibration.dart';

class TvRemote extends StatefulWidget {
  const TvRemote({super.key});

  @override
  State<TvRemote> createState() => _TvRemoteState();
}

class _TvRemoteState extends State<TvRemote> {
  bool mute = true;
  bool ison = false;
  Color power = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TV remote'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Opacity(
                opacity: ison ? 1 : 0.5,
                child: GestureDetector(
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    setState(() {
                      ison = !ison;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.power_settings_new,
                      size: 40,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Vibration.vibrate(duration: 50);
                  setState(() {
                    mute = !mute;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                  child: Icon(
                    mute ? Icons.volume_off_outlined : Icons.volume_up,
                    size: 40,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: screenHeight * 0.22,
                width: screenWidth * 0.2,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: const SizedBox(
                        child: Icon(Icons.arrow_drop_up),
                      ),
                    ),
                    const SizedBox(
                      child: Text(
                        "CH",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const SizedBox(child: Icon(Icons.arrow_drop_down)),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.22,
                width: screenWidth * 0.2,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Icon(Icons.arrow_drop_up),
                    ),
                    const Text(
                      "VOL",
                      style: TextStyle(fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Vibration.vibrate(duration: 50);
              },
              child: Container(
                height: screenHeight * 0.063,
                width: screenWidth * 0.14,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Icon(Icons.arrow_drop_up),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: screenWidth * 0.15,
              ),
              GestureDetector(
                onTap: () {
                  Vibration.vibrate(duration: 50);
                },
                child: Container(
                  height: screenHeight * 0.063,
                  width: screenWidth * 0.14,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: const Icon(Icons.arrow_left),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Vibration.vibrate(duration: 50);
                },
                child: Container(
                  height: screenHeight * 0.063,
                  width: screenWidth * 0.18,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: const Center(
                      child: Text(
                    "MENU",
                    style: TextStyle(fontSize: 15),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Vibration.vibrate(duration: 50);
                },
                child: Container(
                  height: screenHeight * 0.063,
                  width: screenWidth * 0.14,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: const Icon(Icons.arrow_right),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.15,
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Vibration.vibrate(duration: 50);
              },
              child: Container(
                height: screenHeight * 0.063,
                width: screenWidth * 0.14,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.35,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: SvgPicture.asset('assets/netflix.svg'),
                ),
                Container(
                  height: screenHeight * 0.07,
                  padding: const EdgeInsets.all(5),
                  width: screenWidth * 0.35,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: SvgPicture.asset(
                    'assets/prime.svg',
                    colorFilter:
                        const ColorFilter.mode(Color(0xff219bff), BlendMode.srcIn),
                  ),
                )
              ]),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.35,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: SvgPicture.asset('assets/disney.svg'),
                ),
                Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.35,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: SvgPicture.asset('assets/youtube.svg')),
              ]),
        ],
      ),
    );
  }
}
