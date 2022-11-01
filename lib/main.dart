import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MaterialApp(
      title: "WeatherX",
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var search = '';
  var location;

  final fieldText = TextEditingController();

  void clearSearch() {
    fieldText.clear();
  }

  Future getWeather([String city = 'lagos']) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=31b7f92ee1069769b2b8eb71dde1b3d8'));
    var result = jsonDecode(response.body);

    setState(() {
      temp = result['main']['temp'];
      description = result['weather'][0]['description'];
      currently = result['weather'][0]['main'];
      humidity = result['main']['humidity'];
      windSpeed = result['wind']['speed'];
      location = result['name'] + " " + result['sys']['country'];
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink,
              Colors.purple,
            ],
          )),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    location ?? "Lagos Default",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  temp != null ? "$temp\u00B0" + "C" : "Loading",
                  style: const TextStyle(
                      fontSize: 50.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    currently != null ? currently.toString() : "Loading",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ]),
        ),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  search = val;
                });
              },
              controller: fieldText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search a City',
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    getWeather(search.trim().toLowerCase());
                    clearSearch();
                  },
                ),
              ),
            )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.temperatureHalf),
              title: const Text("Temperature"),
              trailing: Text(temp != null ? "$temp\u00B0" + "C" : "Loading"),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.cloud),
              title: const Text("Weather"),
              trailing: Text(
                  description != null ? description.toString() : "Loading"),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.sun),
              title: const Text("Humidity"),
              trailing:
                  Text(humidity != null ? humidity.toString() : "Loading"),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.wind),
              title: const Text("Wind Speed"),
              trailing:
                  Text(windSpeed != null ? windSpeed.toString() : "Loading"),
            ),
          ]),
        ))
      ]),
    );
  }
}
