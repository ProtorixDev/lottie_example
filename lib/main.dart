import 'dart:convert';

import 'package:demoapp/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import './profile.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: YourApp());
  }
}

class Datas {
  String query_text, date;
  int comments;

  Datas({required this.query_text, required this.date, required this.comments});
}

class YourApp extends StatefulWidget {
  const YourApp({Key? key}) : super(key: key);

  @override
  _YourAppState createState() => _YourAppState();
}

class _YourAppState extends State<YourApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoaded = false;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    super.initState();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Datas> dataList = [];
  Future<List<Datas>> getinfo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://7b799511-b5f4-43fb-ae5d-1f65f67dd8d1.mock.pstmn.io/api/v1/home/feed'));
      var result = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        for (Map i in result) {
          Datas datas = Datas(
              query_text: i['query_text'],
              date: i['date'],
              comments: i['comments']);
          dataList.add(datas);
        }
        return dataList;
      } else {
        return dataList;
      }
    } catch (e) {
      print(e);
    }
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.black54,
          ),
          onPressed: () {
            print('1');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Profile(),
            ));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                print('1');
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black54,
              )),
          IconButton(
              onPressed: () {
                print('2');
              },
              icon: Icon(
                Icons.search,
                color: Colors.black54,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(18.0),
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('My Queries',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  )),
            ),
          ),
          Expanded(
            child: isLoaded
                ? FutureBuilder(
                    future: getinfo(),
                    builder: (context, AsyncSnapshot<List<Datas>> snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return
                                //  title: Text('WWE is scripted'),
                                // );
                                Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Card(
                                shadowColor: Colors.black54,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].query_text
                                            .toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.black54,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        //  color: Colors.red,
                                        child: Row(
                                          // mainAxisAlignment:
                                          // MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.mode_comment_outlined,
                                                color: Colors.grey,
                                              ),
                                              margin:
                                                  EdgeInsets.only(left: 5.0),
                                            ),
                                            Container(
                                              child: Text(
                                                  snapshot.data![index].comments
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54,
                                                  )),
                                              margin:
                                                  EdgeInsets.only(left: 5.0),
                                            ),
                                            Spacer(),
                                            Container(
                                              child: Text(
                                                snapshot.data![index].date
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    })
                : Lottie.asset('assets/loading.json', controller: _controller,
                    onLoaded: (comp) {
                    _controller.duration = comp.duration;
                    _controller.forward();
                  }),
          )
        ],
      ),
      //  floatingActionButton:
      //  FloatingActionButton(
      //   onPressed: () {}, child: Icon(Icons.add)),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 25),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.black54,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(),
      /* BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          alignment: Alignment.center,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.home), Icon(Icons.messenger_outline)],
          ),
        ),
      ),*/
    );
  }
}

Widget _buildBottomBar() {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
    height: 60,
    margin: EdgeInsets.only(bottom: 20, left: 70, right: 70),
    child: Material(
      elevation: 5.0,
      shape: const StadiumBorder(),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        onTap: (index) {
          //_currentIndex = index;
          //  setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black54,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.mode_comment_outlined), label: "")
        ],
      ),
    ),
  );
}
