import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/core/local_storage/flutter_secure_storage_local_security_storage_impl.dart';
import 'package:cuidaper_mobile/app/core/local_storage/local_security_storage.dart';
import 'package:cuidaper_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidaper_mobile/app/core/local_storage/shared_preferences_local_storage_impl.dart';
import 'package:cuidaper_mobile/app/core/rest_client/dio_rest_client.dart';
import 'package:cuidaper_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidaper_mobile/app/modules/core/auth/auth_store.dart';
import 'package:cuidaper_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidaper_mobile/app/repositories/user/user_repository_impl.dart';
import 'package:cuidaper_mobile/service/user/user_service.dart';
import 'package:cuidaper_mobile/service/user/user_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AuthStore(), export: true),
    Bind.factory<RestClient>(
        (i) => DioRestClient(
              localStorage: i(),
              localSecurityStorage: i(),
              log: i(),
            ),
        export: true),
    Bind.lazySingleton<Logger>((i) => LoggerImpl(), export: true),
    Bind.lazySingleton<LocalStorage>((i) => SharedPreferencesLocalStorageImpl(),
        export: true),
    Bind.lazySingleton<LocalSecurityStorage>(
        (i) => FlutterSecureStorageLocalSecurityStorageImpl(),
        export: true),
    Bind.lazySingleton<UserRepository>(
        (i) => UserRepositoryImpl(
              restClient: i(),
              log: i(),
            ),
        export: true),
    Bind.lazySingleton<UserService>(
        (i) => UserServiceImpl(
              userRepository: i(),
              log: i(),
              localStorage: i(),
            ),
        export: true)
  ];
}
