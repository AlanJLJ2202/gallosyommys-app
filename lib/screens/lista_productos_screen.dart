import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/lista_compra.dart';
import 'package:dotnet/models/product.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/lista_producto.dart';


class ListaProductosScreen extends StatefulWidget {
  final int user_id;
  final int listaId;
  final String nombre;

  ListaProductosScreen({
    required this.user_id,
    required this.listaId,
    required this.nombre
  });

  @override
  State<ListaProductosScreen> createState() => _ListasProductosState();
}

class _ListasProductosState extends State<ListaProductosScreen> {
  final Dio _dio = Dio();

  List<ListaProducto> listas_productos = [];

  _ListasProductosState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getListasProductos().then((value) {
      setState(() {
        listas_productos = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: widget.user_id));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.nombre),
          backgroundColor: Color(0xFFF01815),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: ElevatedButton(
                          onPressed: (){
                            BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: widget.user_id));
                          },
                          child: Text('< Regresar')
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(right: 15, top: 10),
                      child: ElevatedButton(
                          onPressed: (){
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditListaProductos(listaId: widget.listaId, listaNombre: widget.nombre, listaProductoId: null, user_id: widget.user_id));
                          },
                          child: Text('Agregar producto +')
                      ),
                    ),
                  ],
                ),
                !isLoading ? Column(
                    children: List.generate(listas_productos.length, (index) {
                      return listaItem(listas_productos[index]);
                    })
                ) : Center(
                  child: CircularProgressIndicator(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget listaItem(ListaProducto listaProducto){

    return Dismissible(
      key: Key(listaProducto.id.toString()),
      onDismissed: (direction) {
        setState(() {
          listas_productos.remove(listaProducto);
          deleteProductCategory(listaProducto.id).then((value) {
            if (value['data'] == 'true' || value['data'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto eliminado'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar el producto'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
            }
          });
        });
      },
      child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              //boxshadow

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      listaProducto.producto_nombre,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Cantidad: ${listaProducto.cantidad}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Container(
                    child: Text(
                      'Precio: \$${listaProducto.precio_compra}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Total: \$${listaProducto.cantidad * listaProducto.precio_compra}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    BlocProvider.of<NavigatorBloc>(context).add(GoEditListaProductos(listaId: widget.listaId, listaNombre: widget.nombre, listaProductoId: null, user_id: widget.user_id));
                  }, child: Text('Editar')),

                ],
              )
            ],
          )
      ),
    );
  }

  Future<List<ListaProducto>> getListasProductos() async {

    try {

      Response response = await _dio.get("/ListaProductos",
          queryParameters: {
            "lista_id": widget.listaId
          },
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
                //accept text plain
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response.data);

      List<ListaProducto> listaProducto = (response.data['data'] as List).map((e) => ListaProducto.fromJson(e)).toList();

      return listaProducto;

    } catch (e) {

      print('ERROR');
      print(e);

      return [];

    }
  }


  Future<Map> deleteProductCategory(int id) async {
    try {
      print('DELETE PRODUCT CATEGORY');

      Response response = await _dio.delete("/Products",
          queryParameters: {
            "id": id
          },
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
                //accept text plain
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response);

      return response.data;

    } catch (e) {
      return {};
    }
  }
}


