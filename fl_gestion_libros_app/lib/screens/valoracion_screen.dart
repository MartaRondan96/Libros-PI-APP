import 'package:fl_gestion_libros_app/models/models.dart';
import 'package:fl_gestion_libros_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class ValoracionScreen extends StatefulWidget {
  final int idLibro;
  const ValoracionScreen({required this.idLibro});

  @override
  State<ValoracionScreen> createState() =>
      _ValoracionScreen(idLibro: idLibro);
}

class _ValoracionScreen extends State<ValoracionScreen> {
  final int idLibro;

  _ValoracionScreen({required this.idLibro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Valoración',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => ValoracionFormProvider(),
                      child: _Form(idLibro: idLibro))
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'details'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: Text(
                    'Atrás',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
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
//
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
    final notaForm = Provider.of<ValoracionFormProvider>(context);
    final valoracionService = ValoracionService();
    //final departmentProvider = Provider.of<DepartmentFormProvider>(context);
    List<dynamic> options = [
      [false, "No Resuelto"],
      [true, "Resuelto"]
    ];

    return Container(
      child: Form(
        key: notaForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'valoración',
                  labelText: 'Valoración',
                  prefixIcon: Icons.add_chart_rounded),
              onChanged: (value) => notaForm.valoracion = value,
              maxLines: null,
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blueGrey,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      notaForm.isLoading ? 'Espera' : 'Enviar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: notaForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (!notaForm.isValidForm()) return;
                        notaForm.isLoading = true;
                        int idUser = user.id!;
                        final String? errorMessage = await valoracionService.addValoracion(
                            idLibro, notaForm.valoracion);
                        if (errorMessage == '200') {
                          customToast('Created', context);
                          Navigator.pushReplacementNamed(
                              context, 'details', arguments:idLibro);
                        } else if (errorMessage == '500') {
                          customToast('No se ha podido poner la valoración', context);
                          notaForm.isLoading = false;
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
      backgroundColor: Colors.blueGrey,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}