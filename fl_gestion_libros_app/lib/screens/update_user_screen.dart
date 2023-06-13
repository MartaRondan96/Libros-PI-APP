import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:fl_gestion_libros_app/models/models.dart';
import 'package:fl_gestion_libros_app/screens/screens.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreen();
}

class _UpdateUserScreen extends State<UpdateUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 120),
              CardContainer(
                  child: Column(
                children: [
                 SizedBox(height: 10),
                  Text('Editar datos de usuario',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => UpdateFormProvider(), child: _LoginForm())
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'catalogo_screen'),
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

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => __LoginForm();
}

class __LoginForm extends State<_LoginForm> {
  final userService =UserService();
  String? token="";
  User user = User();

  Future getUser() async {
    User us = await UserService().getUser();
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
    final loginForm = Provider.of<UpdateFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              initialValue: user.username,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: user.username.toString(),
                labelText: 'Username',
                prefixIcon: Icons.account_circle_sharp,
              ),
              onChanged: (value) => loginForm.username = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: user.email,
              obscureText: false,
              enabled: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'email',
                  prefixIcon: Icons.email_rounded),
              onChanged: (value) => loginForm.password = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: user.password,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.r_password = value,
            ),
            SizedBox(height: 30),
             TextFormField(
              autocorrect: false,
              initialValue: user.password,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
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
                      loginForm.isLoading ? 'Espere' : 'Enviar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        if (
                            loginForm.username.isEmpty ||
                            loginForm.password.isEmpty || (loginForm.password == loginForm.r_password )
                            ) {
                          customToast("Los campos tienen que estar rellenos", context);
                        } else {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          final String? errorMessage = await userService.update(
                              loginForm.username,
                              loginForm.password);

                          if (errorMessage == '201') {
                            customToast('Updated', context);
                            Navigator.pushReplacementNamed(
                                context, 'userscreen');
                          } else if (errorMessage == '500') {
                            // TODO: mostrar error en pantalla
                            customToast('User registered', context);

                            loginForm.isLoading = false;
                          } else {
                            customToast('Server error', context);
                          }
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