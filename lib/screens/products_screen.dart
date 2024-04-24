import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/productCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_bloc/flutter_bloc.dart';


class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Dio _dio = Dio();

  List<ProductCategory> productCategories = [];

  _ProductsScreenState() {
    _dio.options.baseUrl = 'http://192.168.1.66:5000/api';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductCategories().then((value) {
      setState(() {
        productCategories = value;
      });
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
          title: Text('Productos'),
          backgroundColor: Color(0xFFF01815),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 10),
                      child: ElevatedButton(
                          onPressed: (){
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditProduct(productoId: null));
                          },
                          child: Text('Agregar +')
                      ),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(productCategories.length, (index) {
                    return productCategoryItem(productCategories[index]);
                  })
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget productCategoryItem(ProductCategory productCategory){
    return Dismissible(
      key: Key(productCategory.id.toString()),
      onDismissed: (direction) {
        setState(() {
          productCategories.remove(productCategory);
          deleteProductCategory(productCategory.id).then((value) {
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
                    BlocProvider.of<NavigatorBloc>(context).add(GoEditProduct(productoId: productCategory.id));
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

  Future<List<ProductCategory>> getProductCategories() async {

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

      List<ProductCategory> productCategories = (response.data['data'] as List).map((e) => ProductCategory.fromJson(e)).toList();

      return productCategories;

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


