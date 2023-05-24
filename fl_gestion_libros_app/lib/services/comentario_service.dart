import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/models/libro.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
 
 class ComentarioService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.40:8080';
  final libroService = LibroService();
  bool isLoading = true;
  List<Libro> libros = [];
  String l = "";
  Libro libro = Libro();

  final storage = const FlutterSecureStorage();

 
 
  }