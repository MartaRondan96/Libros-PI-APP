import 'package:fl_gestion_libros_app/models/models.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class ComentarioScreen extends StatefulWidget {
  final int idLibro;
  const ComentarioScreen({required this.idLibro});

  @override
  State<ComentarioScreen> createState() => _ComentarioScreen(idLibro: idLibro);
}

class _ComentarioScreen extends State<ComentarioScreen> {
  final int idLibro;

  _ComentarioScreen({required this.idLibro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Comentario: ',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => ComentarioFormProvider(),
                      child: _Form(idLibro: idLibro))
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'details', arguments: idLibro),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: Text(
                    'Atrás',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
              SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class _Form extends StatefulWidget {
  final int idLibro;
  const _Form({required this.idLibro});

  @override
  State<_Form> createState() => __Form(idLibro: idLibro);
}

class __Form extends State<_Form> {
  final int idLibro;
  __Form({required this.idLibro});

  final userService = UserService();
  User user = User();

  Future getUser() async {
    await userService.getUser();
    User us = await userService.getUser();
    setState(() {
      user = us;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final commentForm = Provider.of<ComentarioFormProvider>(context);
    final comentarioService = ComentarioService();
    return Container(
      child: Form(
        key: commentForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'comentario',
                  labelText: 'comentario',
                  prefixIcon: Icons.comment_rounded),
              onChanged: (value) => commentForm.comentario = value,
              maxLines: null,
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.pink,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      commentForm.isLoading ? 'Espera' : 'Enviar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: commentForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (!commentForm.isValidForm()) return;
                        commentForm.isLoading = true;
                        int idUser = user.id!;
                        final String? errorMessage = await comentarioService
                            .addComment(idLibro, commentForm.comentario);
                        if (errorMessage == '200') {
                          customToast('Creado', context);
                          Navigator.pushReplacementNamed(context, 'details',
                              arguments: idLibro);
                        } else if (errorMessage == '500') {
                          customToast(
                              'No se ha podido poner un comentario', context);
                          commentForm.isLoading = false;
                        } else {
                          customToast('Server error', context);
                        }
                      })
          ],
        ),
      ),
    );
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.pink,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}
