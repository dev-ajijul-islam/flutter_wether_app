import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:wether_app/ui/widgets/blur_bg.dart';

class TenDayForecast extends StatelessWidget {
  final Map<String,dynamic> ? daily;
  const TenDayForecast({super.key,required this.daily});


  String formatWeekday(String isoTime) {
    DateTime dt = DateTime.parse(isoTime);
    return DateFormat('EEE').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return BlurBg(
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
                Text(formatWeekday(date)),
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
    );
  }
}
