import 'package:flutter/material.dart';
import 'dart:math';

class InterestPage extends StatefulWidget {
  const InterestPage({super.key});

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  double? _emi;
  double? _totalInterest;
  double? _totalAmount;
  double _principalAmount = 0;
  double _interestAmount = 0;
  double _totalAmountPayable = 0;
  String _tenureType = "Years"; // Default tenure type

  void calculateLoan() {
    // Dismiss the keyboard when the button is pressed
    FocusScope.of(context).unfocus();

    final double principal = double.tryParse(_principalController.text) ?? 0;
    final double annualInterestRate = double.tryParse(_interestController.text) ?? 0;
    final int tenure = int.tryParse(_tenureController.text) ?? 0;

    if (principal <= 0 || annualInterestRate <= 0 || tenure <= 0) {
      setState(() {
        _emi = _totalInterest = _totalAmount = null;
        _principalAmount = 0;
        _interestAmount = 0;
        _totalAmountPayable = 0;
      });
      return;
    }

    final double monthlyInterestRate = annualInterestRate / 12 / 100;
    final int tenureInMonths = _tenureType == "Years" ? tenure * 12 : tenure;

    // EMI Formula: [P x R x (1+R)^N] / [(1+R)^N-1]
    final double emi = (principal * monthlyInterestRate *
        pow(1 + monthlyInterestRate, tenureInMonths)) /
        (pow(1 + monthlyInterestRate, tenureInMonths) - 1);

    final double totalAmount = emi * tenureInMonths;
    final double totalInterest = totalAmount - principal;

    setState(() {
      _emi = emi;
      _totalAmount = totalAmount;
      _totalInterest = totalInterest;
      _principalAmount = principal;
      _interestAmount = totalInterest;
      _totalAmountPayable = totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Principal amount input
                Text(
                  "Principal Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.005),
                TextField(
                  controller: _principalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₹',
                    filled: true,
                    fillColor: Colors.red[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),

                // Interest rate input
                Text(
                  "Annual Interest Rate (%)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.005),
                TextField(
                  controller: _interestController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: '%',
                    filled: true,
                    fillColor: Colors.red[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),

                // Loan tenure input with dropdown for years/months
                Text(
                  "Loan Tenure",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.005),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tenureController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    DropdownButton<String>(
                      value: _tenureType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _tenureType = newValue!;
                        });
                      },
                      items: <String>['Years', 'Months']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.06),

                // Calculate Button
                Center(
                  child: ElevatedButton(
                    onPressed: calculateLoan,
                    child: const Text('Calculate'),
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),

                // Animated Progress Bar for Principal and Interest
                if (_emi != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Principal and Interest Breakdown',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 1000), // Slower animation
                              left: 0,
                              right: (1 - (_principalAmount / _totalAmountPayable)) * 100,
                              top: 0,
                              child: Container(
                                width: double.infinity,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red, // Principal color
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 1000), // Slower animation
                              left: (1 - (_principalAmount / _totalAmountPayable)) * 100,
                              right: 0,
                              top: 0,
                              child: Container(
                                width: double.infinity,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.yellow, // Interest color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.04),

                      // Loan Details
                      Text('EMI: ₹${_emi!.toStringAsFixed(2)}'),
                      Text('Total Interest: ₹${_totalInterest!.toStringAsFixed(2)}'),
                      SizedBox(height: screenWidth * 0.04),

                      // Enhanced Total Amount Payable Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent[100], // Gradient color (You can use any color here)
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5, // Shadow effect
                          ),
                          onPressed: () {
                            // Logic to show total amount
                          },
                          child: Text(
                            'Total Payable: ₹${_totalAmountPayable.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
