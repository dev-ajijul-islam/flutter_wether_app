import 'dart:convert';

import 'package:http/http.dart' as http;

class WetherController {
  Map<String, dynamic>? location;
  Map<String, dynamic>? forecast;
  Map<String, dynamic>? daily;
  Map<String, dynamic>? hourly;

  static Future<Map<String, dynamic>?> getLongLat(String city) async {
    Uri url = Uri.parse(
      "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=en&format=json",
    );

    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var decoded = jsonDecode(res.body);
        if (decoded["results"] != null && decoded["results"].isNotEmpty) {
          return decoded["results"][0];
        }
      }
    } catch (e) {
      print("Location fetch error: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getForecast(double lat,double lon) async {

    Uri url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&forecast_days=10&timezone=Asia%2FDhaka",
    );

    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var decoded = jsonDecode(res.body);

        return {
          "forecast": decoded["current"],
          "daily": decoded["daily"],
          "hourly": decoded["hourly"],
        };
      } else {
        return null;
      }
    } catch (e) {
      print("Forecast fetch error: $e");
      return null;
    }
  }
}
