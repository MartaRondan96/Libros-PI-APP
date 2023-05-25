import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/models/libro.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LibroService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.37:8080';
  bool isLoading = true;
  List<Libro> libros = [];
  String l = "";
  Libro libro = Libro();
  final storage = const FlutterSecureStorage();

  // GET LIST LIBROS
  Future<List> getListLibros() async {
    libros.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/libros');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<Libro> librosList = decodedResp
        .map((e) => Libro(
              id: e['id'],
              titulo: e['titulo'],
              autor: e['autor'],
              resumen: e['resumen'],
              pag: e['pag'],
              nota: e['nota'],
              imagen: e['imagen'],
              isbn: e['isbn']
            ))
        .toList();
    libros = librosList;

    isLoading = false;
    notifyListeners();

    return librosList;
  }
  
  Future<Libro> getLibros(int id) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/libros/$id');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
   final Map<String, dynamic> decodedResp = json.decode(resp.body);
  Libro libroresp = Libro(
              id: decodedResp['id'],
              titulo: decodedResp['titulo'],
              autor: decodedResp['autor'],
              resumen: decodedResp['resumen'],
              pag: decodedResp['pag'],
              nota: decodedResp['nota'],
              imagen: decodedResp['imagen'],
              isbn: decodedResp['isbn']
    );
           
    libro = libroresp;

    isLoading = false;
    notifyListeners();

    return libroresp;
  }
}