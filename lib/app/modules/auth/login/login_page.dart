import 'package:cuidaper_mobile/app/core/helpers/environments.dart';
import 'package:cuidaper_mobile/app/core/ui/extensions/size_screen_extension.dart';
import 'package:cuidaper_mobile/app/core/ui/extensions/theme_extension.dart';
import 'package:cuidaper_mobile/app/modules/auth/login/widgets/login_form.dart';
import 'package:cuidaper_mobile/app/modules/auth/login/widgets/login_register_buttons.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150.w,
              fit: BoxFit.fill,
            ),
            const LoginForm(),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: context.primaryColor,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ou',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: context.primaryColor),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: context.primaryColor,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const LoginRegisterButtons(),
          ],
        ),
      ),
    ));
  }
}
