import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:project/Constant/colors.dart';
import 'package:project/Provider/cal_provider.dart';
import 'package:project/widgets/Text_FIeld.dart';
import '../widgets/Calculator button.dart';
import 'Currency_page.dart';
import  'Interest _Page.dart';
import '../widgets/Button1.dart';
import '../widgets/List_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController; // Controller for PageView
  int _currentPage = 0; // Track current page index

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    FocusManager.instance.primaryFocus?.unfocus(); // Unfocus any active input
  }


  // Function to change page based on icon button pressed
  // Function to change page with smooth keyboard dismissal
  void _onIconButtonPressed(int index) async {
    // Unfocus the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Wait for keyboard to dismiss before navigating
    await Future.delayed(const Duration(milliseconds: 200));

    // Smoothly animate to the specified page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  // UI (user interface)
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final decoration = const BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    );

    final paddings = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05, // 5% of screen width
      vertical: screenHeight * 0.02, // 2% of screen height
    );

    return Consumer<CalculatorProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.15, // 15% of screen height for app bar
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(200, 100),
              ),
            ),
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.elliptical(200, 100),
              ),
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/Image/watercolor.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.000009, sigmaY: 0.0008),
                      child: Container(
                        color: Colors.red.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1, // 10% from the left
                    top: screenHeight * 0.07, // 7% from the top
                    child: _buildIconButton(
                      Icons.interests_rounded,
                      _currentPage == 1 ? Colors.blue : Colors.black,
                          () {
                        HapticFeedback.heavyImpact();
                        _onIconButtonPressed(1);
                      },
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.1, // 10% from the right
                    top: screenHeight * 0.07, // 7% from the top
                    child: _buildIconButton(
                      Icons.currency_exchange_rounded,
                      _currentPage == 2 ? Colors.blue : Colors.black,
                          () {
                        HapticFeedback.heavyImpact();
                        _onIconButtonPressed(2);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: screenWidth / 2 - 20, // Centered horizontally
                    child: _buildIconButton(
                      Icons.calculate_outlined,
                      _currentPage == 0 ? Colors.blue : Colors.black,
                          () {
                        HapticFeedback.heavyImpact();
                        _onIconButtonPressed(0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // Calculator Page (Default Home Page)
              Column(
                children: [
                  Expanded(
                    flex: 2, // Decreased CustomTextWidget height
                    child: CustomTextWidget(controller: provider.compController),
                  ),
                  Expanded(
                    flex: 4, // Increased button container height
                    child: Container(
                      width: double.infinity,
                      decoration: decoration,
                      padding: paddings,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // First row of buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) => Expanded(child: ButtonList[index])),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Dynamic spacing
                          // Second row of buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) => Expanded(child: ButtonList[index + 4])),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Dynamic spacing
                          // Third row of buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) => Expanded(child: ButtonList[index + 8])),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Dynamic spacing
                          // Last row of buttons with aligned Calculator button
                          Row(
                            children: [
                              // Use Expanded for the other buttons to match height
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(3, (index) => Expanded(child: ButtonList[index + 12])),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(3, (index) => Expanded(child: ButtonList[index + 15])),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04), // Add spacing for button alignment
                              // Ensure Calculator button is aligned with the row height
                              Container(
                                height: screenHeight * 0.155, // Use the same height as the other buttons
                                width: screenWidth * 0.175, // Adjust width if necessary
                                decoration: BoxDecoration(
                                  color: AppColors.fifthColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Calculatorbutton(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // InterestPage as a child of PageView
              const InterestPage(),
              // CurrencyPage as a child of PageView
              const CurrencyPage(), // Make sure CurrencyPage is defined
            ],
          ),
        );
      },
    );
  }

  // Helper function to build the icon button with uniform styling
  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 35, color: color),
      ),
    );
  }
}
