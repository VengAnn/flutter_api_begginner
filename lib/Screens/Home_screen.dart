import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_beginner/models/products.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showItems = false;

  Future<List<products>> getProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      // print(response.body);
      final List<products> productList =
          jsonList.map((json) => products.fromJson(json)).toList();

      return productList;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("flutter api beginner"),
      ),
      body: _showItems
          ? FutureBuilder<List<products>>(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Container(
                    child: const Text("Loading"),
                  ));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.hasError}"),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Empty data"),
                  );
                }
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var pro = snapshot.data![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Image.network(
                                  "${pro.image}",
                                  width: 100,
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  // color: Colors.red,
                                  // width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Name: ${pro.title}"),
                                      Text("Price: ${pro.price}"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showItems = !_showItems;
          getProducts();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
