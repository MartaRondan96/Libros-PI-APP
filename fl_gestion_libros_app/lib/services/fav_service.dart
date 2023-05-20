import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/models/libro.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
 
 class FavService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.39:8080';
  final libroService = LibroService();
  bool isLoading = true;
  List<Libro> libros = [];
  String l = "";
  Libro libro = Libro();
  
  List<int> listFavs = [];
  List<Libro> listLibrosFav = [];

  final storage = const FlutterSecureStorage();

 
 Future<dynamic> getListFavs() async {
    listFavs.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/libros/getFavs');
    String? token = await AuthService().readToken();

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);
    print("DECODEDRESP EN GETLISTFAV");
    print(decodedResp);
    // listFavs = decodedResp.map((e) => int.parse(e)).toList();
    isLoading = false;
    notifyListeners();

    return decodedResp;
  }

  Future<List> getListLibrosFav() async {
    listLibrosFav.clear();
    // await getListFavs();
    List<dynamic> favs = await getListFavs();;
    print('Lista favs');
    print(favs);
    isLoading = true;
    notifyListeners();
    for (var i in favs) {
      print("BUCLE");
      print(await libroService.getLibros(i));
      listLibrosFav.add(await libroService.getLibros(i));
    }
    isLoading = false;
    notifyListeners();
    print(libros);
    libros = listLibrosFav;
    return listLibrosFav;
  }

  Future delFav(String id) async {
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/libros/deleteFav/$id');
    final resp = await http.put(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (resp.statusCode == 200) {}
  }

    Future addFav(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/libros/addFav/$id');

    final resp = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
  }
  }