class User {
  int? id;
  String? username;
  String? password;
  String? email;
  bool? enabled;
  String? role;
  String? token;
  List<int>? listFavs;
  // List<Null>? comentariosList;
  // List<Null>? listValoraciones;

  User(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.enabled,
      this.role,
      this.token,
      this.listFavs,
      // this.comentariosList,
      // this.listValoraciones
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    enabled = json['enabled'];
    role = json['role'];
    token = json['token'];
    listFavs = json['listFavs'];
    // if (json['comentariosList'] != null) {
    //   comentariosList = <Null>[];
    //   json['comentariosList'].forEach((v) {
    //     comentariosList!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['listValoraciones'] != null) {
    //   listValoraciones = <Null>[];
    //   json['listValoraciones'].forEach((v) {
    //     listValoraciones!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['enabled'] = this.enabled;
    data['role'] = this.role;
    data['token'] = this.token;
    data['listFavs'] = this.listFavs;
    // if (this.comentariosList != null) {
    //   data['comentariosList'] =
    //       this.comentariosList!.map((v) => v.toJson()).toList();
    // }
    // if (this.listValoraciones != null) {
    //   data['listValoraciones'] =
    //       this.listValoraciones!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}