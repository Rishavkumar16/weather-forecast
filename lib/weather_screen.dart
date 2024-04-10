import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/secrets.dart';
import 'hourly_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {


  Future<Map<String,dynamic>> getCurrentWeather()async {
    try{
      String cityName = 'Delhi';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$openWeatherAPIKey'
        ),
      );
      final data=jsonDecode(res.body);

      if(data['cod']!='200'){
        throw 'An Unexpected Error Occured';
      }
      return data;


    } catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed:() {
            setState(() {

            });
          },
            icon:const Icon(
                Icons.refresh,
              color: Colors.white60,
            ),
          ),
        ],
      ),

      body:  FutureBuilder(
        future: getCurrentWeather(),
        builder:(context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator.adaptive()
              );
            }
          if(snapshot.hasError){
            return Center(
                child: Text(
                    snapshot.error.toString()
                )
            );
          }

          final data= snapshot.data!;
          final currentWeatherData= data['list'][0];
          final currentTemp=currentWeatherData['main']['temp'];
          final currentSky=currentWeatherData['weather'][0]['main'];
          final currentPressure =currentWeatherData['main']['pressure'];
          final currentHumidity=currentWeatherData['main']['humidity'];
          final currentWindSpeed=currentWeatherData['wind']['speed'];
          return Padding(
          padding: const  EdgeInsets.all(16.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter:ImageFilter.blur(
                          sigmaX: 11,
                          sigmaY: 11,
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('$currentTemp K',
                            style:const  TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                             Icon(
                              currentSky=='Clouds'||currentSky=='Rain'?Icons.cloud:Icons.sunny,
                             size: 72,
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                             Text('$currentSky',
                            style:const TextStyle(
                              fontSize: 25,
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //weather forecast card
              const Text('Hourly Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final hourlyForecast = data['list'][index + 1];
                    final hourlySky =
                    data['list'][index + 1]['weather'][0]['main'];
                    final hourlyTemp =
                    hourlyForecast['main']['temp'].toString();
                    final time = DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecast(
                      time: DateFormat.j().format(time),
                      temp: hourlyTemp,
                      icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                          ? Icons.cloud
                          : Icons.sunny,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text('Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currentHumidity',
                    ),
                     AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$currentWindSpeed',
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure',
                    ),
                 ]
                ),
            ],
          ),
        );
        },
      ),
    );
  }
}



