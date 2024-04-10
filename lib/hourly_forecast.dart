import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecast({
    required this.time,
    required this.icon,
    required this.temp,
    super.key
  }) ;

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            Text(time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8,),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8,),
            Text(temp,),
          ],
        ),
      ),
    );
  }
}