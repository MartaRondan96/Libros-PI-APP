import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fl_gestion_libros_app/widgets/widgets.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import '../models/libro.dart';

class Catalogo_screen extends StatefulWidget {
  const Catalogo_screen({Key? key}) : super(key: key);

  @override
  State<Catalogo_screen> createState() => _Catalogo_screenState();
}

class _Catalogo_screenState extends State<Catalogo_screen> {
  final libroService = LibroService();

  List<Libro> libros = [];

  Libro libro = Libro();
  String user = "";
  int cont = 0;
  bool desactivate = true;

  Future getLibros() async {
    await libroService.getListLibros();
    setState(() {
      libros = libroService.libros;
      // for (int i = 0; i < appointments.length; i++) {
      //   appointmentBuscar
      //       .removeWhere((element) => (element.id == appointments[i].id));
      // }
    });
  }

  @override
  void initState() {
    super.initState();

    getLibros();
  }
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogo de libros'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: 20,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-instance'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: 
                const FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: AssetImage('assets/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
            ),
          );
        },
      ),
    ),
            MovieSlider(),
          ],
        ),
      ),
    );
  }
}