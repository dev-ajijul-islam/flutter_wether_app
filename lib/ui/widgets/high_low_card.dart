import 'package:flutter/material.dart';
import 'package:wether_app/ui/widgets/blur_bg.dart';

class HighLowCard extends StatelessWidget {
  final  Map<String,dynamic>?  daily;
  const HighLowCard({
    super.key,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {



    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlurBg(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.keyboard_double_arrow_up,
                  color: Colors.greenAccent,
                  size: 18,
                ),
                Text(
                  "${daily?["temperature_2m_max"][0].toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.circle_outlined,
                  size: 8,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          VerticalDivider(color: Colors.white70),
          BlurBg(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.keyboard_double_arrow_down,
                  color: Colors.redAccent,
                  size: 18,
                ),
                Text(
                  "${daily?["temperature_2m_min"][0].toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.circle_outlined,
                  size: 8,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
