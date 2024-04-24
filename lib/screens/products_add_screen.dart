import 'package:dio/dio.dart';
import 'package:dotnet/bloc/navigator/navigator_bloc.dart';
import 'package:dotnet/utils/configuracion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' as io;

import '../models/productCategory.dart';


class ProductEdit extends StatefulWidget {

  final int? productId;
  ProductEdit({this.productId});

  @override
  State<ProductEdit> createState() => _ProductCategoryEditState();
}

class _ProductCategoryEditState extends State<ProductEdit> {

  final Dio _dio = Dio();

  _ProductCategoryEditState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  TextEditingController txtCategoryName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.productId != null){
      getProductById(widget.productId!).then((value) {

        print('VALUE');
        print(value);

        setState(() {
          txtCategoryName.text = value.name;
          txtDescription.text = value.description;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos Screen'),
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
                      BlocProvider.of<NavigatorBloc>(context).add(GoProducts());
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
                      controller: txtCategoryName,
                    ),
                    SizedBox(height: 20),

                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      controller: txtDescription,
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              isLoading = true;
                            });

                            if(widget.productId != null){
                              updateProductCategory(txtCategoryName.text, txtDescription.text);
                            } else {
                              saveProductCategory(txtCategoryName.text, txtDescription.text);
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
    );
  }

  Future getProductById(int productId) async {
    try {

      print('PRODUCT ID');
      print(productId);

      Response response = await _dio.get("/Products/$productId",
          options: Options(
              headers: {
                io.HttpHeaders.acceptHeader: "application/json",
              },
              responseType: ResponseType.json
          )
      );

      print('RESPONSE');
      print(response.data);

      ProductCategory productCategory = ProductCategory.fromJson(response.data['data']);

      return productCategory;

    } catch (e) {

      return [];

    }
  }

  Future saveProductCategory(String categoryName, String description) async {
    try {


      print('SAVE PRODUCT CATEGORY');

      Response response = await _dio.post("/Products",
          data: {
            "id": 0,
            "name": categoryName,
            "description": description
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
        BlocProvider.of<NavigatorBloc>(context).add(GoProducts());
        return;
      }

    } catch (e) {

      return [];

    }
  }


  Future updateProductCategory(String categoryName, String description) async {
    try {

      print('UPDATE PRODUCT CATEGORY');

      Response response = await _dio.put("/Products",
          data: {
            "id": widget.productId,
            "name": categoryName,
            "description": description
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
        BlocProvider.of<NavigatorBloc>(context).add(GoProducts());
        return;
      }

    } catch (e) {

      return [];

    }catch(e){
      return [];
    }
  }

}