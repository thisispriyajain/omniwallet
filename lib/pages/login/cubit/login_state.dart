part of 'login_cubit.dart';

@immutable
sealed class LogInState {}

final class LogInInitial extends LogInState {}

final class SignInSuccess extends LogInState {}

final class PasswordReset extends LogInState {}

final class SignUpState extends LogInState {}

final class SignInInitial extends LogInState {}
