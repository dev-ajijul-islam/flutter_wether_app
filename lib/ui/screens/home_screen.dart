import 'package:flutter/material.dart';
import 'package:wether_app/services/wether_controller.dart';
import 'package:wether_app/ui/widgets/high_low_card.dart';
import 'package:wether_app/ui/widgets/hourly_forecast.dart';
import 'package:wether_app/ui/widgets/ten_day_forecast.dart';
import 'package:wether_app/ui/widgets/todays_wether.dart';
import 'package:wether_app/ui/widgets/wind_rainy_sun_status_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


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
    _loadCurrentLocationWeather();
  }

  Future<void> _loadWeather(String city) async {
    setState(() {
      loading = true;
    });
    var loc = await WetherController.getLongLat(city);
    if (loc != null) {
      location = loc;
      var data = await WetherController.getForecast(
        loc["latitude"],
        loc["longitude"],
      );
      setState(() {
        forecast = data?["forecast"];
        daily = data?["daily"];
        hourly = data?["hourly"];
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _loadCurrentLocationWeather() async {
    setState(() {
      loading = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      var data = await WetherController.getForecast(
        position.latitude,
        position.latitude,
      );

      setState(() {
        location = {
          "country": placemarks.first.country,
          "name": placemarks.first.street,
        };
        forecast = data?["forecast"];
        daily = data?["daily"];
        hourly = data?["hourly"];
      });
      setState(() {
        loading = false;
      });
    }
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
                  IconButton(
                    onPressed: () {
                      _loadCurrentLocationWeather();
                    },
                    icon: Icon(Icons.gps_fixed),
                  ),
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
              HourlyForecast(hourly: hourly),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("10 Days Forecast"),
              ),
              SizedBox(height: 10),
              TenDayForecast(daily: daily),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
