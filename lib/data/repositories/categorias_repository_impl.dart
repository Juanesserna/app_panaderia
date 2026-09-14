import '../../domain/entities/categoria.dart';
import '../../domain/repositories/categorias_repository.dart';
import '../datasources/categorias_mock_datasource.dart';

/// Implementación en memoria de [CategoriasRepository]. Simula
/// persistencia durante la sesión de la app (vive en una lista mutable);
/// no sobrevive a un reinicio. Cuando haya backend, se reemplaza por una
/// implementación que llame a la API/DB sin tocar providers ni UI.
class CategoriasRepositoryImpl implements CategoriasRepository {
  final CategoriasMockDatasource _datasource;
  late final List<Categoria> _categorias;

  CategoriasRepositoryImpl({
    CategoriasMockDatasource datasource = const CategoriasMockDatasource(),
  }) : _datasource = datasource {
    _categorias = List.of(_datasource.categoriasIniciales());
  }

  @override
  List<Categoria> obtenerCategorias() => List.unmodifiable(_categorias);

  @override
  void registrarCategoria(Categoria categoria) {
    _categorias.insert(0, categoria);
  }

  @override
  void actualizarCategoria(Categoria categoria) {
    final i = _categorias.indexWhere((e) => e.id == categoria.id);
    if (i != -1) _categorias[i] = categoria;
  }

  @override
  void eliminarCategoria(String id) {
    _categorias.removeWhere((e) => e.id == id);
  }
}
