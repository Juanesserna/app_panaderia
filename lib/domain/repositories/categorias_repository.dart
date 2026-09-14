import '../entities/categoria.dart';

/// Contrato del módulo de Categorías. Hoy lo implementa un repositorio en
/// memoria (ver `data/repositories/categorias_repository_impl.dart`). El
/// día que exista backend, se crea otra implementación de esta misma
/// interfaz y no hay que tocar ni los providers de Riverpod ni la UI.
abstract class CategoriasRepository {
  List<Categoria> obtenerCategorias();

  void registrarCategoria(Categoria categoria);

  /// Reemplaza la categoría con el mismo `id` por [categoria] (ya con los
  /// cambios aplicados).
  void actualizarCategoria(Categoria categoria);

  void eliminarCategoria(String id);
}
