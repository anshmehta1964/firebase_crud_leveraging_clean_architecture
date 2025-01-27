import 'package:api_handling/firebaseCRUD/features/Auth/data/datasource/auth_remote_data_source.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/data/repository/auth_repository_impl.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/presentation/widgets/auth_textfield.dart';
import 'package:api_handling/firebaseCRUD/features/Auth/presentation/widgets/auth_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:api_handling/firebaseCRUD/screens/signup%20screen/bloc/firebase_signup_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                AuthTitle(title: 'Signup'),
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
                    hintText: 'Email',
                    onTextChanged: (val){
                      BlocProvider.of<TempSignUpBloc>(context).add(
                          TempSignUpEmailChangedEvent(email: emailController.text));
                    }),
                // MyTextField(
                //     controller: emailController,
                //     hintText: 'Email',
                //     onTextChanged: (val){
                //       BlocProvider.of<FirebaseSignupBloc>(context).add(
                //           SignupEmailChangedEvent(email: emailController.text));
                //     }
                // ),
                SizedBox(height: 10),
                AuthTextField(
                    obscureText: true,
                    controller: passController,
                    hintText: 'Password',
                    onTextChanged: (val){
                      BlocProvider.of<TempSignUpBloc>(context).add(
                          TempSignUpPasswordChangedEvent(
                              email: emailController.text,
                              password: passController.text));
                    }),
                SizedBox(height: 20),
                BlocBuilder<TempSignUpBloc, TempSignUpState>(
                  builder: (context, state) {
                    return CupertinoButton(
                      onPressed: (state is TempSignUpValidState) ? () {
                        Navigator.pushNamed(context,RoutesName.tempLoginScreen);
                        // crudService.signUp(emailController.text,passController.text);
                        BlocProvider.of<TempSignUpBloc>(context).add(TempSignUpSubmittedEvent(email: emailController.text, password: passController.text));
                        emailController.clear();
                        passController.clear();
                      } : () { },
                      color: (state is TempSignUpInvalidState || state is TempSignInInitialState) ? Colors.grey : Theme.of(context).colorScheme.primary,
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}
