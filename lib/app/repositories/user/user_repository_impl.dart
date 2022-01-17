import 'package:cuidaper_mobile/app/core/exceptions/failure.dart';
import 'package:cuidaper_mobile/app/core/exceptions/user_exists_exception.dart';
import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidaper_mobile/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidaper_mobile/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final Logger _log;

  UserRepositoryImpl({
    required RestClient restClient,
    required Logger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient.unauth().post(
        '/auth/register/',
        data: {
          'email': email,
          'password': password,
        },
      );
    } on RestClientException catch (e, s) {
      if (e.statusCode == 400 &&
          e.response?.data['message'].contains('usuario ja cadastrado')) {
        _log.error('Usuario ja cadastrado', error: e, stackTrace: s);
        throw UserExistsException();
      }
      _log.error('Error ao cadastra usuario', error: e, stackTrace: s);
      throw Failure();
    }
  }
}
