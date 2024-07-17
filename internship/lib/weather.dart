import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Mock data for current weather and forecast
  final Map<String, dynamic> currentWeather = {
    "temperature": 0,
    "condition": "",
    "humidity": 0,
    "windSpeed": 0,
    "time": 0,
    "date": 0
  };

  void seach(String city) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$city,in&appid=1c0642b12eeb02a4028c80ac2ed5a5a7'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // print(response.stream.bytesToString());
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseBody);
      Map<String, dynamic> responseHeader = await response.headers;
      print(responseHeader['date']);

      String dateString = responseHeader['date'];

      // Remove any leading or trailing whitespace from the string
       dateString = dateString.trim();
  
  // Define the input format
  DateFormat inputFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
  DateTime parsedDate = inputFormat.parseUtc(dateString);

  // Define the output format
  DateFormat outputDateFormat = DateFormat("dd-MM-yyyy");
  DateFormat outputTimeFormat = DateFormat("HH:mm:ss");

  // Format the date and time
  String formattedDate = outputDateFormat.format(parsedDate);
  String formattedTime = outputTimeFormat.format(parsedDate);

      currentWeather['date'] = formattedDate;
      currentWeather['time'] = formattedTime;

      // Combine date and time

      // Extract the temperature

      currentWeather['temperature'] = (data['main']['temp'] - 273.15).floor();
      currentWeather['windSpeed'] = (data['wind']['speed']);
      currentWeather['humidity'] = data['main']['humidity'];
      currentWeather['condition'] = data['weather'][0]['main'];
      print(currentWeather['condition']);
      setState(() {});

      // Print the temperature
    } else {
      print(response.reasonPhrase);
    }
  }

  String city = "Your City";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchField(),
            const SizedBox(height: 20),
            _buildCurrentWeather(screenWidth, screenHeight),
            const SizedBox(height: 20),
            _buildWeatherDetails(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search city",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
        ),
        onSubmitted: (value) {
          setState(() async {
            seach(value);
            city = value;
            // Here you can update the currentWeather and forecast data based on the city
            // For now, it's static data
          });
        },
      ),
    );
  }

  Widget _buildCurrentWeather(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            city,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '${currentWeather["temperature"]}°C',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            currentWeather["condition"],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          BoxedIcon(
            (currentWeather['condition'] == 'Clouds')
                ? WeatherIcons.cloud
                : WeatherIcons.day_sunny,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.7),
      ),
      child: Column(
        children: [
          _buildDetailRow("Humidity", "${currentWeather["humidity"]}%"),
          const Divider(),
          _buildDetailRow("Wind Speed", "${currentWeather["windSpeed"]} km/h"),
          const Divider(),
          _buildDetailRow("Time", "${currentWeather['time']}"),
          const Divider(),
          _buildDetailRow("Date", "${currentWeather['date']}")
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
