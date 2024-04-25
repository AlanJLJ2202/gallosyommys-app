import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/balance.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorxState> {
  NavigatorBloc() : super(NavigatorInitial()) {
    on<NavigatorEvent>((event, emit) {
      if (event is GoLogin) {
        emit(LoginState());
      }
      if (event is GoMain) {
        emit(MainState(user_id: event.user_id));
      }
      if (event is GoProducts) {
        emit(ProductsState(user_id: event.user_id));
      }
      if (event is GoEditProduct) {
        emit(EditProductCategoryState(productoId: event.productoId, user_id: event.user_id));
      }
      if (event is GoTransactions) {
        emit(TransactionsState(user_id: event.user_id));
      }
      if (event is GoEditTransaction) {
        emit(EditTransactionState(transactionId: event.transactionId, balance: event.balance, user_id: event.user_id));
      }
      if (event is GoListas) {
        emit(ListasState(user_id: event.user_id));
      }
      if (event is GoEditLista) {
        emit(EditListaState(listaId: event.listaId, user_id: event.user_id));
      }
      if (event is GoListaProductos) {
        emit(ListaProductosState(listaId: event.listaId, listaNombre: event.listaNombre, user_id: event.user_id));
      }
      if (event is GoEditListaProductos) {
        emit(EditListaProductosState(listaId: event.listaId, listaNombre: event.listaNombre, listaProductoId: event.listaProductoId, user_id: event.user_id));
      }
      if (event is GoCategorias) {
        emit(CategoriasState(user_id: event.user_id));
      }
      if (event is GoEditCategoria) {
        emit(EditCategoriaState(categoriaId: event.categoriaId, user_id: event.user_id));
      }

    });
  }
}
