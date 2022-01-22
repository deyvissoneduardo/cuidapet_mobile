import 'package:cuidaper_mobile/app/core/ui/cuidapet_icons.dart';
import 'package:cuidaper_mobile/app/core/ui/extensions/theme_extension.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/rounded_button_with_icon.dart';
import 'package:flutter/material.dart';

class LoginRegisterButtons extends StatelessWidget {
  const LoginRegisterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        RoundedButtonWithIcon(
          color: const Color(0xFF4267B3),
          icon: CuidapetIcons.facebook,
          width: MediaQuery.of(context).size.width / 2.5,
          title: 'Facebook',
          onTap: () => {},
        ),
        RoundedButtonWithIcon(
          color: const Color(0xFFE15031),
          icon: CuidapetIcons.google,
          width: MediaQuery.of(context).size.width / 2.5,
          title: 'Google',
          onTap: () {},
        ),
        RoundedButtonWithIcon(
          color: context.primaryColorDark,
          icon: Icons.mail,
          width: MediaQuery.of(context).size.width / 2.5,
          title: 'Cadastre-se',
          onTap: () => Navigator.pushNamed(context, '/auth/register/'),
        ),
      ],
    );
  }
}
