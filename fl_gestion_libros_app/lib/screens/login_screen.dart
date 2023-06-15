import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const SizedBox(height: 10),
              Text('Iniciar sesión', style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: _LoginForm())
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                'Crear una nueva cuenta',
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Nombre de usuario',
                  prefixIcon: Icons.account_circle_sharp,
                  hintText: 'nombre de usuario'),
              onChanged: (value) => loginForm.username = value,
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
                hintText: '*****',
              ),
              onChanged: (value) => loginForm.password = value,
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.pink.shade800,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere' : 'Enviar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        // TODO: validar si el login es correcto
                        final String? data = await authService.login(
                            loginForm.username, loginForm.password);

                        final spliter = data?.split(',');
                    
                        if (spliter?[1] == '200') {
                          if (spliter?[2] == 'false') {
                            customToast('Usuario no activo', context);
                            loginForm.isLoading=false;
                          } else {
                              if (spliter?[0] == 'ROLE_USER') {
                              Navigator.pushReplacementNamed(
                                  context, 'catalogo_screen');
                            } else {
                              customToast('Admin: No tienes acceso', context);
                              Navigator.pushReplacementNamed(context, 'login');
                            }
                          }
                        } else {
                          customToast(
                              'Usuario o contraseña incorrectos', context);
                          Navigator.pushReplacementNamed(context, 'login');
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
      backgroundColor: Colors.pink.shade800,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}