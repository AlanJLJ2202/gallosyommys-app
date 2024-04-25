import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/categoria.dart';
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


class CategoriaEditScreen extends StatefulWidget {

  final int user_id;
  final int? categoriaId;
  CategoriaEditScreen({
    required this.user_id,
    this.categoriaId});

  @override
  State<CategoriaEditScreen> createState() => _CategoriaEditState();
}

class _CategoriaEditState extends State<CategoriaEditScreen> {

  final Dio _dio = Dio();

  _CategoriaEditState() {
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
    if(widget.categoriaId != null){
      isLoading = true;

      getCategoriaById(widget.categoriaId!).then((value) {
        setState(() {
          txtNombre.text = value.nombre;
          isLoading = false;
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigatorBloc>(context).add(GoCategorias(user_id: widget.user_id));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Categoria Screen'),
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoCategorias(user_id: widget.user_id));
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
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: (){

                                  if(txtNombre.text.isEmpty){
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

                                  if(widget.categoriaId != null){
                                    updateCategoria(txtNombre.text);
                                  } else {
                                    saveCategoria(txtNombre.text);
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


  Future getCategoriaById(int categoriaId) async {
    try {

      print('categoriaId');
      print(categoriaId);

      Response response = await _dio.get("/Categorias/$categoriaId",
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response.data);

      Categoria categoria = Categoria.fromJson(response.data['data']);

      return categoria;

    } catch (e) {

      return [];

    }
  }

  Future saveCategoria(String nombre) async {
    try {

      Response response = await _dio.post("/Categorias",
          data: {
            "id": 0,
            "user_id": 1,
            "nombre": nombre
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Categoria guardada'),
              backgroundColor: Colors.green,
            )
        );
        BlocProvider.of<NavigatorBloc>(context).add(GoCategorias(user_id: widget.user_id));
        return;
      }

    } catch (e) {

      return [];

    }
  }

  Future updateCategoria(String nombre) async {
    try {

      print('UPDATE PRODUCT CATEGORY');

      Response response = await _dio.put("/Categorias",
          data: {
            "id": widget.categoriaId,
            "user_id": 1,
            "nombre": nombre
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Categoria actualizada'),
              backgroundColor: Colors.green,
            )
        );
        BlocProvider.of<NavigatorBloc>(context).add(GoCategorias(user_id: widget.user_id));
        return;
      }

    } catch (e) {

      return [];

    }catch(e){
      return [];
    }
  }

}