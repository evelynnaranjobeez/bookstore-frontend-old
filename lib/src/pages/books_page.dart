import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../models/book.dart';
import '../controllers/home_controller.dart';

class BooksPage extends StatefulWidget {
  final HomeController controller;

  const BooksPage({required this.controller, super.key});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  double? _width;
  double? _height;
  int currentPage = 0;
  int rowsPerPage = 10;
  int totalBooks = 0;
  List<Book> books = [];
  bool loading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fetch books on page load
  }

  // Fetch books using HomeController
  Future<void> fetchBooks() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await widget.controller
          .fetchBooks(rowsPerPage, currentPage * rowsPerPage, searchQuery);
      setState(() {
        books = response.data!;
        totalBooks = response.total!;
        // Ensure currentPage is valid if totalBooks change
        if (currentPage >= (totalBooks / rowsPerPage).ceil()) {
          currentPage = 0;
        }
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      print("Error fetching books: $error");
    }
  }

  void _viewBook(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Libro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Título: ${book.title}'),
              Text('Autor: ${book.author!.name}'),
              Text('Año: ${book.year}'),
              Text('Género: ${book.genre}'),
              Text('Descripción: ${book.description}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }


  void _editBook(Book book) {
    TextEditingController titleController = TextEditingController(text: book.title);
    TextEditingController yearController = TextEditingController(text: book.year.toString());
    TextEditingController genreController = TextEditingController(text: book.genre);
    TextEditingController descriptionController = TextEditingController(text: book.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Libro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Año'),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: 'Género'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async{
                // Here you would handle the update logic
                book.title = titleController.text;
                book.year = int.tryParse(yearController.text) ?? book.year;
                book.genre = genreController.text;
                book.description = descriptionController.text;

                // Call a function to save the updated book
                String response=await widget.controller.updateBook(book);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response),
                  duration: const Duration(seconds: 10),
                ));
               // Refresh the books list
                fetchBooks();

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }



  void _deleteBook(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Libro'),
          content: Text('¿Estás seguro de que deseas eliminar el libro "${book.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Here you would handle the delete logic
                String response=await widget.controller.deleteBook(book.id!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response),
                  duration: const Duration(seconds: 10),
                ));
                // Refresh the books list
                fetchBooks();

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    var isMobile = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    int totalPages = (totalBooks / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 30, right: 30, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Search Bar
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          // Change search bar color
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: isMobile ? _width! * 0.4 : _width! * 0.5,
                        height: _height! * 0.055,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: isMobile ? 5 : 20, top: 5),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) => EasyDebounce.debounce(
                              'searchBooks',
                              const Duration(milliseconds: 500),
                              () {
                                setState(() {
                                  searchQuery = value;
                                  currentPage = 0; // Reset to the first page
                                  fetchBooks(); // Fetch books with the search query
                                });
                              },
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: InputBorder.none,
                              label: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Icon(Icons.search,
                                      color: Colors.blue.shade800),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Buscar libros...',
                                    style: TextStyle(
                                        color: Colors.blue.shade800,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: _height! * 0.055,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            const Text(
                              'MOSTRAR',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromARGB(255, 118, 117, 117)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: isMobile ? _width! * 0.1 : _width! * 0.035,
                              height: _height! * 0.03,
                              child: DropdownButton<int>(
                                focusColor: Colors.transparent,
                                dropdownColor: Colors.white,
                                underline: Container(),
                                isExpanded: true,
                                value: rowsPerPage,
                                items: [10, 20, 30, 50, 100].map((value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child:
                                        Center(child: Text(value.toString())),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    rowsPerPage = value!;
                                    currentPage = 0; // Reset to the first page
                                    fetchBooks(); // Fetch books when the limit changes
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'REGISTROS',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color:
                                      const Color.fromARGB(255, 118, 117, 117)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isMobile ? const SizedBox(height: 20) : Container(),
                  !loading
                      ? Container(
                          margin: const EdgeInsets.only(top: 30),
                          height: 40.0,
                          child: Row(
                            children: <Widget>[
                              buildContainerTitle('ID', width: _width! * 0.05),
                              buildContainerTitle('TÍTULO'),
                              buildContainerTitle('AUTOR'),
                              buildContainerTitle('AÑO'),
                              buildContainerTitle('GÉNERO'),
                              Expanded(child: Container()),
                              Container(
                                  padding: const EdgeInsets.all(4.0),
                                  // width: _width! * 0.2,
                                  child:  Text("ACCIONES", style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.black))),
                            ],
                          ),
                        )
                      : Container(),
                  !loading
                      ? Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: books
                                .map(
                                  (book) => Container(
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextFieldBook(
                                            width: _width! *0.05, text: book.id.toString()),
                                        TextFieldBook(
                                            width: _width! *0.15 , text: book.title!),
                                        TextFieldBook(
                                            width: _width! *0.15 ,
                                            text: book.author!.name!),
                                        TextFieldBook(
                                            width: _width! *0.15 ,
                                            text: book.year.toString()),
                                        TextFieldBook(
                                            width: _width! *0.15 , text: book.genre!),
                                        Expanded(child: Container()),
                                        IconButton(
                                          icon: Icon(Icons.visibility,
                                              color: Colors.blue.shade700),
                                          onPressed: () => _viewBook(book),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.green.shade700),
                                          onPressed: () => _editBook(book),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red.shade700),
                                          onPressed: () => _deleteBook(book),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                  if (!loading && totalPages > 0)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        width: 500,
                        height: 40,
                        child: NumberPaginator(
                          config: const NumberPaginatorUIConfig(
                            buttonUnselectedForegroundColor: Colors.black,
                          ),
                          initialPage: currentPage, // Keep the current page
                          numberPages: totalPages,
                          onPageChange: (index) {
                            setState(() {
                              currentPage = index;
                              fetchBooks(); // Fetch books when the page changes
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildContainerTitle(String text, {double? width}) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        width: width ?? _width! * 0.15,
        child: Text(text, style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.black)));
  }
}

class TextFieldBook extends StatelessWidget {
  const TextFieldBook({
    super.key,
    required double? width,
    required String text,

  })  : _width = width,
        _text = text;

  final double? _width;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: _width!,
      child: Text(_text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black)),
    );
  }
}
