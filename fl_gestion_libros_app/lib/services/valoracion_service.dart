import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
 
 class ValoracionService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.40:8080';
  bool isLoading = true;

  final storage = const FlutterSecureStorage();

 Future addValoracion(int idLibro, String valoracion) async {
      String? token = await AuthService().readToken();

      isLoading = true;
      notifyListeners();
      final Map<String, dynamic> valoracionData = {
        'idLibro': idLibro,
        'puntos' : valoracion
      };
      final url = Uri.http(_baseUrl, '/api/libros/addNota');

      final resp = await http.post(
        url,
        headers: {"Authorization": "Bearer $token"},
        body:  json.encode(valoracionData)
      );
      return resp.statusCode.toString();
    }
 
  }