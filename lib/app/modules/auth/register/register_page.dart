import 'package:cuidaper_mobile/app/core/ui/validators/validator.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:cuidaper_mobile/app/modules/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState
    extends ModularState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final loginEC = TextEditingController();
  final passwordEC = TextEditingController();
  final confirmPasswordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    loginEC.dispose();
    passwordEC.dispose();
    confirmPasswordEC.dispose();
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 150.w,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 10),
                CuidapetTextFormField(
                  label: 'Login',
                  controller: loginEC,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validatorless.multiple([
                    Validatorless.required('campo obrigatorio'),
                    Validatorless.email('e-mail invalido'),
                  ]),
                ),
                const SizedBox(height: 10),
                CuidapetTextFormField(
                  label: 'Senha',
                  obscureText: true,
                  controller: passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('campo obrigatorio'),
                    Validatorless.min(6, 'minimo 6 caracteres'),
                  ]),
                ),
                const SizedBox(height: 10),
                CuidapetTextFormField(
                  label: 'Confirmar Senha',
                  obscureText: true,
                  controller: confirmPasswordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('campo obrigatorio'),
                    Validatorless.min(6, 'minimo 6 caracteres'),
                    Validators.compare(
                      passwordEC,
                      'senha e confirma senha não são iguais',
                    )
                  ]),
                ),
                const SizedBox(height: 10),
                CuidapetDefaultButton(
                  label: 'Cadastrar',
                  onPressed: () {
                    final formValid =
                        _formKey.currentState?.validate() ?? false;
                    if (formValid) {
                      controller.register(
                        loginEC.text.trim(),
                        passwordEC.text.trim(),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
