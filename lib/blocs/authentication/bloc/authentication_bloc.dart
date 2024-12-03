import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    _checkAuthenticationStatus();
    on<AuthenticationEvent>((event, emit) async {
      await login();
      emit(AuthenticationLoggedIn());
    });
  }
  Future<void> _checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      emit(AuthenticationLoggedIn());
    } else {
      emit(AuthenticationLoggedOut());
    }
  }

  // Call this method when the user logs in
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    emit(AuthenticationLoggedIn());
  }

  // Call this method when the user logs out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    emit(AuthenticationLoggedOut());
  }

  //   on<AuthenticationEvent>((event, emit) {
  //     // TODO: implement event handler
  //   });
  //   on<AuthenticationLoginEvent>((event, emit) {
  //     _login(event, emit);
  //   });
  //   on<AuthenticationLogoutEvent>((event, emit) {
  //     _logout(event, emit);
  //   });
  // }

  // void _login(event, emit) {
  //   emit(AuthenticationLoggedIn());
  // }

  // void _logout(event, emit) {
  //   emit(AuthenticationLoggedOut());
  // }
}
