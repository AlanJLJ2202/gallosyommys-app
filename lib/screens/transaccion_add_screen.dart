import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;

import '../models/balance.dart';
import '../models/product.dart';
import '../models/transaccion.dart';


class TransaccionEdit extends StatefulWidget {

  final int user_id;
  final int? transaccionId;
  final Balance? balance;
  TransaccionEdit({
    required this.user_id,
    this.transaccionId,
    required this.balance});

  @override
  State<TransaccionEdit> createState() => _TransaccionEditState();
}

class _TransaccionEditState extends State<TransaccionEdit> {

  final Dio _dio = Dio();

  _TransaccionEditState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  TextEditingController txtMonto = TextEditingController();
  TextEditingController txtFecha = TextEditingController();
  TextEditingController txtDescripcion = TextEditingController();
  String? tipo;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.transaccionId != null){
      isLoading = true;
      getTransaccionById(widget.transaccionId!).then((value) {
        setState(() {
          txtMonto.text = value.name;
          txtFecha.text = value.description;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigatorBloc>(context).add(GoTransactions(user_id: widget.user_id));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Transacciones Screen'),
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoTransactions(user_id: widget.user_id));
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
                                hintText: 'Monto',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            controller: txtMonto,
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

                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Descripcion',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            controller: txtDescripcion,
                          ),

                          Row(
                            children: [
                              Text('Tipo: ', style: TextStyle(fontSize: 20)),
                              Radio(
                                value: 'entrada',
                                groupValue: tipo,
                                onChanged: (value) {
                                  setState(() {
                                    tipo = value.toString();
                                  });
                                },
                              ),
                              Text('Entrada'),
                              Radio(
                                value: 'salida',
                                groupValue: tipo,
                                onChanged: (value) {
                                  setState(() {
                                    tipo = value.toString();
                                  });
                                },
                              ),
                              Text('Salida'),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: (){

                                  if(txtMonto.text.isEmpty || txtFecha.text.isEmpty || txtDescripcion.text.isEmpty || tipo == null){

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Todos los campos son requeridos'),
                                        duration: Duration(seconds: 3),
                                      )
                                    );

                                    return;
                                  }


                                  if(tipo == 'salida' && widget.balance != null && widget.balance!.saldo < int.parse(txtMonto.text)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('No tienes suficiente saldo'),
                                          duration: Duration(seconds: 3),
                                        )
                                    );

                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  if(widget.transaccionId != null){
                                    updateTransaccion(int.parse(txtMonto.text), txtFecha.text, tipo!, txtDescripcion.text);
                                  } else {
                                    saveTransaccion(int.parse(txtMonto.text), txtFecha.text, tipo!, txtDescripcion.text);
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


  Future getTransaccionById(int transaccionId) async {
    try {

      print('Transaccion ID');
      print(transaccionId);

      Response response = await _dio.get("/Transacciones/$transaccionId",
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response.data);

      Transaccion transaccion = Transaccion.fromJson(response.data['data']);

      return transaccion;

    } catch (e) {

      return [];

    }
  }

  Future saveTransaccion(int monto, String fecha, String tipo, String descripcion) async {
    try {
      print('SAVE TRANSACCION');
      print(monto);
      print(fecha);
      print(tipo);
      print(descripcion);

      Response response = await _dio.post("/Transacciones",
          data: {
            "id": 0,
            "user_id": 1, //TODO: Cambiar por el usuario logueado "user_id": "1
            "monto": monto,
            "fecha": fecha,
            "tipo": tipo,
            "descripcion": descripcion
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
        //isLoading = false;
        await saveBalance(widget.balance, monto, tipo);
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

  Future updateTransaccion(int monto, String fecha, String tipo, String descripcion) async {
    try {

      print('UPDATE PRODUCT CATEGORY');

      Response response = await _dio.put("/Products",
          data: {
            "id": widget.transaccionId,
            "user_id": 1, //TODO: Cambiar por el usuario logueado "user_id": "1
            "monto": monto,
            "fecha": fecha,
            "tipo": tipo,
            "descripcion": descripcion
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
        BlocProvider.of<NavigatorBloc>(context).add(GoProducts(user_id: widget.user_id));
        return;
      }

    } catch (e) {

      return [];

    }catch(e){
      return [];
    }
  }

}