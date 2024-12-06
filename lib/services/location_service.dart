import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  Future<List<String>> fetchRecommendedLocations(double latitude, double longitude) async {
    final String url =
        'https://nominatim.openstreetmap.org/search?format=json&q=restaurant&limit=5&lat=$latitude&lon=$longitude';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': 'YourAppName', // Add a user agent to comply with Nominatim's terms
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((result) => result['display_name'] as String).toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (error) {
      print('Error fetching locations: $error');
      return ['Error fetching locations'];
    }
  }
}
