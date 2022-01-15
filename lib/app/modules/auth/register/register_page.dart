import 'package:cuidaper_mobile/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre-se'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150.w,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              CuidapetTextFormField(label: 'Login'),
              const SizedBox(height: 10),
              CuidapetTextFormField(
                label: 'Senha',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CuidapetTextFormField(
                label: 'Confirmar Senha',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CuidapetDefaultButton(
                label: 'Cadastrar',
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
