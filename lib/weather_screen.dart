import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_information_card.dart';
import 'package:weather_app/hourly_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  final Function toggle_theme;
  const WeatherScreen({super.key,required this.toggle_theme});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String pressure = '';
  String temp = '';
  String humidity = '';
  String wind_speed = '';
  String time = '';
  List<dynamic> hour=[];
  List<dynamic> hourly_temp=[];
  List<dynamic> hourly_weather=[];
  int weather=0;
  String unit='';

  @override
  void initState() {
    super.initState();
    get_weather_info_api();
  }

  Future<Map<String, dynamic>> get_weather_info_api() async {
    final res = await http.get(
      Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=23.7104&longitude=90.4074&current=temperature_2m,relative_humidity_2m,weather_code,surface_pressure,wind_speed_10m&hourly=temperature_2m,weather_code"),
    );

    final data = jsonDecode(res.body);

    if (data.containsKey("error")) {
      throw "An Unexpected Error occurred";
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {

              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              widget.toggle_theme();
            },
            icon: const Icon(Icons.dark_mode),
          )
        ],
      ),
      body: FutureBuilder(
        future: get_weather_info_api(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if(snapshot.hasData){
            final data=snapshot.data!;
            pressure = data['current']['surface_pressure'].toString();
            time = data['current']['time'];
            temp = data['current']['temperature_2m'].toString();
            unit=data['current_units']['temperature_2m'];
            humidity = data['current']['relative_humidity_2m'].toString();
            wind_speed = data['current']['wind_speed_10m'].toString();
            weather=data['current']['weather_code'];
            hour=data['hourly']['time'];
            hourly_temp=data['hourly']['temperature_2m'];
            hourly_weather=data['hourly']['weather_code'];
          }


          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                temp+unit,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                weather==0 ? Icons.sunny:Icons.cloud,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                weather==0?"Clear Sky":"Cloudy Sky",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 24,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      DateTime parsedTime = DateTime.parse(hour[index]);
                      String formatted_time = DateFormat('hh:mm a').format(parsedTime);
                      return HourlyCard(time: formatted_time, icon: hourly_weather[index]==0?Icons.sunny:Icons.cloud, temp: hourly_temp[index].toString()+unit);
                    }
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationCard(icon: Icons.water_drop, status: "Humidity", value: humidity),
                    AdditionalInformationCard(icon: Icons.air, status: "Wind Speed", value: wind_speed),
                    AdditionalInformationCard(icon: Icons.beach_access, status: "Pressure", value: pressure),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
