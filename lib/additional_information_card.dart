import 'package:flutter/material.dart';

class AdditionalInformationCard extends StatelessWidget{
  final IconData icon;
  final String status;
  final dynamic value;

  const AdditionalInformationCard({
    super.key,
    required this.icon,
    required this.status,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        const SizedBox(height: 8),
        Text(
          status,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

