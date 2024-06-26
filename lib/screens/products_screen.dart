import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/product.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_bloc/flutter_bloc.dart';


class ProductsScreen extends StatefulWidget {

  final int user_id;
  ProductsScreen({required this.user_id});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Dio _dio = Dio();

  List<Product> productCategories = [];

  _ProductsScreenState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getProductCategories().then((value) {
      setState(() {
        productCategories = value;
        isLoading = false;
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditProduct(productoId: null, user_id: widget.user_id));
                          },
                          child: Text('Agregar +')
                      ),
                    ),
                  ],
                ),
                !isLoading ? Column(
                  children: List.generate(productCategories.length, (index) {
                    return productCategoryItem(productCategories[index]);
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

  Widget productCategoryItem(Product productCategory){
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
                  Container(
                    child: Text(
                      'Precio de compra: \$${productCategory.precio_compra}',
                      style: TextStyle(
                          fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    BlocProvider.of<NavigatorBloc>(context).add(GoEditProduct(productoId: productCategory.id, user_id: widget.user_id));
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

  Future<List<Product>> getProductCategories() async {
    try {
      Response response = await _dio.get("/products",
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

      List<Product> productCategories = (response.data['data'] as List).map((e) => Product.fromJson(e)).toList();

      return productCategories;

    } catch (e) {

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


