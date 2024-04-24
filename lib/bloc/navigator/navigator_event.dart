part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorEvent {}


class GoMain extends NavigatorEvent {}

class GoProducts extends NavigatorEvent {}

class GoTransactions extends NavigatorEvent {}

class GoLists extends NavigatorEvent {}

class GoEditProduct extends NavigatorEvent {
  final int? productoId;
  GoEditProduct({this.productoId});
}