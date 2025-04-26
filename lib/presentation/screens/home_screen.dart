import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/post_cubit/post_cubit.dart';
import '../../logic/cubits/post_cubit/post_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'API Handling',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
          child: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        if (state is PostLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PostLoadedState) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.posts[index].title.toString()),
              );
            },
          );
        }
        return Center(
          child: Text('Error Occurred'),
        );
      })),
    );
  }
}
