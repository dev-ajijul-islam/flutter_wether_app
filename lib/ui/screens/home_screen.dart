
import 'package:flutter/material.dart';
import 'package:wether_app/services/wether_controller.dart';
import 'package:wether_app/ui/widgets/blur_bg.dart';
import 'package:wether_app/ui/widgets/high_low_card.dart';
import 'package:wether_app/ui/widgets/todays_wether.dart';
import 'package:wether_app/ui/widgets/wind_rainy_sun_status_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool loading = false;

  Map<String, dynamic>? location;
  Map<String, dynamic>? forecast;
  Map<String, dynamic>? daily;
  Map<String, dynamic>? hourly;

  @override
  void initState() {
    super.initState();
    _loadWeather("Dhaka");
  }
  Future<void> _loadWeather(String city) async {
    var loc = await WetherController.getLongLat(city);
    if (loc != null) {
      location = loc;
      var data = await WetherController.getForecast(loc["latitude"], loc["longitude"]);
      setState(() {
        forecast = data?["forecast"];
        daily = data?["daily"];
        hourly = data?["hourly"];
      });
    }
  }

  IconData getWeatherIcon(int code) {
    if (code == 0) return Icons.sunny;
    if (code == 1 || code == 2) return Icons.cloud;
    if (code == 3) return Icons.cloud_queue;
    if (code == 45 || code == 48) return Icons.grain;
    if (code == 51 || code == 53 || code == 55) return Icons.grain;
    if (code == 61 || code == 63 || code == 65) return Icons.water_drop;
    if (code == 71 || code == 73 || code == 75) return Icons.ac_unit;
    if (code == 80 || code == 81 || code == 82) return Icons.umbrella;
    return Icons.help_outline;
  }

  String formatHour(String isoTime) {
    DateTime dt = DateTime.parse(isoTime);
    return DateFormat.j().format(dt); // e.g. 5 AM, 2 PM
  }

  String formatDate(String isoTime) {
    DateTime dt = DateTime.parse(isoTime);
    return DateFormat('EEE, d MMM').format(dt); // e.g. Mon, 11 Nov
  }

  String formatWeekday(String isoTime) {
    DateTime dt = DateTime.parse(isoTime);
    return DateFormat('EEE').format(dt); // Sun, Mon, Tue...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blueAccent],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              SizedBox(height: 20),
              Row(
                spacing: 5,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.gps_fixed)),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ),
                        hintText: "Search Location",
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _loadWeather(_searchController.text);
                    },
                    icon: Icon(Icons.search, size: 25),
                  ),
                ],
              ),
              SizedBox(height: 10),
              loading ? LinearProgressIndicator() : SizedBox(),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white),
                  Text(
                    "${location?["name"]}, ${location?["country"]}",
                    style: TextTheme.of(context).titleMedium,
                  ),
                ],
              ),
              SizedBox(height: 20),
              TodaysWether(forecast: forecast),
              HighLowCard(daily: daily),
              SizedBox(height: 20),
              WindRainySunStatusCard(hourly: hourly),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Hourly Forecast",
                  style: TextTheme.of(context).titleSmall,
                ),
              ),
              SizedBox(height: 5),
              BlurBg(
                child: SizedBox(
                  width: double.maxFinite,
                  height: 100,
                  child: Center(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: hourly?['time']?.length ?? 0,
                      itemBuilder: (context, index) {
                        final time = hourly!['time'][index];
                        final temp = hourly!['temperature_2m'][index];
                        final code = hourly!['weather_code'][index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: 40,
                              height: 40,
                              child: Icon(
                                getWeatherIcon(code),
                                color: Colors.yellow,
                              ),
                            ),
                            Text(
                              formatHour(time),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  temp.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.circle_outlined,
                                  size: 8,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("10 Days Forecast"),
              ),
              SizedBox(height: 10),
              BlurBg(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: daily?['time']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final date = daily!['time'][index];
                    final max = daily!['temperature_2m_max'][index];
                    final min = daily!['temperature_2m_min'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatWeekday(date)), // <-- শুধু Sun, Mon, Tue
                          Icon(Icons.sunny, color: Colors.yellow),
                          LinearPercentIndicator(
                            barRadius: Radius.circular(100),
                            width: 140.0,
                            lineHeight: 10.0,
                            percent: ((max + min) / 2) / 50,
                            backgroundColor: Colors.white54,
                            progressColor: Colors.yellow,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                max.toStringAsFixed(0),
                                style: TextStyle(fontSize: 14),
                              ),
                              Icon(
                                Icons.circle_outlined,
                                size: 8,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                min.toStringAsFixed(0),
                                style: TextStyle(fontSize: 14),
                              ),
                              Icon(
                                Icons.circle_outlined,
                                size: 8,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
