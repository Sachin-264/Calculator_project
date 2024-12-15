import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:provider/provider.dart';
import 'package:project/Provider/cal_provider.dart';
import '../Constant/colors.dart';

class Calculatorbutton extends StatefulWidget {
  const Calculatorbutton({super.key});

  @override
  State<Calculatorbutton> createState() => _CalculatorbuttonState();
}

class _CalculatorbuttonState extends State<Calculatorbutton> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes
    final buttonHeight = screenHeight * 0.155; // 20% of screen height
    final buttonWidth = screenWidth * 0.3; // Adjust width as needed
    final fontSize = screenWidth * 0.08; // 8% of screen width

    return InkWell(
      onTap: () {
        // Trigger haptic feedback
        HapticFeedback.heavyImpact();

        // Call the Provider method to set the value
        Provider.of<CalculatorProvider>(context, listen: false).setValue("=");
      },
      child: Container(
        height: buttonHeight, // Responsive height
        width: buttonWidth, // Responsive width
        decoration: BoxDecoration(
          color: AppColors.fifthColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '=',
            style: TextStyle(
              fontSize: fontSize, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
