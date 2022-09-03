import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  Widget tile(String key, String value) {
    return ListTile(
      title: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      subtitle: Text(
        key,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Emergency Info: ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Your emergency contact has been notified through sms and a call.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            tile("Emergency Contact", "6303663432"),
            tile("Blood Group", "O+"),
            tile("Health Condition", "Diabetic"),
            tile("Address", "H.No: 87/6, Arora Nagar, Kurnool, Andhra Pradesh"),
          ],
        ),
      ),
    );
  }
}
