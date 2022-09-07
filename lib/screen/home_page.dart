import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    lat = position!.latitude;
    lon = position!.longitude;
    print("Latitude is ${lat} ${lon}");
    fetchWeatherData();
  }

  fetchWeatherData() async {
    String weatherApi =
        "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=cc93193086a048993d938d8583ede38a";
    String forecastApi =
        "https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=cc93193086a048993d938d8583ede38a";

    var weatherResponce = await http.get(Uri.parse(weatherApi));
    var forecastResponce = await http.get(Uri.parse(forecastApi));
    print("result is ${forecastResponce.body}");
    setState(() {
      weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
      forecastMap =
          Map<String, dynamic>.from(jsonDecode(forecastResponce.body));
    });
  }

  var lat;
  var lon;
  @override
  void initState() {
    // TODO: implement initState
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: weatherMap == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Text("${Jiffy(DateTime.now()).format("MMM do yy, h:mm")}"),
                    Text("${weatherMap!["name"]}"),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "${weatherMap!["main"]["temp"]}°",
                      style: TextStyle(fontSize: 22),
                    ),
                    Image.network(weatherMap!["main"]["feels_like"] ==
                            "clear sky"
                        ? "https://windy.app//storage/posts/November2021/02-partly-%20cloudy-weather-symbol-windyapp.jpg"
                        : weatherMap!["main"]["feels_like"] == "rainy"
                            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9k7m4NE-r-iF8f_WuSbW09wnlE35SEw0poQWiHdhEMvihYpBddZ3UBZyGtKTfOV8EVqA&usqp=CAU"
                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9k7m4NE-r-iF8f_WuSbW09wnlE35SEw0poQWiHdhEMvihYpBddZ3UBZyGtKTfOV8EVqA&usqp=CAU"),
                    Text(
                      "${weatherMap!["main"]["feels_like"]}°",
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      "${weatherMap!["weather"][0]["main"]}",
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      "Humidity : ${weatherMap!["main"]["humidity"]}, Pressure :${weatherMap!["main"]["pressure"]}",
                      style: TextStyle(fontSize: 22),
                    ),
                    // Text(
                    //   "Sunrise${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)).format("h:mm:a")} : , Sunset ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)).format("h:mm:a")}:",
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: forecastMap!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 8),
                              color: Colors.grey,
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //     "${Jiffy("${forecastMap!["list"][index]["dt_txt"]}").format("EEE h:mm")}"),
                                  // Text(
                                  //     "${forecastMap!["list"][index]["main"]["temp_min"]} / ${forecastMap!["list"][index]["main"]["temp_max"]}"),
                                  // Text(
                                  //     "${Jiffy("${forecastMap!["list"][index]["dt_txt"]}").format("EEE h:mm")}"),
                                  Text(
                                    "${forecastMap!["list"][index]["weather"][0]["description"]}",
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
