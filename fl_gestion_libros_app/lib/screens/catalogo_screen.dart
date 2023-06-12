import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fl_gestion_libros_app/widgets/widgets.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../widgets/background.dart';

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
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'catalogo_screen');
      } else {
        Navigator.pushReplacementNamed(context, 'fav_screen');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(201, 175, 240, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.login_outlined),
              color: Color.fromRGBO(0, 0, 0, 1),
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
            Text('Catálogo de libros'),
            IconButton(
              icon: const Icon(Icons.account_circle_sharp),
              color: Color.fromRGBO(0, 0, 0, 1),
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, 'update_user_screen');
              },
            ),
          ],
        ),
        elevation: 0,
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined))
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
                    String image = 'assets/' + libros[index].imagen!;
                    return GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, 'details',
                          arguments: libros[index].id),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage(
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
        backgroundColor:  Color.fromRGBO(192, 152, 252, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Libros'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favoritos'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }
}
