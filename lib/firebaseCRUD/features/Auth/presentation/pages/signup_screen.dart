import 'package:api_handling/firebaseCRUD/features/Auth/presentation/widgets/auth_textfield.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/presentation/widgets/auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/localization/languages.dart';
import '../../../../core/routes/routes_name.dart';
import '../bloc/signup/signup_bloc.dart';

class TempSignUp extends StatefulWidget {
  const TempSignUp({super.key});

  @override
  State<TempSignUp> createState() => _TempSignUpState();
}

class _TempSignUpState extends State<TempSignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTitle(title: AppLocale.signUp.getString(context)),
                // MyTitle(title: 'Signup'),
                SizedBox(height: 20),
                BlocBuilder<TempSignUpBloc, TempSignUpState>(
                    builder: (context, state) {
                  if (state is TempSignUpInvalidState) {
                    return Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                SizedBox(height: 20),
                AuthTextField(
                    controller: emailController,
                    hintText: AppLocale.email.getString(context),
                    onTextChanged: (val) {
                      BlocProvider.of<TempSignUpBloc>(context).add(
                          TempSignUpEmailChangedEvent(
                              email: emailController.text,
                              context: context
                          ));
                    }),
                SizedBox(height: 10),
                AuthTextField(
                    obscureText: true,
                    controller: passController,
                    hintText: AppLocale.pass.getString(context),
                    onTextChanged: (val) {
                      BlocProvider.of<TempSignUpBloc>(context).add(
                          TempSignUpPasswordChangedEvent(
                              email: emailController.text,
                              password: passController.text,
                              context: context
                          ));
                    }),
                SizedBox(height: 20),
                BlocBuilder<TempSignUpBloc, TempSignUpState>(
                  builder: (context, state) {
                    return CupertinoButton(
                      onPressed: (state is TempSignUpValidState)
                          ? () {
                              Navigator.pushNamed(
                                  context, RoutesName.tempLoginScreen);
                              // crudService.signUp(emailController.text,passController.text);
                              BlocProvider.of<TempSignUpBloc>(context).add(
                                  TempSignUpSubmittedEvent(
                                      email: emailController.text,
                                      password: passController.text,
                                      context: context
                                  ));
                              emailController.clear();
                              passController.clear();
                            }
                          : () {},
                      color: (state is TempSignUpInvalidState ||
                              state is TempSignInInitialState)
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                      child: Text(
                        AppLocale.signIn.getString(context),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
