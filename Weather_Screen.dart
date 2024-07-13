import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/secrets.dart';//consist of API key
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
class _WeatherScreenState extends State<WeatherScreen> {

  Future <Map<String,dynamic>> getCurrentWeather() async{
    try{
      String cityName='Sangli';
      final result=await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
      );
      //result will be a string to covert it to json data
      final data=jsonDecode(result.body);
      if(data['cod']!='200'){//if status code is not 200 means some error occured
         throw 'An unexpected error occured';
      }
      //build function will be rebuilt whenever we will get the temp value
        //temp=data['list'][0]['main']['temp'];
        return data;

    }catch(e){
      throw e.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Weather App',
          style:TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions:  [
          IconButton(onPressed: (){
            setState(() {
            });
          }, icon:const Icon(Icons.refresh),
          ),
        ],
      ),
      body:FutureBuilder(
        future: getCurrentWeather(),
        builder:(context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: const CircularProgressIndicator());
           }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          final data=snapshot.data!;
          final currentWeatherData=data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final degreetemp=currentTemp-273.15;


          return Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
             children: [
              SizedBox(
                width:double.infinity,
                child: Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                  ),
                 child:BackdropFilter(//to add a blur effect
                   filter: ImageFilter.blur(sigmaY: 3,sigmaX: 3),
                   child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Column(
                       children: [
                         Text('${degreetemp.toStringAsFixed(2)} °C',
                             style:const TextStyle(
                               fontSize: 32,
                               fontWeight: FontWeight.bold,
                             ),
                         ),
                          Icon(
                           currentSky=='Clouds'||currentSky=='Rain'
                               ?Icons.cloud:Icons.sunny,
                               size: 64,
                         ),
                         Text(currentSky,
                         style:const TextStyle(
                           fontSize: 20,
                         ),
                         ),
                       ],
                     ),
                   ),
                 ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Hourly Forecast',//to align text to left we will wrap it with align widget
                    style:TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                ),
              ),
              const SizedBox(height: 15),
               SizedBox(
                 height: 120,
                 child: ListView.builder(
                   itemCount: 5,
                     scrollDirection: Axis.horizontal,
                     itemBuilder:(context,index) { //also start from zero
                     final hourlyForecast=data['list'][index+1];
                     String time=hourlyForecast['dt_txt'].toString();
                     final degreetemp2=hourlyForecast['main']['temp']-273.15;
                     return HourlyForecastItem(
                         time: time.substring(11,16),
                         temp: degreetemp2.toStringAsFixed(2),
                         icon:hourlyForecast['weather'][0]['main'].toString()=='Clouds'||
                                hourlyForecast['weather'][0]['main'].toString()=='Rain' ? Icons.cloud:Icons.sunny,
                     );
                     },
                 ),
               ),
              const SizedBox(height:20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Additional Information',//to align text to left we will wrap it with align widget
                  style:TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height:15),
                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   SizedBox(
                     width: 115,
                     child: Card(
                       child: Column(
                         children: [
                           const Icon(Icons.water_drop_rounded,
                           size: 20,),
                           const Text('Humidity',
                             style: TextStyle(fontSize: 20,),),
                           Text(currentHumidity.toString(),
                             style:const TextStyle(fontSize: 20,
                             fontWeight: FontWeight.bold,
                             )
                           ),

                         ],
                       ),
                     ),
                   ),
                   SizedBox(
                     width: 115,
                     child: Card(
                       child: Column(
                         children: [
                           const Icon(Icons.air_outlined,
                             size: 20,),
                           const Text('WindSpeed',
                             style: TextStyle(fontSize: 20,),),
                           Text(currentWindSpeed.toString(),
                               style:const TextStyle(fontSize: 20,
                                 fontWeight: FontWeight.bold,
                               )
                           ),

                         ],
                       ),
                     ),
                   ),
                   SizedBox(
                     width: 115,
                     child: Card(
                       child: Column(
                         children: [
                           const Icon(Icons.umbrella_outlined,
                             size: 20,),
                           const Text('pressure',
                             style: TextStyle(fontSize: 20,),),
                           Text(currentPressure.toString(),
                               style:const TextStyle(fontSize: 20,
                                 fontWeight: FontWeight.bold,
                               )
                           ),

                         ],
                       ),
                     ),
                   ),
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


class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temp,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 100,
      child: Card(
        child:Padding(
          padding:  const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(time,
                style:const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              ),
               const SizedBox(height: 8),
              Icon(
                icon,
                size:32,
              ),
               const SizedBox(height: 8),
              Text(temp),
            ],
          ),
        ),
      ),

    );
  }
}

