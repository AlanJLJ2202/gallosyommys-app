import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/lista_compra.dart';
import 'package:dotnet/models/lista_producto.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;

import '../models/balance.dart';
import '../models/product.dart';


class ListasProductosEditScreen extends StatefulWidget {
  final int user_id;
  final int listaId;
  final String listaNombre;
  final int? listaProductoId;

  ListasProductosEditScreen({
    required this.user_id,
    required this.listaId,
    required this.listaNombre,
    this.listaProductoId
  });

  @override
  State<ListasProductosEditScreen> createState() => _ListasProductosEditState();
}

class _ListasProductosEditState extends State<ListasProductosEditScreen> {

  final Dio _dio = Dio();

  _ListasProductosEditState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtFecha = TextEditingController();
  TextEditingController txtDescripcion = TextEditingController();
  String? tipo;

  bool isLoading = false;
  List<Product> lista_productos = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = false;


    getProductCategories().then((value) {
      setState(() {
        lista_productos = value;
        isLoading = false;
      });
    });



    /*if(widget.listaId != null){
      //isLoading = true;

      getListaById(widget.listaId!).then((value) {
        setState(() {
          txtNombre.text = value.nombre;


          //parse date
          DateTime fecha = DateFormat('MM/dd/yyyy HH:mm:ss').parse(value.fecha);
          txtFecha.text = DateFormat('yyyy-MM-dd').format(fecha);

          isLoading = false;
        });
      });

    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigatorBloc>(context).add(GoListaProductos(listaId: widget.listaId!, listaNombre: widget.listaNombre!, user_id: widget.user_id));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Listas Screen'),
            backgroundColor: Color(0xFFF01815),
          ),
          body: !isLoading ? ListView(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(onPressed: (){
                            BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: widget.user_id));
                          }, child: Text('Regresar')),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        children: [
                          !isLoading ? Column(
                              children: List.generate(lista_productos.length, (index) {
                                return productCategoryItem(lista_productos[index]);
                              })
                          ) : Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ]
          ) : Center(
            child: CircularProgressIndicator(),
          )
      ),
    );
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();

    /*if(controller.text.isNotEmpty) {
      initialDate = DateFormat('dd-MM-yyyy').parse(controller.text);
    }*/

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1923),
        lastDate: DateTime.now()
    );

    if(picked != null){
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future getListaById(int listaId) async {
    try {

      print('Transaccion ID');
      print(listaId);

      Response response = await _dio.get("/ListaCompras/$listaId",
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response.data);

      ListaCompra listaCompra = ListaCompra.fromJson(response.data['data']);

      return listaCompra;

    } catch (e) {

      return [];

    }
  }

  Future saveListaProducto(Product producto, int cantidad) async {
    try {

      Response response = await _dio.post("/ListaProductos",
          data: {
            "id": 0,
            "lista_compra_id": widget.listaId,
            "producto_id": producto.id,
            "cantidad": cantidad,
            "precio_compra": producto.precio_compra,
            "producto_nombre": producto.name,
            "producto_descripcion": producto.description
          },
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response.data['errors']);

      if(response.data['errors'] == [] || response.data['errors'] == null || response.data['errors'].length == 0){
        print('NO HAY ERRORES');
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto agregado a la lista'), backgroundColor: Colors.green));
        BlocProvider.of<NavigatorBloc>(context).add(GoListaProductos(listaId: widget.listaId, listaNombre: widget.listaNombre, user_id: widget.user_id));
        return;
      }

    } catch (e) {

      return [];

    }
  }

  Future saveBalance(Balance? balance, int monto, String tipo) async {
    try {
      print('SAVE BALANCE');

      int saldo_actual = 0;
      if(balance != null){
        saldo_actual = balance.saldo;
      }

      if(tipo == 'entrada'){
        saldo_actual = saldo_actual + monto;
      }else{
        saldo_actual = saldo_actual - monto;
      }

      Response response = await _dio.post("/Balances",
          data: {
            "id": 0,
            "user_id": 1, //TODO: Cambiar por el usuario logueado "user_id": "1
            "saldo": saldo_actual
          },
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      //List<ProductCategory> productCategories = (response.data['data'] as List).map((e) => ProductCategory.fromJson(e)).toList();

      print('RESPONSE');
      print(response.data['errors']);

      if(response.data['errors'] == [] || response.data['errors'] == null || response.data['errors'].length == 0){
        print('NO HAY ERRORES');
        isLoading = false;
        BlocProvider.of<NavigatorBloc>(context).add(GoTransactions(user_id: widget.user_id));
        return;
      }

    } catch (e) {

      return [];

    }
  }

  Future updateLista(String nombre, String fecha) async {
    try {

      print('UPDATE PRODUCT CATEGORY');

      Response response = await _dio.put("/ListaCompras",
          data: {
            "id": widget.listaProductoId,
            "user_id": 1,
            "nombre": nombre,
            "fecha": fecha
          },
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      //List<ProductCategory> productCategories = (response.data['data'] as List).map((e) => ProductCategory.fromJson(e)).toList();

      print('RESPONSE');
      print(response.data);

      if(response.data['errors'] == [] || response.data['errors'] == null || response.data['errors'].length == 0){
        print('NO HAY ERRORES');
        isLoading = false;
        BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: widget.user_id));
        return;
      }

    } catch (e) {

      return [];

    }catch(e){
      return [];
    }
  }

  Future<List<Product>> getProductCategories() async {
    try {
      Response response = await _dio.get("/products",
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
                //accept text plain
              },
              responseType: ResponseType.json
          )
      );
      print(response.data);

      List<Product> productCategories = (response.data['data'] as List).map((e) => Product.fromJson(e)).toList();

      return productCategories;

    } catch (e) {

      return [];

    }
  }

  Widget productCategoryItem(Product productCategory){
    return Container(
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
                      productCategory.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      productCategory.description,
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

                    TextEditingController txtCantidad = TextEditingController();

                    //show dialog with 2 text fields
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Agregar ${productCategory.name}'),
                          content: Container(
                            height: 60,
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Cantidad',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: txtCantidad,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(onPressed: (){
                              //close dialog
                              Navigator.of(context).pop();
                            }, child: Text('Cancelar')),
                            ElevatedButton(onPressed: () async {
                              Navigator.of(context).pop();

                              await saveListaProducto(productCategory, int.parse(txtCantidad.text));

                            }, child: Text('Agregar')),

                          ],
                        );
                      }
                    );

                  }, child: Text('Agregar')),
                  //SizedBox(width: 10),
                  //ElevatedButton(onPressed: (){}, child: Text('Eliminar'))
                ],
              )
            ],
          )
    );
  }



}