import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigator/navigator_bloc.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gallo's Yommys"),
        //hexadecimal color
        backgroundColor: Color(0xFFF01815),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              menuItem('Transacciones', () {

              }, width),
              menuItem('Listas de compra', () {

              }, width),
              menuItem('Productos', () {
                BlocProvider.of<NavigatorBloc>(context).add(GoProducts());
              }, width),
          ],
        ),
      ),
    );
  }


  Widget menuItem(String label, Function() onTap, double width) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(label, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
