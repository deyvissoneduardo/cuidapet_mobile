import 'package:cuidaper_mobile/app/app_module.dart';
import 'package:cuidaper_mobile/app/app_widget.dart';
import 'package:cuidaper_mobile/app/core/application_start_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  await ApplicationStartConfig().configureApp();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
