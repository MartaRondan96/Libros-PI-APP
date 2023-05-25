import 'package:flutter/material.dart';
import 'package:fl_gestion_libros_app/widgets/widgets.dart';
import 'package:fl_gestion_libros_app/services/services.dart';

import 'package:provider/provider.dart';
import '../Models/models.dart';

class DetailsScreen extends StatefulWidget {
  final int idLibro;

  DetailsScreen({required this.idLibro});

  @override
  State<DetailsScreen> createState() => _DetailsScreen_state(idLibro: idLibro);
}

class _DetailsScreen_state extends State<DetailsScreen> {
  final int idLibro;
  final libroService = LibroService();
  final favService = FavService();
  final commentService = ComentarioService();

  Icon iconito=Icon(Icons.favorite_outline_rounded, color: Colors.white);
  bool f =false;
  List<bool> isChecked = [];
  List<dynamic> listFavs = [];
  List<Comentario> listComments = [];
  _DetailsScreen_state({required this.idLibro});

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
    });
  }
  void getCheck()  {
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
      body: SingleChildScrollView(
        child: Column(
        children: [
          FutureBuilder<Libro>(
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
                    SliverAppBar(
          backgroundColor: Colors.indigo,
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: EdgeInsets.all(0),
            title: Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 10),
              color: Colors.black12,
              child: Text(
              libro.titulo!,
                style: TextStyle(fontSize: 16),
              ),
            ),
            background: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage('https://via.placeholder.com/500x300'),
              fit: BoxFit.cover,
            ),
          ),
    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        //Poster and title
                        Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FadeInImage(
                                placeholder: AssetImage('assets/no-image.jpg'),
                                image: AssetImage('assets/'+libro.imagen!),
                                height: 200,
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  libro.titulo!,
                                  style: textTheme.headline5,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  libro.autor!,
                                  style: textTheme.subtitle1,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star_outline, size: 15, color: Colors.grey),
                                    SizedBox(width: 5),
                                    Text(libro.nota!.toString(), style: textTheme.caption)
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //Resumen del libro
                       Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          libro.resumen!,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      ]),
                    ),
                  ],
                );

              } else {
                // No hay datos disponibles
                return Center(child: Text('No hay datos disponibles'));
              }
            },
          ),
                TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue
          ),
          onPressed: () => Navigator.pushNamed(context, 'comment', arguments: idLibro),
          child: Text('Añadir comentario'),
        ),
          ListView.separated(
        itemCount: listComments.length,
        itemBuilder: (context, index) => ListTile(
            leading: const Icon(
              Icons.favorite,
              size: 30,
            ),
            contentPadding: const EdgeInsets.all(16),
            title: Text("Autor" + 
              listComments[index].user.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        ],
      ),),
      floatingActionButton: RawMaterialButton(
          onPressed: () {
              if (f) {
                favService.delFav(idLibro);
                Navigator.pushReplacementNamed(context, 'details',arguments: idLibro);
              } else {
                favService.addFav(idLibro);
                Navigator.pushReplacementNamed(context, 'details',arguments: idLibro);
              }
              getListFav();
            // Provider.of<FavService>(context, listen: false).addFav(idLibro);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Colors.blue,
          child:  iconito,
          constraints: BoxConstraints.tightFor(
            width: 40.0,
            height: 40.0,
          ),
        )
    );
  }
}