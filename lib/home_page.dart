import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'colors.dart';

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

  Future<List> pegaNome() async {
    var url = Uri.parse('https://api.namefake.com');
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
      backgroundColor: color2,
      appBar: AppBar(
          backgroundColor: color1, title: Center(child: Text("The cutest cats you'll see today! maybe...", style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic
      ),))),
      body: FutureBuilder<List>(
          future: pegarFotos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao carregar fotos"),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              image: DecorationImage(
                                image:
                                    NetworkImage(snapshot.data[index]['url']),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: color1,
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text("Give me a new cat!")),
                    ],
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
