import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List> pegarFotos() async {
    var url = Uri.parse('https://api.thecatapi.com/v1/images/search');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao carregar dados da Api');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: (){},
        ),
        title: Text('Meu gato miau'),
      ),
      body: FutureBuilder<List>(
          future: pegarFotos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao carregar fotos"),);
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.network(snapshot.data[index]['url'])
                    ],
                  );
                },);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}
