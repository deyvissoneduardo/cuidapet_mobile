import 'package:cuidaper_mobile/app/core/rest_client/dio_rest_client.dart';
import 'package:cuidaper_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidaper_mobile/app/modules/core/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AuthStore(), export: true),
    Bind.factory<RestClient>((i) => DioRestClient(), export: true),
  ];
}
