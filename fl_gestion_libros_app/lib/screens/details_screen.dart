import 'package:flutter/material.dart';
import 'package:fl_gestion_libros_app/widgets/widgets.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:http/http.dart';

import 'package:provider/provider.dart';
import '../Models/models.dart';

class DetailsScreen extends StatefulWidget {
  final int idLibro;
  DetailsScreen({required this.idLibro});
  @override
  State<DetailsScreen> createState() => _DetailsScreen_state(idLibro: idLibro);
}

class _DetailsScreen_state extends State<DetailsScreen> {
  _DetailsScreen_state({required this.idLibro});
  final int idLibro;
  final libroService = LibroService();
  final favService = FavService();
  final userService = UserService();
  final commentService = ComentarioService();
  Icon iconito = Icon(Icons.favorite_outline_rounded, color: Colors.white);
  bool f = false;
  List<bool> isChecked = [];
  List<dynamic> listFavs = [];
  List<Comentario> listComments = [];
  List<String> listUsername = [];
  User user = User();

  Future<Libro> getLibro() async {
    await libroService.getLibros(idLibro);
    return libroService.libro;
  }

  Future<void> getListFav() async {
    await favService.getListFavs();
    setState(() {
      listFavs = favService.listFavs;
    });
  }

  Future<void> getListComments() async {
    await commentService.getListComentarios(idLibro);

    setState(() {
      listComments = commentService.comentarios;
      listUsername = commentService.listUsers;
    });
  }

  void getCheck() {
    setState(() {
      if (listFavs.contains(idLibro)) {
        iconito = Icon(Icons.heart_broken_rounded, color: Colors.white);
        f = true;
      } else {
        iconito = Icon(Icons.favorite_outline_rounded, color: Colors.white);
        f = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getListFav().then((value) => getCheck());
    getListComments();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(72, 71, 75, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Favoritos'),
              IconButton(
                icon: const Icon(Icons.add_chart_rounded),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'valoracion',
                      arguments: idLibro);
                },
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'catalogo_screen');
            },
          ),
        ),
        body: Background(
          child: FutureBuilder<Libro>(
            future: getLibro(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se obtienen los datos
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Maneja cualquier error que pueda ocurrir durante la obtención de datos
                return Center(child: Text('Error al obtener los datos'));
              } else if (snapshot.hasData) {
                // Los datos se han obtenido correctamente
                final Libro libro = snapshot.data!;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FadeInImage(
                                  placeholder:
                                      AssetImage('assets/no-image.jpg'),
                                  image: AssetImage('assets/${libro.imagen!}'),
                                  height: 200,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      libro.titulo!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    libro.autor!,
                                    style: textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 18, color: Colors.yellow),
                                      SizedBox(width: 5),
                                      Text(libro.nota!.toStringAsFixed(2),
                                          style: textTheme.bodyMedium),
                                      SizedBox(width: 20),
                                      Text(
                                          "Páginas: " +
                                              libro.pag!.toStringAsFixed(0),
                                          style: textTheme.bodyMedium)
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Resumen",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            libro.resumen!,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.pink,
                              backgroundColor: Colors.white60),
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, 'comment',
                              arguments: idLibro),
                          child: Text('Añadir comentario'),
                        ),
                      ]),
                    ),
                    SliverFillRemaining(
                      child: ListView.separated(
                        itemCount: listComments.length,
                        itemBuilder: (context, index) => ListTile(
                            leading: const Icon(
                              Icons.comment_rounded,
                              size: 30,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              "Autor: " + listUsername[index],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 2),
                                Text(listComments[index].comentario!),
                              ],
                            )),
                        separatorBuilder: (_, __) => const Divider(),
                      ),
                    )
                  ],
                );
              } else {
                // No hay datos disponibles
                return Center(child: Text('No hay datos disponibles'));
              }
            },
          ),
        ),
        floatingActionButton: RawMaterialButton(
          onPressed: () {
            if (f) {
              favService.delFav(idLibro);
            } else {
              favService.addFav(idLibro);
            }
            getCheck();
            Navigator.pushReplacementNamed(context, 'details',
                arguments: idLibro);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Colors.pink,
          child: iconito,
          constraints: BoxConstraints.tightFor(
            width: 40.0,
            height: 40.0,
          ),
        ));
  }
}
