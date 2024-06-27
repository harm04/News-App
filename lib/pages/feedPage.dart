import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/api.dart';
import 'package:news_app/widgets/newsCard.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/widgets/topNewscard.dart';

class Feedpage extends StatefulWidget {
  const Feedpage({super.key});

  @override
  State<Feedpage> createState() => _FeedpageState();
}

class _FeedpageState extends State<Feedpage> {
  TextEditingController searchcontroller = TextEditingController(text: "tech");
  final List<String> categories = [
    'Tech',
    'entertainment',
    'Sports',
    'Business',
    'Finance',
    'Space',
    'politics',
    'International',
    'Education',
    'Nature',
    'Jobs',
    'health',
    'general',
    'science',
  ];
  // ignore: prefer_typing_uninitialized_variables
  var data;
  // ignore: prefer_typing_uninitialized_variables
  var topdata;
  // ignore: prefer_typing_uninitialized_variables
  var num;
  bool isSearching = false;

  Future<void> fetchNews(String search) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?pageSize=100&q=${searchcontroller.text}&language=en&sortBy=publishedAt&apiKey=$api'));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
    }
  }

  Future<void> fetchTopNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&pageSize=100&language=en&sortBy=publishedAt&apiKey=$api'));
    if (response.statusCode == 200) {
      topdata = jsonDecode(response.body.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: isSearching
              ? TextField(
                  decoration: const InputDecoration(hintText: 'Search news'),
                  controller: searchcontroller,
                )
              : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('News ',style: TextStyle(color: Colors.orange),),
                  Text('app',style: TextStyle(color: Colors.black),)
                ],
              ),
              centerTitle: true,
              
          actions: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: isSearching
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                      child: Image.asset(
                        'assets/icons/delete.png',
                        fit: BoxFit.cover,
                        height: 30,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = !isSearching;
                          
                          fetchNews(searchcontroller.text);
                          searchcontroller.clear();
                        });
                      },
                      child: Image.asset(
                        'assets/icons/search.png',
                        fit: BoxFit.cover,
                        height: 30,
                      ),
                    ),
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  isSearching
                      ? const SizedBox()
                      : const Text(
                          'Top headlines',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                  isSearching
                      ? const SizedBox()
                      : SizedBox(
                          height: 250,
                          child: FutureBuilder(
                              future: fetchTopNews(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView.builder(
                                    itemCount: topdata['articles'].length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return TopNewscard(
                                          imageUrl: topdata['articles'][index]
                                                  ['urlToImage'] ??
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGkAznCVTAALTD1o2mAnGLudN9r-bY6klRFB35J2hY7gvR9vDO3bPY_6gaOrfV0IHEIUo&usqp=CAU',
                                          title: topdata['articles'][index]
                                                  ['title'] ??
                                              "",
                                          time: topdata['articles'][index]
                                                  ['publishedAt'] ??
                                              "",
                                          description: topdata['articles']
                                                  [index]['description'] ??
                                              "",
                                          url: topdata['articles'][index]
                                                  ['url'] ??
                                              "",
                                          content: topdata['articles'][index]
                                                  ['content'] ??
                                              "");
                                    });
                              }),
                        ),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                num = index;

                                searchcontroller.text = categories[index];
                              });
                            },
                            child: Card(
                              color:
                                  num == index ? Colors.orange : Colors.white12,
                              child: SizedBox(
                                width: 150,
                                child: Center(child: Text(categories[index])),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 7,
                    child: FutureBuilder(
                        future: fetchNews(searchcontroller.text),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return data.length == 0
                              ? const Center(child: Text('No result found'))
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data['articles'].length,
                                  itemBuilder: (context, index) {
                                    return NewsCard(
                                        imageUrl: data['articles'][index]
                                                ['urlToImage'] ??
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGkAznCVTAALTD1o2mAnGLudN9r-bY6klRFB35J2hY7gvR9vDO3bPY_6gaOrfV0IHEIUo&usqp=CAU',
                                        title: data['articles'][index]
                                                ['title'] ??
                                            "",
                                        time: data['articles'][index]
                                                ['publishedAt'] ??
                                            "",
                                        description: data['articles'][index]
                                                ['description'] ??
                                            "",
                                        url: data['articles'][index]['url'] ??
                                            "",
                                        content: data['articles'][index]
                                                ['content'] ??
                                            "");
                                  });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
