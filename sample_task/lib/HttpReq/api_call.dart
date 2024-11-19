import 'package:Vajro/Model/apiResp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Import your API model

class ApiRepository {
  final String _apiUrl =
      'https://run.mocky.io/v3/8b6db10f-15ac-48df-b803-384ab584ee9d';

  Future<List<Article>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          final List<dynamic> articlesData = jsonData['articles'];
          return articlesData
              .map((articleJson) => Article.fromJson(articleJson))
              .toList();
        } else {
          throw Exception('API returned an unsuccessful status.');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
