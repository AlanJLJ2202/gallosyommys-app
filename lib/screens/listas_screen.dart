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


class ListasScreen extends StatefulWidget {

  int user_id;
  ListasScreen({required this.user_id});

  @override
  State<ListasScreen> createState() => _ListasState();
}

class _ListasState extends State<ListasScreen> {
  final Dio _dio = Dio();

  List<ListaCompra> listas_compras = [];

  _ListasState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getListas().then((value) {
      setState(() {
        listas_compras = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigatorBloc>(context).add(GoMain(user_id: widget.user_id));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Listas de compra'),
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoMain(user_id: widget.user_id));
                          },
                          child: Text('< Regresar')
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(right: 15, top: 10),
                      child: ElevatedButton(
                          onPressed: (){
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditLista(listaId: null, user_id: widget.user_id));
                          },
                          child: Text('Agregar +')
                      ),
                    ),
                  ],
                ),
                !isLoading ? Column(
                    children: List.generate(listas_compras.length, (index) {
                      return listaItem(listas_compras[index]);
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

  Widget listaItem(ListaCompra listaCompra){

    DateTime fecha = DateFormat('MM/dd/yyyy HH:mm:ss').parse(listaCompra.fecha);

    String formatDateTime(DateTime dateTime) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    return Dismissible(
      key: Key(listaCompra.id.toString()),
      onDismissed: (direction) {
        setState(() {
          listas_compras.remove(listaCompra);
          deleteProductCategory(listaCompra.id).then((value) {
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
                      listaCompra.nombre,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      formatDateTime(fecha!),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    BlocProvider.of<NavigatorBloc>(context).add(GoEditLista(listaId: listaCompra.id, user_id: widget.user_id));
                  }, child: Text('Editar')),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: (){
                    BlocProvider.of<NavigatorBloc>(context).add(GoListaProductos(listaId: listaCompra.id, listaNombre: listaCompra.nombre, user_id: widget.user_id));
                  }, child: Text('Productos')),
                ],
              )
            ],
          )
      ),
    );
  }

  Future<List<ListaCompra>> getListas() async {

    try {

      Response response = await _dio.get("/ListaCompras",
          queryParameters: {
            "user_id": widget.user_id
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

      List<ListaCompra> listasCompra = (response.data['data'] as List).map((e) => ListaCompra.fromJson(e)).toList();

      return listasCompra;

    } catch (e) {

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


