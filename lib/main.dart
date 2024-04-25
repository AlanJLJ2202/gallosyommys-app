import 'package:dotnet/models/categoria.dart';
import 'package:dotnet/screens/categorias_screen.dart';
import 'package:dotnet/screens/menu_screen.dart';
import 'package:dotnet/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/navigator/navigator_bloc.dart';
import 'screens/categoria_add_screen.dart';
import 'screens/lista_productos_add_screen.dart';
import 'screens/lista_productos_screen.dart';
import 'screens/listas_add_screen.dart';
import 'screens/listas_screen.dart';
import 'screens/login_screen.dart';
import 'screens/products_add_screen.dart';
import 'screens/transaccion_add_screen.dart';
import 'screens/transacciones_screen.dart';

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
        ..add(GoLogin()),
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

            if(state is LoginState) {
              return LoginScreen();
            }
            if (state is MainState) {
              return MenuScreen(user_id: state.user_id);
            }
            if(state is ProductsState){
              return ProductsScreen(user_id: state.user_id);
            }
            if (state is EditProductCategoryState) {
              return ProductEdit(productId: state.productoId, user_id: state.user_id);
            }
            if(state is TransactionsState){
              return TransaccionesScreen(user_id: state.user_id);
            }
            if(state is EditTransactionState){
              return TransaccionEdit(transaccionId: state.transactionId, balance: state.balance, user_id: state.user_id);
            }
            if(state is ListasState){
              return ListasScreen(user_id: state.user_id);
            }
            if(state is EditListaState){
              return ListasEditScreen(listaId: state.listaId, user_id: state.user_id);
            }
            if(state is ListaProductosState){
              return ListaProductosScreen(listaId: state.listaId, nombre: state.listaNombre, user_id: state.user_id);
            }
            if(state is EditListaProductosState){
              return ListasProductosEditScreen(listaId: state.listaId, listaNombre: state.listaNombre, listaProductoId: state.listaProductoId, user_id: state.user_id);
            }
            if(state is CategoriasState){
              return CategoriasScreen(user_id: state.user_id);
            }
            if(state is EditCategoriaState){
              return CategoriaEditScreen(categoriaId: state.categoriaId, user_id: state.user_id);
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