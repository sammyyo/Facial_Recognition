import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationService {
  final String apiUrl = "https://api.shafn.com/wp-json/wc/v3/products";
  var logger = Logger();

  Future<List<String>> getRecommendations(
      String skinTone, String skinType) async {
    try {
      // Create request body with skin tone and skin type
      var requestBody = jsonEncode({
        'skinTone': skinTone,
        'skinType': skinType,
      });

      // Send the POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      // Check for success response
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Assume the API returns a list of recommended product names
        List<String> recommendedProducts = List<String>.from(data['products']);

        // Optionally redirect to main website (optional, remove if not needed)
        await _redirectToShafn();

        return recommendedProducts;
      } else {
        // Log error details
        logger.e("Failed to load recommendations, status code: ${response.statusCode}");
        throw Exception("Error ${response.statusCode}: Unable to load recommendations");
      }
    } catch (e) {
      // Catch and log the error
      logger.e("Error occurred while fetching recommendations: $e");
      return Future.error("Failed to fetch recommendations. Please try again.");
    }
  }

  // Optional: Method to redirect to the main website
  Future<void> _redirectToShafn() async {
    final Uri url = Uri.parse('https://shafn.com');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      logger.e('Could not launch $url');
    }
  }
}
