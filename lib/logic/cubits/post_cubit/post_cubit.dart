import 'package:api_handling/data/models/post_model.dart';
import 'package:api_handling/data/repositories/post_repository.dart';
import 'package:api_handling/logic/cubits/post_cubit/post_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class PostCubit extends Cubit<PostState>{
  PostCubit() : super(PostLoadingState()){
    fetchPosts();
  }
  PostRepository postRepository = PostRepository();
  void fetchPosts() async{
    try{
      List<PostModel> posts = await postRepository.fetchPosts();
      emit(PostLoadedState(posts));
    } catch(ex){
      emit(PostErrorState(ex.toString()));
    }
  }
}