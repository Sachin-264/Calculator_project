import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/Provider/cal_provider.dart';
import '../Constant/colors.dart';
import 'package:flutter/services.dart';

class Button1 extends StatelessWidget {
  const Button1({
    super.key,
    required this.label,
    this.textColor = Colors.black,
  });

  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate sizes based on screen dimensions
    final radius = screenWidth * 0.08; // 10% of screen width for the button radius
    final fontSize = screenWidth * 0.06; // 6% of screen width for the font size
    final elevation = screenWidth * 0.01; // Elevation based on screen width

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.002), // Padding for spacing
      child: InkWell(
        onTap: () {
          HapticFeedback.heavyImpact();
          Provider.of<CalculatorProvider>(context, listen: false).setValue(label);
        },
        child: Material(
          elevation: elevation, // Responsive elevation
          shape: CircleBorder(), // Ensures the button remains circular
          color: AppColors.primaryColor,
          child: CircleAvatar(
            radius: radius, // Responsive radius
            backgroundColor: AppColors.secondaryColor,
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize, // Responsive font size
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
