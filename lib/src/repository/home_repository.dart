import 'package:bookstore_app_web/src/models/book.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<ResponseBooks> getBooks(int limit, int offset, query) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}get_books_with_pagination?limit=$limit&offset=$offset&search=$query';
  final client = new http.Client();
  final response = await client.get(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  if (response.statusCode == 200) {
    return ResponseBooks.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al cargar los libros');
  }

}

Future<String> deleteBookRepo(int id) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}books/$id';
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  if (response.statusCode == 200) {
    return 'Libro eliminado';
  } else {
    throw Exception('Error al eliminar el libro');
  }
}

Future<String> updateBookRepo( Book book) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}books/${book.id}';
  final client = new http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(book.toJson()),
  );
  if (response.statusCode == 200) {
    return 'Libro actualizado';
  } else {
    throw Exception('Error al actualizar el libro');
  }
}