import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/google_book_model.dart';

class GoogleBooksService {
  static const _baseUrl =
      'https://www.googleapis.com/books/v1/volumes';
  static const _apiKey = 'AIzaSyDXUuD1AJF8azr7A92SLrSTCOD9T_pnMAM';

  Future<List<GoogleBookModel>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      '$_baseUrl?q=${Uri.encodeComponent(query)}&key=$_apiKey&maxResults=20',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch books');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => GoogleBookModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
