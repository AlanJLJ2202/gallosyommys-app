import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/lista_compra.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;

import '../models/balance.dart';
import '../models/product.dart';
import '../models/transaccion.dart';


class ListasEditScreen extends StatefulWidget {

  final int user_id;
  final int? listaId;
  ListasEditScreen({
    required this.user_id,
    this.listaId});

  @override
  State<ListasEditScreen> createState() => _ListasEditState();
}

class _ListasEditState extends State<ListasEditScreen> {

  final Dio _dio = Dio();

  _ListasEditState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtFecha = TextEditingController();
  TextEditingController txtDescripcion = TextEditingController();
  String? tipo;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.listaId != null){
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

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: widget.user_id));
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
                          Text('Agregar', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Nombre',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            controller: txtNombre,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Fecha',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            controller: txtFecha,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await _selectDate(context, txtFecha);
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: (){

                                  if(txtNombre.text.isEmpty || txtFecha.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Todos los campos son requeridos'),
                                          duration: Duration(seconds: 3),
                                        )
                                    );
                                    return;
                                  }


                                  /*if(tipo == 'salida' && widget.balance != null && widget.balance!.saldo < int.parse(txtMonto.text)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('No tienes suficiente saldo'),
                                          duration: Duration(seconds: 3),
                                        )
                                    );

                                    return;
                                  }*/

                                  setState(() {
                                    isLoading = true;
                                  });

                                  if(widget.listaId != null){
                                    updateLista(txtNombre.text, txtFecha.text);
                                  } else {
                                    saveLista(txtNombre.text, txtFecha.text);
                                  }
                                },
                                child: Text('Guardar')
                            ),
                          ),
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

  Future saveLista(String nombre, String fecha) async {
    try {

      Response response = await _dio.post("/ListaCompras",
          data: {
            "id": 0,
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

      print('RESPONSE');
      print(response.data['errors']);

      if(response.data['errors'] == [] || response.data['errors'] == null || response.data['errors'].length == 0){
        print('NO HAY ERRORES');
        isLoading = false;
        BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: widget.user_id));
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
            "id": widget.listaId,
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

}