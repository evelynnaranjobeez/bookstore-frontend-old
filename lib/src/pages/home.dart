import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/home_controller.dart';
import 'books_page.dart'; // Importar la página de libros

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState(HomeController());
}

class _HomePageState extends StateMVC<HomePage> {
  HomeController? _con;
  Widget currentPage = Center(child: Text('Bienvenido a la Home Page')); // Página por defecto

  _HomePageState(HomeController controller) : super(controller) {
    _con = controller;
  }

  @override
  void initState() {
    _con!.getRoleOfUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Row(
        children: [
          // Drawer siempre visible
          Container(
            width: 250.0, // Ajustar el ancho del Drawer
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Menu 1'),
                  onTap: () {
                    // Mostrar la página de libros al seleccionar el menú 1
                    setState(() {
                      currentPage = BooksPage(controller: _con!); // Cargar la página de libros con paginación
                    });
                  },
                ),
                _con!.role == 'admin'
                    ? ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Menu 2'),
                  onTap: () {
                    // Acción para otro menú
                  },
                )
                    : Container(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesión'),
                  onTap: () {
                    _con!.logout();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          // Contenido de la página principal (cambia dinámicamente según el menú seleccionado)
          Expanded(
            child: currentPage,
          ),
        ],
      ),
    );
  }
}
