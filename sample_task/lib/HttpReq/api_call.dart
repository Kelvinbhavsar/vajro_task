import 'package:Vajro/Model/apiResp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepository {
  final String _apiUrl =
      'https://run.mocky.io/v3/8b6db10f-15ac-48df-b803-384ab584ee9d';

  // Cache key
  static const String _articlesCacheKey = 'articles_cache';

  Future<List<Article>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Cache the successful response
        _cacheData(response.body);

        if (jsonData['status'] == 'success') {
          final List<dynamic> articlesData = jsonData['articles'];
          return articlesData
              .map((articleJson) => Article.fromJson(articleJson))
              .toList();
        } else {
          throw Exception('API returned an unsuccessful status.');
        }
      } else {
        // Try to load from cache if the network request fails
        return _loadDataFromCache();
      }
    } catch (e) {
      // If both network and cache fail
      return _loadDataFromCache();
    }
  }

  Future<void> _cacheData(String responseData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_articlesCacheKey, responseData);
  }

  Future<List<Article>> _loadDataFromCache() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_articlesCacheKey);

      if (cachedData != null) {
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        if (jsonData['status'] == 'success') {
          final List<dynamic> articlesData = jsonData['articles'];
          return articlesData
              .map((articleJson) => Article.fromJson(articleJson))
              .toList();
        } else {
          throw Exception(
              'Cached data has unsuccessful status.'); // or handle differently
        }
      } else {
        throw Exception(
            'No cached data available.'); // Or return an empty list if that's preferred
      }
    } catch (e) {
      // Handle any exceptions that might occur during cache loading
      print("Error loading from cache: $e");
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }
}
