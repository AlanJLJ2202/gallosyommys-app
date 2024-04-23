part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorEvent {}


class GoMain extends NavigatorEvent {}

class GoEditProductCategory extends NavigatorEvent {}