import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/gutenberg_book_model.dart';
import '../utils/network_helper.dart';

class GutenbergService {
  static const String _baseUrl = 'https://gutendex.com/books';

  /// Search for books on Project Gutenberg via Gutendex API
  /// Returns a list of books with downloadable formats (PDF, EPUB, TXT)
  static Future<List<GutenbergBookModel>> searchBooks(String query) async {
    if (!await NetworkHelper.hasConnection()) {
      throw NetworkException('No internet connection');
    }

    try {
      final url = Uri.parse(
        _baseUrl,
      ).replace(queryParameters: {'search': query, 'limit': '20'});

      debugPrint('Gutenberg Search URL: $url');

      final response = await http.get(url);

      debugPrint('Gutenberg Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Gutenberg Response Data keys: ${data.keys.toList()}');

        final results = data['results'] as List?;
        debugPrint('Gutenberg Results count: ${results?.length ?? 0}');

        if (results == null || results.isEmpty) {
          debugPrint('Gutenberg: No results found');
          return [];
        }

        final books = <GutenbergBookModel>[];
        for (final result in results) {
          try {
            debugPrint('Processing book: ${result['title']}');

            final book = GutenbergBookModel.fromJson(result);

            debugPrint(
              'Book: ${book.title}, has URL: ${book.bestReadUrl != null}',
            );

            // Gutenberg books almost always have downloadable formats
            books.add(book);
          } catch (e) {
            debugPrint('Error processing book: $e');
            continue;
          }
        }

        debugPrint('Gutenberg: Returning ${books.length} books');
        return books;
      } else {
        debugPrint('Gutenberg Error: Status ${response.statusCode}');
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Gutenberg Exception: $e');
      if (e is NetworkException) rethrow;
      throw Exception('Search failed: $e');
    }
  }
}
