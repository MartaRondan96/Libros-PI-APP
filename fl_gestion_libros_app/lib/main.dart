import 'package:fl_gestion_libros_app/providers/providers.dart';
import 'package:fl_gestion_libros_app/screens/catalogo_screen.dart';
import 'package:fl_gestion_libros_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fl_gestion_libros_app/screens/screens.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => VerifyService(),
          lazy: false,
        ),
        // ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: LoadingScreen(),
      // ignore: avoid_print
      whenOffline: () => LoadingScreen,
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'fl_gestion_libros_app',
        initialRoute: 'login',
        onGenerateRoute: (settings) {
        if (settings.name == 'details') {
          final int id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(idLibro: id),
          );
        }
        if (settings.name == 'comment') {
          final int id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => ComentarioScreen(idLibro: id),
          );
        }
        if (settings.name == 'valoracion') {
          final int id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => ValoracionScreen(idLibro: id),
          );
        }
        return null;
      },
        routes: {
          'home': (_) => const HomeScreen(),
          'login': (_) => LoginScreen(),
          'register': (_) => RegisterScreen(),
          'catalogo_screen': (_) => Catalogo_screen(),
          'fav_screen': (_) => Fav_screen(),
          'update_user_screen': (_) => UpdateUserScreen(),
        },
        scaffoldMessengerKey: NotificationsService.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)),
      ),
    );
  }
}
