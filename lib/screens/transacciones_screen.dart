import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/product.dart';
import 'package:dotnet/models/transaccion.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/balance.dart';


class TransaccionesScreen extends StatefulWidget {

  final int user_id;
  TransaccionesScreen({required this.user_id});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  final Dio _dio = Dio();

  List<Transaccion> transacciones = [];

  _TransaccionesScreenState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  bool isLoading = false;
  Balance? balance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getTransacciones().then((value) {
      setState(() {
        transacciones = value;
      });
    });

    getBalance(1).then((value) {
      print('BALANCE');
      balance = value;
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        //BlocProvider.of<NavigatorBloc>(context).add(GoHome());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transacciones'),
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditTransaction(transactionId: null, balance: balance, user_id: widget.user_id));
                          },
                          child: Text('Agregar +')
                      ),
                    ),
                  ],
                ),

                balance != null ? Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                //width: double.infinity,
                                child: Text(
                                  "Saldo: \$"+balance!.saldo.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ) : Container(),

                !isLoading ? Container(
                  child: transacciones.isNotEmpty ? Column(
                      children: List.generate(transacciones.length, (index) {
                        return transaccionItem(transacciones[index]);
                      })
                  ) : Center(
                    child: Text('No hay transacciones'),
                  )
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

  Widget transaccionItem(Transaccion transaccion){

    DateTime? fecha = DateTime.tryParse(transaccion.fecha);

    String formatDateTime(DateTime dateTime) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }


    return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: transaccion.tipo == 'entrada' ? Colors.green : Colors.red,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //width: double.infinity,
                      child: Text(
                        "\$"+transaccion.monto.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      child: Text(
                        transaccion.tipo.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    formatDateTime(fecha!),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    transaccion.descripcion,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
            /*Row(
              children: [
                ElevatedButton(onPressed: (){
                  BlocProvider.of<NavigatorBloc>(context).add(GoEditTransaction(transactionId: transaccion.id, balance: balance));
                }, child: Text('Editar')),
              ],
            )*/
          ],
        )
    );
  }

  Future<List<Transaccion>> getTransacciones() async {
    try {
      print('GET TRANSACCIONES');

      Response response = await _dio.get("/Transacciones",
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

      if(response.data['data'] == null || response.data['data'].isEmpty || response.data['data'].length == 0) {
        return [];
      }

      List<Transaccion> transacciones = (response.data['data'] as List).map((transaccion) {
        return Transaccion.fromJson(transaccion);
      }).toList();

      return transacciones;
    } catch (e) {
      print('ERROR');
      print(e);
      return [];
    }
  }


  Future<Balance?> getBalance(int userId) async {
    try {
      print('GET BALANCE');

      Response response = await _dio.get("/Balances/user/$userId",
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

      if (response.data['data'] != null) {
        return Balance.fromJson(response.data['data']);
      } else {
        return null;
      }

    } catch (e) {
      print('ERROR');
      print(e);
      return null;
    }
  }

  //delete transaccion
  Future<Map> deleteTransaccion(int id) async {
    try {
      print('DELETE TRANSACCION');

      Response response = await _dio.delete("/Transacciones",
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


