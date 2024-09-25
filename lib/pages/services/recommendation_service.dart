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
      var requestBody = jsonEncode({
        'skinTone': skinTone,
        'skinType': skinType,
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Assume the API returns a list of recommended product names
        List<String> recommendedProducts = List<String>.from(data['products']);

        // Optional: You can redirect to the main website if needed
        await _redirectToShafn();

        return recommendedProducts;
      } else {
        logger.e(
            "Failed to load recommendations, status code: ${response.statusCode}");
        throw Exception("Failed to load recommendations");
      }
    } catch (e) {
      logger.e("Error occurred while fetching recommendations: $e");
      return [];
    }
  }

  // Method to redirect to the main website
  Future<void> _redirectToShafn() async {
    final Uri url = Uri.parse('https://shafn.com');

    if (await canLaunchUrl(url)) {
      await launchUrl(url,
          mode: LaunchMode
              .externalApplication); // Opens the browser and redirects to the given URL
    } else {
      logger.e('Could not launch $url');
    }
  }
}
