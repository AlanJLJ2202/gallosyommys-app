part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorEvent {}


class GoMain extends NavigatorEvent {
  final int user_id;
  GoMain({required this.user_id});
}

class GoProducts extends NavigatorEvent {
  final int user_id;
  GoProducts({required this.user_id});
}

class GoEditProduct extends NavigatorEvent {
  final int user_id;
  final int? productoId;
  GoEditProduct({
    required this.user_id,
    this.productoId});
}

class GoTransactions extends NavigatorEvent {
  final int user_id;
  GoTransactions({required this.user_id});
}

class GoEditTransaction extends NavigatorEvent {
  final int user_id;
  final int? transactionId;
  final Balance? balance;
  GoEditTransaction({
    required this.user_id,
    this.transactionId, this.balance});
}

class GoListas extends NavigatorEvent {
  final int user_id;
  GoListas({required this.user_id});
}

class GoEditLista extends NavigatorEvent {
  final int user_id;
  final int? listaId;
  GoEditLista({
    required this.user_id,
    this.listaId});
}

class GoListaProductos extends NavigatorEvent {
  final int user_id;
  final int listaId;
  final String listaNombre;
  GoListaProductos({
    required this.user_id,
    required this.listaId, required this.listaNombre});
}

class GoEditListaProductos extends NavigatorEvent {
  final int user_id;
  final int listaId;
  final String listaNombre;
  final int? listaProductoId;

  GoEditListaProductos({
    required this.user_id,
    required this.listaId, required this.listaNombre, required this.listaProductoId});
}


class GoCategorias extends NavigatorEvent {
  final int user_id;
  GoCategorias({required this.user_id});
}

class GoEditCategoria extends NavigatorEvent {
  final int user_id;
  final int? categoriaId;
  GoEditCategoria({
    required this.user_id,
    this.categoriaId});
}

class GoLogin extends NavigatorEvent {}

