import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:receitas/di/service_locator.dart';
import 'package:receitas/ui/recipedetail/recipe_detail_viewmodel.dart';
import 'package:receitas/ui/widgets/recipe_row_details.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({super.key, required this.id});

  final String id;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {

  final viewModel = getIt<RecipeDetailViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadRecipe(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
      return Obx( () {
        if (viewModel.isLoading) {
          return Center(
            child: SizedBox(
              height: 96,
              width: 96,
              child: CircularProgressIndicator(strokeWidth: 12),
            ),
          );
        }

        if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(32),
              child: Column(
                spacing: 32,
                children: [
                  Text(
                    'Erro: ${viewModel.errorMessage}',
                    style: TextStyle(fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text('VOLTAR'),
                  ),
                ],
              ),
            ),
          );
        } 

        final recipe = viewModel.recipe;
        if (recipe == null) {
          return Center(
            child: Text('Receita não encontrada'),
          );
        }
        return SingleChildScrollView(
          child: Column(children: [
            recipe.image != null 
              ? Image.network(
                  recipe.image!,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                  errorBuilder: (context, child, stackTrace) => Container(
                    height: 400,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.error),
                  ),
                )
              : Container(
                  height: 400,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.restaurant,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text(recipe.name),
                  const SizedBox(height: 16),
                  RecipeRowDetails(recipe: recipe),
                  const SizedBox(height: 16),
                  recipe.ingredients.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Ingredientes'),
                          const SizedBox(height: 8),
                          Text(recipe.ingredients.join('\n')
                          )
                        ],
                      )
                    : Text('Nenhum ingrediente listado'),
                  const SizedBox(height: 16),
                  recipe.instructions.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Instruções'),
                        const SizedBox(height: 8),
                        Text(recipe.instructions.join('\n')
                        ),
                      ],
                    )
                  : Text('Nenhuma instrução'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/'), 
                      child: Text('VOLTAR'),
                    ),
                    ElevatedButton(
                      onPressed: () viewModel.toggleFavorite(), 
                      child: Text(viewModel.isFavorite ? 'DESFAVORITAR' : 'FAVORITAR'),
                    ),
                  ],
                )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}