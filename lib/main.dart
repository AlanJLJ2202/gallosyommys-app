import 'package:dotnet/screens/menu_screen.dart';
import 'package:dotnet/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/navigator/navigator_bloc.dart';
import 'screens/products_add_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      NavigatorBloc()
        ..add(GoMain()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<NavigatorBloc, NavigatorxState>(
          builder: (context, state) {

            if (state is MainState) {
              return MenuScreen();
            }
            if(state is ProductsState){
              return ProductsScreen();
            }
            if (state is EditProductCategoryState) {
              return ProductEdit(productId: state.productoId);
            }

            return Scaffold(
              body: Center(
                child: Text('Unknown state'),
              ),
            );
          },
        ),
      ),
    );
  }
}