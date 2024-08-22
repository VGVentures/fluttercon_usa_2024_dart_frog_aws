import 'package:bloc/bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';

class UserCubit extends Cubit<User?> {
  UserCubit({required FlutterconApi api})
      : _api = api,
        super(null);

  final FlutterconApi _api;

  Future<void> getUser() async {
    final user = await _api.getUser();
    emit(user);
  }
}
