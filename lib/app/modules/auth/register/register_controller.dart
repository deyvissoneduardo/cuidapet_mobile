import 'package:cuidaper_mobile/app/core/exceptions/user_exists_exception.dart';
import 'package:cuidaper_mobile/app/core/helpers/logger.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/loader.dart';
import 'package:cuidaper_mobile/app/core/ui/widgets/messages.dart';
import 'package:cuidaper_mobile/app/service/user/user_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'register_controller.g.dart';

class RegisterController = _RegisterControllerBase with _$RegisterController;

abstract class _RegisterControllerBase with Store {
  final UserService _userService;
  final Logger _log;

  _RegisterControllerBase({
    required UserService userService,
    required Logger log,
  })  : _userService = userService,
        _log = log;

  Future<void> register(String email, String password) async {
    try {
      Loader.show();
      await _userService.register(email, password);
      Loader.hide();
      Modular.to.popAndPushNamed('/auth/');
    } on UserExistsException {
      Loader.hide();
      Messages.info('E-mail ja cadastrado');
    } catch (e, s) {
      _log.error('Error ao registrar usuario', error: e, stackTrace: s);
      Loader.hide();
      Messages.alert('Error ao registrar usuario');
    }
  }
}
