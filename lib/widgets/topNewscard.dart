import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/newsPage.dart';

class TopNewscard extends StatelessWidget {
  final String imageUrl, title, time, description,url,content;
  const TopNewscard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.time,
      required this.description, required this.url, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return  Newspage(description: description,imageUrl: imageUrl,time: time,title: title,url: url,content: content,);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            SizedBox(
              width: 150,
              height: 220,
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    height: 220,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(
                          color: Colors.orange,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                       placeholder:(context, url) =>const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url,error) =>Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGkAznCVTAALTD1o2mAnGLudN9r-bY6klRFB35J2hY7gvR9vDO3bPY_6gaOrfV0IHEIUo&usqp=CAU',fit: BoxFit.cover,),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
