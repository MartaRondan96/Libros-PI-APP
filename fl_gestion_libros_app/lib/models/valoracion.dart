class Valoracion {
  int? id;
  int? idUsuario;
  int? idLibro;
  int? puntos;

  Valoracion({this.id, this.idUsuario, this.idLibro, this.puntos});

  Valoracion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUsuario = json['idUsuario'];
    idLibro = json['idLibro'];
    puntos = json['puntos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUsuario'] = this.idUsuario;
    data['idLibro'] = this.idLibro;
    data['puntos'] = this.puntos;
    return data;
  }
}