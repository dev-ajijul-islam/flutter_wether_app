import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodaysWether extends StatelessWidget {
  final Map<String, dynamic>? forecast;
  final String? sunrise;
  final String? sunset;

    TodaysWether({super.key, required this.forecast, this.sunrise, this.sunset});

  // Weather code mapping
  Map<int, Map<String, dynamic>> weatherMap = const {
    0: {"text": "Clear Sky", "icon": Icons.wb_sunny},
    1: {"text": "Mainly Clear", "icon": Icons.sunny_snowing},
    2: {"text": "Partly Cloudy", "icon": Icons.cloud_queue},
    3: {"text": "Most Cloudy", "icon": Icons.cloud_outlined},
    45: {"text": "Fog", "icon": Icons.foggy},
    51: {"text": "Light Drizzle", "icon": Icons.grain},
    53: {"text": "Moderate Drizzle", "icon": Icons.grain},
    55: {"text": "Dense Drizzle", "icon": Icons.grain},
    61: {"text": "Slight Rain", "icon": Icons.water_drop},
    63: {"text": "Moderate Rain", "icon": Icons.water},
    65: {"text": "Heavy Rain", "icon": Icons.umbrella},
    80: {"text": "Rain Showers", "icon": Icons.umbrella_outlined},
    95: {"text": "Thunderstorm", "icon": Icons.flash_on},

  };

  @override
  Widget build(BuildContext context) {

    DateTime utcTime = DateTime.parse(
      forecast?["time"] ?? DateTime.now().toUtc().toIso8601String(),
    ).toLocal();

    String formattedDate = DateFormat("MMM d, hh:mm a").format(utcTime);

    // Temperature
    String tempDisplay = forecast?["temperature_2m"] != null
        ? (forecast!["temperature_2m"] is double
              ? forecast!["temperature_2m"].toStringAsFixed(0)
              : forecast!["temperature_2m"].toString())
        : "--";

    // Weather code
    int code = forecast?["weather_code"] ?? 3;
    String weatherText = weatherMap[code]?["text"] ?? "Unknown";
    IconData weatherIcon = weatherMap[code]?["icon"] ?? Icons.cloud_outlined;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today $formattedDate",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (sunrise != null && sunset != null)
          Text(
            "Sunrise: $sunrise, Sunset: $sunset",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Text( tempDisplay, style: const TextStyle(fontSize: 100)),
                const Positioned(
                  top: 20,
                  right: -40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: Colors.white,
                        size: 13,
                      ),
                      Text("C", style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ),
              ],
            ),
            Transform.rotate(
              angle: 4.7,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(weatherIcon, color: Colors.white, size: 17),
                  const SizedBox(width: 10),
                  Text(weatherText),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
