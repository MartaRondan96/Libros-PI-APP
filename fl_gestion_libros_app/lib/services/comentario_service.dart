import 'dart:convert';
import 'package:fl_gestion_libros_app/models/comentario.dart';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/models/libro.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/models.dart'; 
 
 class ComentarioService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.40:8080';
  final libroService = LibroService();
   final userService = UserService();
  bool isLoading = true;
  List<Comentario> comentarios = [];
  String l = "";
  Libro libro = Libro();
List<String> listUsers = [];

  final storage = const FlutterSecureStorage();

    Future addComment(int idLibro, String comentario) async {
      String? token = await AuthService().readToken();

      isLoading = true;
      notifyListeners();
      final Map<String, dynamic> commentData = {
        'comentario': comentario,
        'idLibro': idLibro,
      };
      final url = Uri.http(_baseUrl, '/api/libros/comentario');

      final resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"},
        body:  json.encode(commentData)
      );
      isLoading = false;
      notifyListeners();
      return resp.statusCode.toString();
    }


    // GET LIST COMENTARIOS
  Future<List> getListComentarios(int idLibro) async {
    comentarios.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/libros/comentario/$idLibro');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<Comentario> comentariosList = decodedResp
        .map((e) => Comentario(
              id: e['id'],
              idUsuario: e['idUsuario'],
              idLibro: e['idLibro'],
              comentario: e['comentario']
            ))
        .toList();
    comentarios = comentariosList;
    for (int i = 0; i < comentarios.length; i++) {
      User us = await userService.getUserById(comentarios[i].idUsuario!);
      listUsers.add(us.username!);
    }
    isLoading = false;
    notifyListeners();

    return comentariosList;
  }
}