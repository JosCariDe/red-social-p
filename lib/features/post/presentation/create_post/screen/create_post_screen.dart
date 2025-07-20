import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/features/post/presentation/create_post/blocs/create_post_bloc/create_post_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          context.pop(); // Vuelve a la pantalla anterior (Home)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Post creado exitosamente!')),
          );
        } else if (state is CreatePostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Crear Post')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: 'Cuerpo'),
                  maxLines: 4,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(labelText: 'Tags (separados por coma)'),
                ),
                const SizedBox(height: 32),
                BlocBuilder<CreatePostBloc, CreatePostState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is CreatePostLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<CreatePostBloc>().add(
                                      CreatePostSubmitted(
                                        title: _titleController.text.trim(),
                                        body: _bodyController.text.trim(),
                                        tags: _tagsController.text
                                            .split(',')
                                            .map((e) => e.trim())
                                            .where((e) => e.isNotEmpty)
                                            .toList(),
                                      ),
                                    );
                              }
                            },
                      child: state is CreatePostLoading
                          ? const CircularProgressIndicator()
                          : const Text('Crear Post'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}