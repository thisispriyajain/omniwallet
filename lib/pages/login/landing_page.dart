import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:omniwallet/navigation/routerdemo.dart';
import 'package:omniwallet/pages/login/cubit/login_cubit.dart';
import 'package:omniwallet/pages/login/views/forgot_password.dart';
import 'package:omniwallet/pages/login/views/landing_view.dart';
import 'package:omniwallet/pages/login/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/authentication/bloc/authentication_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    LogInCubit cubit = LogInCubit();

    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<LogInCubit, LogInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            print("Sign-in successful! Navigating to home...");
            GoRouter.of(context).goNamed(RouteName.home);
          }
        },
        builder: (context, state) {
          switch (state) {
            case PasswordReset _:
              return ForgotPassword(
                cancelRequestCallback: cubit.signInRequest,
                emailForgotPasswordCallback: cubit.forgotPassword,
              );
            case SignUpState _:
              return SignupView(
                emailSignUpCallback: cubit.emailSignUp,
                signInRequestCallback: cubit.signInRequest,
              );
            case SignInInitial _:
            default:
              return LandingView(
                emailSignInCallback: cubit.emailSignIn,
                signUpRequestCallback: cubit.signUpRequest,
                resetPasswordRequestCallback: cubit.resetPasswordRequest,
                googleSignInCallback: cubit.googleSignIn,
                appleSignInCallback: cubit.appleSignIn,
              );
          }
        },
      ),
    );
  }
}
