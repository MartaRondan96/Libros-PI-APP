import 'package:fl_gestion_libros_app/models/models.dart';
class Comentario {
  String? id;
  int? idUsuario;
  String? comentario;
  int? idLibro;

  Comentario({this.id, this.idUsuario, this.comentario, this.idLibro});

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUsuario = json['idUsuario'];
    comentario = json['comentario'];
    idLibro = json['idLibro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUsuario'] = this.idUsuario;
    data['comentario'] = this.comentario;
    data['idLibro'] = this.idLibro;
    return data;
  }
}