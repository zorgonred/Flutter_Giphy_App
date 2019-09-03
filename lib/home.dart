import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _search;
  int _offset;


  Future<Map> getGifData() async {
    var res = await http.get(
        "https://api.giphy.com/v1/gifs/search?api_key=wusbFwUExpkztfjeMr3QRimPUc4kd1J9&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    return json.decode(res.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Image.network('https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
      backgroundColor: Colors.black,
      centerTitle: true,
    ),
      backgroundColor: Colors.black,
      body: Column(
       children: <Widget>[Padding(
         padding: const EdgeInsets.all(10.0),
         child: TextField(
//        controller: c,
              decoration: InputDecoration(
             labelText: "Search here",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                  color: Colors.white, fontSize: 18.0
              ),
         textAlign: TextAlign.center,
onSubmitted: (text){
                setState(() {
                  _search = text;
                });
},
//       onChanged: f,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
       ),

          Expanded(
            child: FutureBuilder(
                future: getGifData()
                , builder: (context,snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    width: 200.0,
                      height: 200.0,
                      child: Text(
                        "Loading...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ));
                default:
                  if (snapshot.hasError) {
                    return Container(
                        width: 200.0,
                        height: 200.0,
                        child: Text(
                          "Error :(",
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ));}
                  else {
                    return _createdGiftable(context, snapshot);

                    ListView(children: <Widget>[
                      Expanded(
                        child: SizedBox(height: 600,
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  snapshot.data['data'][index]['images']
                                  ['fixed_height_still']['url'],
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                      ),
                    ],
                    );

                  }

              }
            }),
          ),
    ],
      ),
    );
  }

  int _getCount(List data){
    if(_search == null) {
      return data.length;
    }else {
      return data.length + 1;
    }
  }

Widget _createdGiftable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(padding:EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
    ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {

      if(_search ==null || index < snapshot.data["data"].length)
      return GestureDetector(
            child: Image.network(
              snapshot.data['data'][index]['images']
              ['fixed_height_still']['url'],
              height: 300.0,
              fit: BoxFit.cover,),
              onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index])));
              },
        onLongPress: (){
          Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
        },

          );
      else
        return Container(
          child: GestureDetector(
            child: Column(
              children: <Widget>[
                Icon(Icons.add, color: Colors.white, size :70.0,),
                Text('Load more', style: TextStyle(color: Colors.white, fontSize: 22.0),)
              ],
            ),
          )
        );
        });
}


}




