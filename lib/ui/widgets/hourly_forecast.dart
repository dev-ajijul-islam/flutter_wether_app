import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wether_app/ui/widgets/blur_bg.dart';

class HourlyForecast extends StatelessWidget {
  final Map<String,dynamic>? hourly;
  const HourlyForecast({super.key,required this.hourly});



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
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return BlurBg(
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
    );
  }
}
