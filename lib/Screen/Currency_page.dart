import 'package:flutter/material.dart';
import '../Provider/fetchConversionRate.dart'; // Import your standalone function

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  String selectedCurrency = 'INR'; // Default selected currency
  final List<String> currencies = ['INR', 'EUR', 'GBP', 'JPY', 'USD'];
  bool isExpanded = false; // To track if the summary box is expanded
  bool isLoading = false; // To show a loading indicator during API fetch
  double enteredAmount = 0; // Amount entered by the user
  double conversionRate = 1; // Default conversion rate (1 USD = 1 USD)
  double convertedAmount = 0; // Calculated amount

  // Function to fetch and update conversion rates
  Future<void> updateConversionRate() async {
    print('Fetching conversion rate for $selectedCurrency...');
    try {
      final rate = await fetchConversionRate(selectedCurrency);
      print('Fetched rate: $rate');
      setState(() {
        conversionRate = rate;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching conversion rate: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    updateConversionRate(); // Fetch the initial conversion rate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView( // Allow scrolling when keyboard is open
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centered column
            children: [
              // Input Amount Row
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/flags/usd.png'), // USD flag
                    radius: 15,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Enter Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          enteredAmount = double.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Loading Indicator or Summary Box
              isLoading
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded; // Toggle expansion
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300), // Smooth animation
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  alignment: Alignment.center, // Center the content
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2), // Background color
                    borderRadius: BorderRadius.circular(30), // Pill shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  width: isExpanded ? 250 : 150, // Expand width when clicked
                  height: 50, // Fixed height for pill
                  child: isExpanded
                      ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Prevent overflow horizontally
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Showing Conversion Rate
                        Text(
                          '1 USD = $conversionRate $selectedCurrency',
                          style: const TextStyle(
                            fontSize: 12, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                      : const Text(
                    'Unit Converter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Dropdown for Selecting Target Currency
              DropdownButtonFormField<String>(
                value: selectedCurrency,
                items: currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/flags/${currency.toLowerCase()}.png'),
                          radius: 15,
                        ),
                        const SizedBox(width: 10),
                        Text(currency),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value!;
                    isExpanded = false; // Reset expanded state when currency changes
                    updateConversionRate(); // Fetch conversion rate for new currency
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Target Currency',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Calculate Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Hide keyboard when button is pressed
                    FocusScope.of(context).requestFocus(FocusNode());

                    setState(() {
                      // Calculate converted amount
                      convertedAmount = enteredAmount * conversionRate;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: Colors.red[300], // Button color
                  ),
                  child: const Text(
                    'Calculate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Result Box (Converted amount in a new line)
              if (convertedAmount > 0)
                Container(
                  padding: const EdgeInsets.all(20), // Adjusted padding
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity, // Ensure it takes the full width
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conversion Result',
                        style: TextStyle(
                          fontSize: 18, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Entered Amount (Truncated with ellipsis if too long)
                      Text(
                        'Entered Amount: ${enteredAmount.toStringAsFixed(2)} USD',
                        style: const TextStyle(fontSize: 14), // Reduced font size
                        softWrap: true, // Allow wrapping if text overflows
                        overflow: TextOverflow.ellipsis, // Handle long text overflow
                      ),
                      const SizedBox(height: 10),
                      // Converted Amount (Truncated with ellipsis if too long)
                      const Text(
                        'Converted Amount:',
                        style: TextStyle(
                          fontSize: 14, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${convertedAmount.toStringAsFixed(2)} $selectedCurrency',
                        style: TextStyle(
                          fontSize: 14, // Reduced font size
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                        softWrap: true, // Allow wrapping if text overflows
                        overflow: TextOverflow.ellipsis, // Handle long text overflow
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
