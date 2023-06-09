import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  Text(
                    'Crear una cuenta',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: _RegisterForm())
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'login'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre de usuario',
                  labelText: 'Nombre de usuario',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => registerForm.username = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => registerForm.password = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Repite Password',
                  labelText: 'Repite Password',
                  prefixIcon: Icons.account_circle_sharp),
              onChanged: (value) => registerForm.r_password = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: Icons.email),
              onChanged: (value) => registerForm.email = value,  
               validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Use a valid email';
                }
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.pink.shade800,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      registerForm.isLoading ? 'Espere' : 'Enviar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: registerForm.isLoading
                    ? null
                    : () async { 
                      if (registerForm.username.isEmpty ||
                            registerForm.password.isEmpty ||
                            registerForm.email.isEmpty || registerForm.r_password.isEmpty ){
                              customToast("Los campos tienen que estar rellenos", context);
                            }
                          else{ 
                            if(registerForm.password.length<8 && registerForm.r_password.length<8){
                              customToast("La contraseña tiene que tener 8 caracteres", context);
                             }else{
                                if(registerForm.password != registerForm.r_password )
                                customToast("Las contraseñas deben coincidir", context);
                          else{
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                          if (!registerForm.isValidForm()) return;
                          registerForm.isLoading = true;
                          final String? errorMessage =
                              await authService.register(registerForm.username,
                                  registerForm.email,registerForm.password);
                        if (errorMessage == '200') {
                          customToast('Registrado con éxito', context);
                          Navigator.pushReplacementNamed(context, 'login');
                        } else if (errorMessage == '500') {
                          // TODO: mostrar error en pantalla
                          customToast(
                              'Ya existe una cuenta con esos datos', context);
                          registerForm.isLoading = false;
                        } else {
                          customToast('Error de servidor', context);
                        }
   } }}})
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
