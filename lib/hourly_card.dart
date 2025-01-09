import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyCard({
    super.key,
    required this.time,
    required this.temp,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: 100,
            child: Column(
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Icon(
                  icon,
                  size: 32,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  temp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
