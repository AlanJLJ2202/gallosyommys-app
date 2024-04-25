import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigator/navigator_bloc.dart';

class MenuScreen extends StatelessWidget {

  int user_id;
  MenuScreen({required this.user_id});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gallo's Yommys"),
        //hexadecimal color
        backgroundColor: Color(0xFFF01815),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Cerrar sesión'),
              onTap: () {
                BlocProvider.of<NavigatorBloc>(context).add(GoLogin());
              },
            ),
          ],
        ),
      ),
      body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

              Center(
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.1, bottom: 100),
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
                        width: 200,
                      ),
                    ),
                ),
              ),
              menuItem('Transacciones', () {
                BlocProvider.of<NavigatorBloc>(context).add(GoTransactions(user_id: user_id));
              }, width, Icons.attach_money),
              menuItem('Listas de compra', () {
                BlocProvider.of<NavigatorBloc>(context).add(GoListas(user_id: user_id));
              }, width, Icons.shopping_cart),
              menuItem('Productos', () {
                BlocProvider.of<NavigatorBloc>(context).add(GoProducts(user_id: user_id));
              }, width, Icons.shopping_basket),
              menuItem('Categorias', () {
                BlocProvider.of<NavigatorBloc>(context).add(GoCategorias(user_id: user_id));
              }, width, Icons.category),
          ],

      ),
    );
  }


  Widget menuItem(String label, Function() onTap, double width, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      width: width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFF01815),
          elevation: 10,
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontSize: 20)),
            Spacer(),
            Icon(icon)
          ],
        ),
      ),
    );
  }
}
