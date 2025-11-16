import 'package:flutter/material.dart';
import 'package:wether_app/ui/widgets/blur_bg.dart';

class WindRainySunStatusCard extends StatelessWidget {
  final Map<String, dynamic>? hourly;

  const WindRainySunStatusCard({super.key, required this.hourly});

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


  String getWeatherDesc(int code) {
    if (code == 0) return "Clear";
    if (code == 1 || code == 2) return "Partly Cloudy";
    if (code == 3) return "Cloudy";
    if (code == 45 || code == 48) return "Fog";
    if (code == 51 || code == 53 || code == 55) return "Drizzle";
    if (code == 61 || code == 63 || code == 65) return "Rain";
    if (code == 71 || code == 73 || code == 75) return "Snow";
    if (code == 80 || code == 81 || code == 82) return "Showers";
    return "Unknown";
  }


  List<Map<String, dynamic>> getHourlyList() {
    if (hourly == null) return [];
    final List times = hourly!['time'] ?? [];
    final List codes = hourly!['weather_code'] ?? [];
    final List winds = hourly!['wind_speed_10m'] ?? [];

    final today = DateTime.now().toIso8601String().split('T')[0];

    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < times.length; i++) {
      if (times[i].toString().startsWith(today)) {
        list.add({
          'time': times[i],
          'weather_code': codes[i],
          'wind_speed_10m': winds[i],
        });
        if (list.length >= 3) break;
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final hourlyList = getHourlyList();

    return BlurBg(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(hourlyList.length, (index) {
          final hourTime = hourlyList[index]['time'] as String;
          final weatherCode = hourlyList[index]['weather_code'] as int;
          final windSpeed = hourlyList[index]['wind_speed_10m'] as double;

          final time = hourTime.split('T')[1].substring(0, 5);

          return SizedBox(
            width: MediaQuery.of(context).size.width/3.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  getWeatherIcon(weatherCode),
                  color: Colors.white54,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(time, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  getWeatherDesc(weatherCode),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  "${windSpeed.toStringAsFixed(1)} km/h",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
