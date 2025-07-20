import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/posts_user/blocs/user_posts_bloc/user_posts_bloc.dart';
import 'package:red_social_prueba/features/user/presentation/logout/blocs/logout_bloc/logout_bloc.dart';
import 'package:red_social_prueba/shared/widgets/action_button_widget.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              // Limpiar los BLoCs de posts
              context.read<GetAllPostsBloc>().add(ResetPosts());
              context.read<UserPostsBloc>().add(ResetUserPosts());
              // Navegar a la pantalla de login o inicial
              GoRouter.of(context).go('/login');
            }
          },
          builder: (context, state) {
            if (state is LogoutLoading) {
              return CircularProgressIndicator();
            }
            return BlocBuilder<LogoutBloc, LogoutState>(
              builder: (context, state) {
                if (state is LogoutLoading) {
                  return const CircularProgressIndicator();
                }
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 500  ,),
                      ActionButtonWidget(
                        onPressed: () {
                          context.read<LogoutBloc>().add(LogoutRequested());
                        },
                        primaryText: 'Cerrar sesión',
                        icon: Icons.logout_rounded,
                        primaryColor: Theme.of(context).colorScheme.primary,
                        isLoading: state is LogoutLoading,
                        loadingText: 'Cerrando sesión...',
                        showCancelButton: false,
                        height: 45,
                      ),
                    ],
                  ),
                );  
              },
            );
          },
        ),
      ),
    );
  }
}
