part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorxState {}

class NavigatorInitial extends NavigatorxState {}

class MainState extends NavigatorxState {
  final int user_id;
  MainState({required this.user_id});
}

class ProductsState extends NavigatorxState {
  final int user_id;
  ProductsState({required this.user_id});
}

class EditProductCategoryState extends NavigatorxState {
  final int user_id;
  final int? productoId;
  EditProductCategoryState({
    required this.user_id,
    this.productoId
  });
}

class TransactionsState extends NavigatorxState {
  final int user_id;
  TransactionsState({required this.user_id});
}

class EditTransactionState extends NavigatorxState {
  final int user_id;
  final int? transactionId;
  final Balance? balance;
  EditTransactionState({
    required this.user_id,
    this.transactionId,
    this.balance});
}

class ListasState extends NavigatorxState {
  final int user_id;
  ListasState({required this.user_id});
}

class EditListaState extends NavigatorxState {
  final int user_id;
  final int? listaId;
  EditListaState({
    required this.user_id,
    this.listaId
  });
}

class ListaProductosState extends NavigatorxState {
  final int user_id;
  final int listaId;
  final String listaNombre;
  ListaProductosState({
    required this.user_id,
    required this.listaId, required this.listaNombre
  });
}

class EditListaProductosState extends NavigatorxState {
  final int user_id;
  final int listaId;
  final String listaNombre;
  final int? listaProductoId;

  EditListaProductosState({
    required this.user_id,
    required this.listaId, required this.listaNombre, required this.listaProductoId});
}

class CategoriasState extends NavigatorxState {
  final int user_id;
  CategoriasState({required this.user_id});
}

class EditCategoriaState extends NavigatorxState {
  final int user_id;
  final int? categoriaId;
  EditCategoriaState({
    required this.user_id,
    this.categoriaId});
}

class LoginState extends NavigatorxState {}

