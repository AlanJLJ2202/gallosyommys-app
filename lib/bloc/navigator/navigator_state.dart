part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorxState {}

class NavigatorInitial extends NavigatorxState {}

class MainState extends NavigatorxState {}

class ProductsState extends NavigatorxState {}

class TransactionsState extends NavigatorxState {}

class ListsState extends NavigatorxState {}

class EditProductCategoryState extends NavigatorxState {
  final int? productoId;
  EditProductCategoryState({this.productoId});
}