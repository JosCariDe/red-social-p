import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/post_detail/blocs/get_one_post_by_id/get_post_by_id_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  final int idPost;
  const PostDetailScreen({super.key, required this.idPost});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetPostByIdBloc>().add(GetPostById(idPost: widget.idPost));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.idPost.toString()),
    );
  }
}
