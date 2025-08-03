import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/di/injection.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/auth_user_bloc/auth_user_bloc.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, verificamos si ya hay un usuario logueado
    context.read<AuthUserBloc>().add(VerifiedUserLogging());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: MultiBlocListener(
        listeners: [
          // Listener para reaccionar a los cambios de estado de la autenticación
          BlocListener<AuthUserBloc, AuthUserState>(
            listener: (context, state) {
              if (state is AuthUserAuthenticated) {
                debugPrint(
                    'Usuario autenticado (ID: ${state.user.id}), navegando a /posts');
                context.go('/posts');
              }
            },
          ),
          // Listener para reaccionar al resultado del formulario de login
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                // Si el login es exitoso, le informamos al AuthUserBloc
                // El listener de AuthUserBloc se encargará de la navegación
                final user = User(
                  id: state.userId,
                  email: state.username,
                  password: state.password,
                );
                context.read<AuthUserBloc>().add(AuthUserLoggedIn(user: user));
              } else if (state is LoginFailure) {
                // Si el login falla, mostramos un error
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dimelo Rey,',
                      style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome To Back',
                      style: textTheme.titleLarge?.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Email',
                      ),
                      validator: (value) => value != null && value.contains('@')
                          ? null
                          : 'Email inválido',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: 'Password',
                        suffixIcon: Icon(Icons.visibility_off),
                      ),
                      validator: (value) => value != null && value.length >= 6
                          ? null
                          : 'Mínimo 6 caracteres',
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is LoginLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                          child: state is LoginLoading
                              ? const CircularProgressIndicator()
                              : const Text('Login'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
