class Libro {
  int? id;
  String? titulo;
  String? autor;
  String? resumen;
  int? pag;
  double? nota;
  String? imagen;
  // List<Null>? comentariosList;
  // List<Null>? listValoraciones;
  String? isbn;

  Libro(
      {this.id,
      this.titulo,
      this.autor,
      this.resumen,
      this.pag,
      this.nota,
      this.imagen,
      // this.comentariosList,
      // this.listValoraciones,
      this.isbn});

  Libro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    autor = json['autor'];
    resumen = json['resumen'];
    pag = json['pag'];
    nota = json['nota'];
    imagen = json['imagen'];
    if (json['comentariosList'] != null) {
      // comentariosList = <Null>[];
      json['comentariosList'].forEach((v) {
        // comentariosList!.add(new Null.fromJson(v));
      });
    }
    if (json['listValoraciones'] != null) {
      // listValoraciones = <Null>[];
      json['listValoraciones'].forEach((v) {
        // listValoraciones!.add(new Null.fromJson(v));
      });
    }
    isbn = json['isbn'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['titulo'] = this.titulo;
  //   data['autor'] = this.autor;
  //   data['pag'] = this.pag;
  //   data['nota'] = this.nota;
  //   data['imagen'] = this.imagen;
  //   // if (this.comentariosList != null) {
  //   //   data['comentariosList'] =
  //   //       // this.comentariosList!.map((v) => v.toJson()).toList();
  //   // }
  //   // if (this.listValoraciones != null) {
  //   //   data['listValoraciones'] =
  //   //       this.listValoraciones!.map((v) => v.toJson()).toList();
  //   // }
  //   // data['isbn'] = this.isbn;
  //   // return data;
  // }
}