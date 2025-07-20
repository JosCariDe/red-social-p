import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/auth_user_bloc/auth_user_bloc.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<AuthUserBloc, AuthUserState>(
        builder: (context, state) {
          if (state is AuthUserAuthenticated) {
            return Text(
              'Bienvenido, ${state.user.email} (ID: ${state.user.id})',
            );
          }
          return const Text('Posts');
        },
      ),
      // Aquí puedes agregar más propiedades del AppBar si las tienes
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}