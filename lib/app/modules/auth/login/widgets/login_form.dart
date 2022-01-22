import 'package:cuidaper_mobile/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:cuidaper_mobile/app/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:validatorless/validatorless.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ModularState<LoginForm, LoginController> {
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _loginEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          CuidapetTextFormField(
            label: 'Login',
            controller: _loginEC,
            validator: Validatorless.multiple([
              Validatorless.required('campo obrigatorio'),
              Validatorless.email('e-mail invalido'),
            ]),
          ),
          const SizedBox(height: 10),
          CuidapetTextFormField(
            label: 'Senha',
            obscureText: true,
            controller: _passwordEC,
            validator: Validatorless.multiple([
              Validatorless.required('campo obrigatorio'),
              Validatorless.min(6, 'minimo 6 caracters'),
            ]),
          ),
          const SizedBox(height: 20),
          CuidapetDefaultButton(
            label: 'Entrar',
            onPressed: () {
              final formValid = _formKey.currentState?.validate() ?? false;
              if (formValid) {
                controller.login(_loginEC.text.trim(), _passwordEC.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }
}
