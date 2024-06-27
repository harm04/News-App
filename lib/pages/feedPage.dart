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
  var data;
  var topdata;
  var num;
  bool isloading = false;
  Future<void> fetchNews(String search) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?pageSize=100&q=${searchcontroller.text}&language=en&sortBy=publishedAt&apiKey=$api'));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
    }
    print(data);
    print(data['articles'].length);
  }

  Future<void> fetchTopNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&pageSize=100&language=en&sortBy=publishedAt&apiKey=$api'));
    if (response.statusCode == 200) {
      topdata = jsonDecode(response.body.toString());
    }
    print(topdata);
    print(topdata['articles'].length);
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
          title: TextField(
            decoration: const InputDecoration(hintText: 'Search news'),
            controller: searchcontroller,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    fetchNews(searchcontroller.text);
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
        drawer: Drawer(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.orange,
                      child: CircleAvatar(
                        radius: 40,
                      ),
                    ),
                    Text(
                      'News App',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Divider(),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/filter.png',
                      height: 25,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Filters'),
                  ],
                ),
                Expanded(
                    child: ListView(
                  children: const [],
                )),
                const Card(
                  color: Colors.orange,
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Show 58 results",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
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
                  const Text(
                    'Top headlines',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 250,
                    child: FutureBuilder(
                        future: fetchTopNews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: const CircularProgressIndicator(),
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
                                  title:
                                      topdata['articles'][index]['title'] ?? "",
                                  time: topdata['articles'][index]
                                          ['publishedAt'] ??
                                      "",
                                  description: topdata['articles'][index]
                                          ['description'] ??
                                      "",
                                  url: topdata['articles'][index]['url'] ?? "",content:topdata['articles'][index]['content']??""
                                );
                              });
                        }),
                  ),
                  Container(
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
                                  num == index ? Colors.blue : Colors.white12,
                              child: Container(
                                width: 150,
                                child: Center(child: Text(categories[index])),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 7,
                    child: Expanded(
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
                                : Container(
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                                              description: data['articles']
                                                      [index]['description'] ??
                                                  "",
                                              url: data['articles'][index]
                                                      ['url'] ??
                                                  "",content:data['articles'][index]['content']??"");
                                        }),
                                  );
                          }),
                    ),
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
