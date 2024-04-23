import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' as io;

import '../models/productCategory.dart';


class ProductCategoryEdit extends StatefulWidget {
  @override
  State<ProductCategoryEdit> createState() => _ProductCategoryEditState();
}

class _ProductCategoryEditState extends State<ProductCategoryEdit> {

  final Dio _dio = Dio();

  _ProductCategoryEditState() {
    _dio.options.baseUrl = 'http://localhost:5081/api';
  }

  TextEditingController txtCategoryName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Category Edit'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: (){}, child: Text('Back')),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Agregar'),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Category Name'
                      ),
                      controller: txtCategoryName,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Description'
                      ),
                      controller: txtDescription,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          saveProductCategory(txtCategoryName.text, txtDescription.text);
                        },
                        child: Text('Save')
                    ),
                  ],
                ),
              )
            ],
          ),
        ]
      )
    );
  }


  Future saveProductCategory(String categoryName, String description) async {
    try {

      Response response = await _dio.post("/ProductCategories",

          data: {
            "id": 0,
            "name": categoryName,
            "description": description
          },

          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
                //accept text plain
              },
              responseType: ResponseType.json
          )
      );

      //List<ProductCategory> productCategories = (response.data['data'] as List).map((e) => ProductCategory.fromJson(e)).toList();

      print('RESPONSE');
      print(response.data);

      if(response.data['errors'] == []){
        BlocProvider.of<NavigatorBloc>(context).add(GoMain());
        return;
      }

    } catch (e) {

      return [];

    }
  }

}