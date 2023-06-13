import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_gestion_libros_app/models/models.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class UserService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.41:8080';
  bool isLoading = true;
  String usuario = "";
  User u = User();
  final storage = const FlutterSecureStorage();

  getUserById(int id) async {
    String? token = await AuthService().readToken();
print("DATA");
    print("TOKEN "+ token!);
    final url = Uri.http(_baseUrl, '/all/$id');
    isLoading = true;
    notifyListeners();
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
    int idUser = decodedResp['id'];
    String usernameUser = decodedResp['username'].toString();
    String passwordUser = decodedResp['password'].toString();
    String emailUser = decodedResp['email'].toString();
    bool enabledUser = decodedResp['enabled'];
    String roleUser = decodedResp['surname'].toString();
    String tokenUser = decodedResp['surname'].toString();
    //Crear user

    User us = User(
        id: idUser,
        username: usernameUser,
        password: passwordUser,
        email: emailUser,
        enabled: enabledUser,
        role: roleUser,
        token: tokenUser);
    u = us;
    return us;
  }

  Future<dynamic> getUser() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();

    final url = Uri.http(_baseUrl, '/all/$id');
    isLoading = true;
    notifyListeners();
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
//UPDATE USER
  Future<String?> update(String username, String pass) async {
    String id = await AuthService().readId();
    final Map<String, dynamic> authData = {
      'id': id,
      'username': username,
      'password': pass
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/all/update');

    final resp = await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: encodedFormData);

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (resp.statusCode == 200) {
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return (resp.statusCode.toString());
    } else {
      return (resp.statusCode.toString());
    }
  }
}
