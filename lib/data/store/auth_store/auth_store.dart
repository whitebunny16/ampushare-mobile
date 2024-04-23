import 'package:ampushare/data/models/auth_model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  AuthModel _authModel = AuthModel(
    access: '',
    refresh: '',
    user: AuthUser(
      firstName: '',
      lastName: '',
      profileImage: '',
      id: 0,
      email: '',
    ),
  );

  Future<AuthModel> getAuthModel() async {
    final prefs = await SharedPreferences.getInstance();
    final authModelString = prefs.getString('authModel');
    if (authModelString != null) {
      _authModel = authModelFromJson(authModelString);
    }
    return _authModel;
  }

  Future<void> setAuthModel(AuthModel model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authModel', authModelToJson(model));
    _authModel = model;
  }

  void updateAuthModel(AuthModel newModel) {
    _authModel = newModel;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authModel');
    _authModel = AuthModel(
      access: '',
      refresh: '',
      user: AuthUser(
        firstName: '',
        lastName: '',
        profileImage: '',
        id: 0,
        email: '',
      ),
    );
  }
}
