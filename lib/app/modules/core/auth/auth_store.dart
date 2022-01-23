import 'package:cuidaper_mobile/app/core/helpers/constants.dart';
import 'package:cuidaper_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidaper_mobile/app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final LocalStorage _localStorage;

  @observable
  UserModel? userModel;

  _AuthStoreBase({
    required LocalStorage localStorage,
  }) : _localStorage = localStorage;

  @action
  Future<void> loadUser() async {
    final userLoggedData =
        await _localStorage.read<String>(Constants.userDataKey);
    if (userLoggedData != null) {
      userModel = UserModel.fromJson(userLoggedData);
    } else {
      userModel = UserModel.empty();
    }
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        userModel = UserModel.empty();
      }
    });
  }

  Future<void> logout() async {
    _localStorage.clear();
    userModel = null;
  }
}
