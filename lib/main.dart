import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemon.dart';
import 'pokemondetail.dart';

void main() => runApp(MaterialApp(
      title: "My Poke App",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    // setState書かないと，データ取ってきた後にWidgetが反映されない
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batch Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2, //列数指定（2列）
              children: pokeHub.pokemon
                  .map((poke) => Padding(
                      //セル同士の隙間指定
                      padding: const EdgeInsets.all(1.0),
                      // InkWellでchild: Cardをくくってやると
                      // cardのonTapとか実装できる
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PokeDetail(
                                        pokemon: poke,
                                      )));
                        },
                        child: Hero(
                          tag: poke.img,
                          child: Card(
                            elevation: 3.0, //Cardの背景の影
                            // セルのことは多分Cardといってその中のWdget実装
                            child: Column(
                              // このColumnの中自体がCardっぽい
                              // mainAxisAlignmentでCard内の表示内容全ての配置間隔を設定
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  // Cardの中にContainerを作っている
                                  // 内容のサイズ
                                  height: 100.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(poke.img))),
                                ),
                                // 画像表示用Container終わった後に
                                // その下に表示するText配置
                                Text(
                                  poke.name,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ), //セルを表示
                      )))
                  .toList(),
            ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
