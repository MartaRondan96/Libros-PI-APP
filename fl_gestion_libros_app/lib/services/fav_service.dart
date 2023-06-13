import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/models/models.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
 
 class FavService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.41:8080';
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
    
    listFavs = decodedResp.map((e) => e as int).toList();
    isLoading = false;
    notifyListeners();
    return decodedResp;
  }

  Future<List> getListLibrosFav() async {
    listLibrosFav.clear();
    // await getListFavs();
    List<dynamic> favs = await getListFavs();
    isLoading = true;
    notifyListeners();
    for (var i in favs) {
      listLibrosFav.add(await libroService.getLibros(i));
    }
    isLoading = false;
    notifyListeners();
    libros = listLibrosFav;
    return listLibrosFav;
  }

  Future delFav(int id) async {
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

  Future addFav(int id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/libros/addFav/$id');

    final resp = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
  }

    getUser() async {
    isLoading = true;
    notifyListeners();
    String? id = await AuthService().readId();
    final url = Uri.http(_baseUrl, '/all/$id');
    String? token = await AuthService().readToken();
    
   print("TOKEN"+ token!);
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    await storage.write(key: 'id', value: decodedResp['id'].toString());
    isLoading = false;
    notifyListeners();
    //Crear user
    String idUser = decodedResp['id'].toString();
    String usernameUser = decodedResp['username'].toString();
    String passwordUser = decodedResp['password'].toString();
    String enabledUser = decodedResp['surname'].toString();
    String roleUser = decodedResp['surname'].toString();
    String tokenUser = decodedResp['surname'].toString();

    User us = User(
        id: int.parse(idUser),
        username: usernameUser,
        password: passwordUser,
    
        enabled: bool.hasEnvironment(enabledUser),
        role: roleUser,
        token: tokenUser);

    return us;
  }
  }