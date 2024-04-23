import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorxState> {
  NavigatorBloc() : super(NavigatorInitial()) {
    on<NavigatorEvent>((event, emit) {
      if (event is GoMain) {
        emit(MainState());
      }
      if (event is GoEditProductCategory) {
        emit(EditProductCategoryState());
      }
    });
  }
}
