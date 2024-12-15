import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> fetchConversionRate(String targetCurrency) async {
  const String apiKey = 'bd3fed8c8ec2fde9eb0a55e0';  // Replace with your actual API key
  const String baseCurrency = 'USD'; // The base currency

  // Corrected URL format (no extra /USD at the end)
  final url = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/$baseCurrency';

  try {
    final response = await http.get(Uri.parse(url));  // Send the GET request

    if (response.statusCode == 200) {
      final data = json.decode(response.body);  // Parse the response
      return data['conversion_rates'][targetCurrency] ?? 1.0;  // Return the conversion rate
    } else {
      print('Failed to fetch conversion rate: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch conversion rate.');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch conversion rate.');
  }
}
