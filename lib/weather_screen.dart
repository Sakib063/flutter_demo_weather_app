import 'dart:convert';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:weather_app/Weather.dart';
import 'package:weather_app/additional_information_card.dart';
import 'package:weather_app/chart.dart';
import 'package:weather_app/hourly_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  final VoidCallback toggle_theme;
  const WeatherScreen({super.key,required this.toggle_theme});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double? latitude;
  double? longitude;

  double pressure = 0;
  double temp = 0;
  int humidity = 0;
  double wind_speed = 0;
  String time = '';
  int weather=0;
  String unit='';
  List<String> hour=[];
  List<double> hourly_temp=[];
  List<int> hourly_weather=[];

  @override
  void initState() {
    super.initState();
    get_weather_info_api();
  }

  Future<Weather> get_weather_info_api() async {
    bool service_enabled;
    LocationPermission permission;

    service_enabled=await Geolocator.isLocationServiceEnabled();
    if(!service_enabled){
      setState(() {
        AlertDialog(
          title: Text("Location Not found"),
          content: Text("Please turn on Location"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context,'Ok');
              },
              child: const Text("Ok"),
            ),
          ],
        );
      });
    }

    permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        AlertDialog(
          title: Text("Location Not found"),
          content: Text("Please turn on Location"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context,'Ok');
              },
              child: const Text("Ok"),
            ),
          ],
        );
      }
    }

    Position position=await Geolocator.getCurrentPosition(
      locationSettings:LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );

    latitude = position.latitude;
    longitude = position.longitude;

    // latitude = 23.7104;
    // longitude = 90.407;

    final res = await http.get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,surface_pressure,wind_speed_10m&hourly=temperature_2m,weather_code"),);
    final data = jsonDecode(res.body);
    if (data.containsKey("error")) {
      throw "An Unexpected Error occurred";
    }
    return Weather.fromJson(data);
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
            icon: const Icon(Icons.lightbulb),
          )
        ],
      ),
      body: FutureBuilder<Weather>(
        future: get_weather_info_api(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if(snapshot.hasData){
            final weather_data=snapshot.data!;
            pressure = weather_data.current.surfacePressure;
            time = weather_data.current.time;
            temp = weather_data.current.temperature2M;
            unit = weather_data.currentUnits.temperature2M;
            humidity = weather_data.current.relativeHumidity2M;
            wind_speed = weather_data.current.windSpeed10M;
            weather = weather_data.current.weatherCode;
            hour = weather_data.hourly.time;
            hourly_temp = weather_data.hourly.temperature2M;
            hourly_weather = weather_data.hourly.weatherCode;
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
                                temp.toString()+unit,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(weather==0?Icons.sunny:Icons.cloud,size: 64),
                              const SizedBox(height: 16),
                              Text(
                                weather==0?"Clear Sky":"Cloudy Sky",
                                style: TextStyle(fontSize:20),
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder:(context){
                        return ForecastChart(hours:hour, temps:hourly_temp);
                      },
                    ));
                  },
                  child:Text('View Chart'),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
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
