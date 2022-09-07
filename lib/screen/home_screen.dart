import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // var lat;

  // var lon;

  // // HomeScreen({Key? key}) : super(key: key);
  // _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   Position position = await Geolocator.getCurrentPosition();
  //   lat = position.latitude;
  //   lon = position.longitude;
  //   print("Latitude is ${lat} ${lon}");
  //   getWeatherData();
  //   getForcastData();
  // }

  // Future getWeatherData() async {
  //   http.Response weatherResponce = await http.get(Uri.parse(
  //       "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=1235d66f93a539a09264b73429cf01db"));

  //   if (weatherResponce.statusCode == 200) {
  //     return jsonDecode(weatherResponce.body);
  //   } else {
  //     throw Exception("Data Loading Error");
  //   }
  // }

  // Future getForcastData() async {
  //   http.Response forcastResponce = await http.get(Uri.parse(
  //       "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=$lat&lon=$lon&appid=1235d66f93a539a09264b73429cf01db"));

  //   if (forcastResponce.statusCode == 200) {
  //     return jsonDecode(forcastResponce.body);
  //   } else {
  //     throw Exception("Data Loading Error");
  //   }
  // }

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
    String nowDateTime = DateFormat('hh:mm a – yyyy-MM-dd')
        .format(DateTime.parse(DateTime.now().toString()));
    var celsius = ((weatherMap!["main"]["temp"]) - 273.15);
    return SafeArea(
      child: weatherMap == null
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFF10103B),
                body: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sunny,
                              size: 70.0,
                              color: Colors.yellowAccent,
                            ),
                            SizedBox(
                              width: 14.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today",
                                  style: TextStyle(
                                    fontSize: 36.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${Jiffy(DateTime.now()).format("EEE, d MMM yy")}",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 28.0,
                      ),
                      Container(
                        child: Text(
                          "${celsius.toInt()}°c",
                          style: TextStyle(fontSize: 80, color: Colors.white),
                        ),
                      ),

                      Text(
                        "${weatherMap!["name"]}, ${weatherMap!["sys"]['country']}",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 26.0,
                      ),

                      // Text(
                      //   "Humidity : ${weatherMap!["main"]["humidity"]}, Pressure :${weatherMap!["main"]["pressure"]}",
                      //   style: TextStyle(fontSize: 22, color: Colors.white),
                      // ),

                      // Text("${Jiffy(DateTime.now()).format("MMM do yy, h:mm")}"),
                      // Text("${weatherMap!["name"]}"),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      // Text(
                      //   "${weatherMap!["main"]["temp"]}°",
                      //   style: TextStyle(fontSize: 22),
                      // ),
                      // Image.network(weatherMap!["main"]["feels_like"] ==
                      //         "clear sky"
                      //     ? "https://windy.app//storage/posts/November2021/02-partly-%20cloudy-weather-symbol-windyapp.jpg"
                      //     : weatherMap!["main"]["feels_like"] == "rainy"
                      //         ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9k7m4NE-r-iF8f_WuSbW09wnlE35SEw0poQWiHdhEMvihYpBddZ3UBZyGtKTfOV8EVqA&usqp=CAU"
                      //         : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9k7m4NE-r-iF8f_WuSbW09wnlE35SEw0poQWiHdhEMvihYpBddZ3UBZyGtKTfOV8EVqA&usqp=CAU"),
                      // Text(
                      //   "${weatherMap!["main"]["feels_like"]}°",
                      //   style: TextStyle(fontSize: 22),
                      // ),
                      // Text(
                      //   "${weatherMap!["weather"][0]["main"]}",
                      //   style: TextStyle(fontSize: 22),
                      // ),
                      // Text(
                      //   "Humidity : ${weatherMap!["main"]["humidity"]}, Pressure :${weatherMap!["main"]["pressure"]}",
                      //   style: TextStyle(fontSize: 22),
                      // ),
                      // Text(
                      //   "Sunrise${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)).format("h:mm:a")} : , Sunset ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)).format("h:mm:a")}:",
                      //   style: TextStyle(fontSize: 18),
                      // ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: forecastMap!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 14),
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF1E1F46),
                                    border: Border.all(
                                        color: Colors.black12, width: 1.0),
                                    borderRadius: BorderRadius.circular(100.0)),
                                width: 120,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${Jiffy("${forecastMap!["list"][index]["dt_txt"]}").format("h:mm a")}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Color(0xFF10103B),
                                      child: Icon(Icons.sunny_snowing),
                                    ),
                                    Text(
                                      "${forecastMap!["list"][index]["weather"][0]["description"]}",
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 18),
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
            ),
    );
  }
}
