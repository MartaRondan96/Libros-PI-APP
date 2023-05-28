import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fl_gestion_libros_app/widgets/widgets.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import '../models/models.dart';
import '../widgets/background.dart';

class Fav_screen extends StatefulWidget {
  const Fav_screen({Key? key}) : super(key: key);

  @override
  State<Fav_screen> createState() => _Fav_screenState();
}

class _Fav_screenState extends State<Fav_screen> {
  final favService = FavService();

  List<Libro> libros = [];

  Libro libro = Libro();
  String user = "";
  int cont = 0;
  bool desactivate = true;

  Future getLibrosFav() async {
    await favService.getListLibrosFav();
    setState(() {
      libros = favService.libros;
    });
  }

  @override
  void initState() {
    super.initState();

    getLibrosFav();
  }
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
     void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'catalogo_screen');
      } else {
        Navigator.pushReplacementNamed(context, 'fav_screen');
        }
        }
    return Scaffold(
      appBar: AppBar(
        title: Text('Libros favoritos'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined))
        ],
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Swiper(
          itemCount: libros.length,
          layout: SwiperLayout.STACK,
          itemWidth: size.width * 0.6,
          itemHeight: size.height * 0.4,
          itemBuilder: (context, index) {
            String image='assets/'+libros[index].imagen!;
            return GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, 'details',arguments: libros[index].id),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: 
                  FadeInImage(
                    placeholder: const AssetImage('assets/no-image.jpg'),
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
      
              ),
            );
          },
      
        ),
          ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
         BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'Libros'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favoritos'),
        ],
        currentIndex: 1, //New
        onTap: _onItemTapped,
      ),
    );
  }
}