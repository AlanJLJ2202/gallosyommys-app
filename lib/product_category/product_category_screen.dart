import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/models/productCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_bloc/flutter_bloc.dart';


class ProductCategoryScreen extends StatefulWidget {
  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final Dio _dio = Dio();

  List<ProductCategory> productCategories = [];

  _ProductCategoryScreenState() {
    _dio.options.baseUrl = 'http://localhost:5081/api';
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
          title: Text('Product Category'),
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
                            BlocProvider.of<NavigatorBloc>(context).add(GoEditProductCategory());
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
                    productCategory.name,
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
                ElevatedButton(onPressed: (){}, child: Text('Editar')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: (){}, child: Text('Eliminar'))
              ],
            )
          ],
        )
    );
  }

  Future<List<ProductCategory>> getProductCategories() async {

    try {

      Response response = await _dio.get("/ProductCategories",
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
                //accept text plain
              },
              responseType: ResponseType.json
          )
      );

      List<ProductCategory> productCategories = (response.data['data'] as List).map((e) => ProductCategory.fromJson(e)).toList();

      return productCategories;

    } catch (e) {

      return [];

    }
  }
}


