import 'package:ampushare/data/models/auth_model/auth_model.dart';
import 'package:ampushare/data/store/auth_store/auth_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = Provider<AuthStore>((ref) {
  return AuthStore();
});
