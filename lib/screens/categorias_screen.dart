import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/categoria.dart';
import 'package:dotnet/models/product.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_bloc/flutter_bloc.dart';


class CategoriasScreen extends StatefulWidget {

  final int user_id;
  CategoriasScreen({required this.user_id});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final Dio _dio = Dio();

  List<Categoria> categorias = [];

  _CategoriasScreenState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getCategorias().then((value) {
      setState(() {
        categorias = value;
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
          title: Text('Categorias'),
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditCategoria(categoriaId: null, user_id: widget.user_id));
                          },
                          child: Text('Agregar +')
                      ),
                    ),
                  ],
                ),
                !isLoading ? Column(
                    children: List.generate(categorias.length, (index) {
                      return CategoriaItem(categorias[index]);
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

  Widget CategoriaItem(Categoria categoria){
    return Dismissible(
      key: Key(categoria.id.toString()),
      onDismissed: (direction) {
        setState(() {
          categorias.remove(categoria);
          deleteCategoria(categoria.id).then((value) {
            if (value['data'] == 'true' || value['data'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Categoria eliminada'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar la categoria'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
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
                      categoria.nombre,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    BlocProvider.of<NavigatorBloc>(context).add(GoEditCategoria(categoriaId: categoria.id, user_id: widget.user_id));
                  }, child: Text('Editar')),
                  //SizedBox(width: 10),
                  //ElevatedButton(onPressed: (){}, child: Text('Eliminar'))
                ],
              )
            ],
          )
      ),
    );
  }

  Future<List<Categoria>> getCategorias() async {
    try {
      Response response = await _dio.get("/Categorias",
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
      print(response.data);

      List<Categoria> categorias = (response.data['data'] as List).map((e) => Categoria.fromJson(e)).toList();

      return categorias;

    } catch (e) {

      print(e);

      return [];

    }
  }


  Future<Map> deleteCategoria(int id) async {
    try {
      print('DELETE PRODUCT CATEGORY');

      Response response = await _dio.delete("/Categorias",
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


