import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

abstract class GetAllPostsState extends Equatable {
  const GetAllPostsState();

  @override
  List<Object> get props => [];
}

class GetAllPostsInitial extends GetAllPostsState {}

class GetAllPostsLoading extends GetAllPostsState {}

class GetAllPostsSuccess extends GetAllPostsState {
  final List<Post> posts;
  final bool limitReached; //? Bandera para saber cuando alcanza el limite
                           //? La cantidad de post de la api es de 251, por le momento
  const GetAllPostsSuccess({
    this.posts = const <Post>[],
    this.limitReached = false,
  });

  GetAllPostsSuccess copyWith({
    //? Para editar el objeto usamos copyWith
    List<Post>? posts,
    bool? limitReached,
  }) {
    return GetAllPostsSuccess(
      posts: posts ?? this.posts,
      limitReached: limitReached ?? this.limitReached,
    );
  }

  //? Ahora incluye ambas propiedades para que Equatable detecte cambios en cualquiera de las dos
  @override
  List<Object> get props => [posts, limitReached];
}

class GetAllPostsError extends GetAllPostsState {
  final String message;

  const GetAllPostsError({required this.message});

  @override
  List<Object> get props => [message];
}
