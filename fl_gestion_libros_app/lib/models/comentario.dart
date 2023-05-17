import 'package:fl_gestion_libros_app/models/models.dart';
class Comentario {
  int? id;
  String? comentario;
  User? user;
  Libro? libro;

  Comentario({this.id, this.comentario, this.user, this.libro});

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comentario = json['comentario'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    libro = json['Libro'] != null ? new Libro.fromJson(json['Libro']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comentario'] = this.comentario;
    // if (this.user != null) {
    //   data['User'] = this.user!.toJson();
    // }
    // if (this.libro != null) {
    //   data['Libro'] = this.libro!.toJson();
    // }
    return data;
  }
}