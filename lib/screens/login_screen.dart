import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigator/navigator_bloc.dart';
import '../models/user.dart';
import '../utils/configuracion.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final Dio _dio = Dio();

  _LoginScreenState() {
    _dio.options.baseUrl = Configuracion.API_URL;
  }

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio de sesión"),
        //hexadecimal color
        backgroundColor: Color(0xFFF01815),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Center(
            child: Container(
              margin: EdgeInsets.only(top: height * 0.1, bottom: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle, // Esto establece la forma del contenedor como círculo

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],

              ),
              child: ClipOval( // Aquí aplicamos el ClipOval para hacer la imagen circular
                child: Image.asset(
                  'assets/images/logo_gallos.png',
                  width: 150,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  controller: txtEmail,
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'password',

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  controller: txtPassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () async {


                  if(txtEmail.text.isEmpty || txtPassword.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Todos los campos son requeridos'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                    return;
                  }

                  await login(txtEmail.text, txtPassword.text).then((user) {
                    if(user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bienvenido ${user.name}'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
                      BlocProvider.of<NavigatorBloc>(context).add(GoMain(user_id: user.id));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar sesión'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                    }
                  });

                }, child: Text('Iniciar sesión')),
              ],
            ),
          ),

        ],

      ),
    );
  }

  Future<User?> login(String email, String password) async {
    try {
      Response response = await _dio.post("/Users/login",
          data: {
            "id": 0,
            "name": "",
            "email": email,
            "password": password
          }
      );


      return User.fromJson(response.data['data']);

    } catch (e) {

      print(e);
      return null;
    }
  }
}
