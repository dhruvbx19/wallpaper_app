// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:Wallgram/fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/collections?page=22'),
        headers: {
          "Authorization":
              "Client-ID eyVUaVX4MgLfbnTCKOMCTfbXPr5W7qER348qnHpDRgI"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          images =
              responseData; // Assuming responseData is a List<dynamic> containing collection data
        });
        print(images[0]); // Print the first item in the images list
      } else {
        throw Exception('Failed to load data'); // Handle API request failure
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error gracefully, e.g., display an error message
    }
  }

  fetchMoreImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/collections?page=$currentPage'),
        headers: {
          "Authorization":
              "Client-ID eyVUaVX4MgLfbnTCKOMCTfbXPr5W7qER348qnHpDRgI"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          images.addAll(responseData); // Append new images to the existing list
        });
        currentPage++; // Increment page for the next fetch
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching more data: $e');
      // Handle error gracefully, e.g., display an error message
    }
  }

  // loadmore() async {
  //   setState(() {
  //     page = page + 1;
  //   });
  //   String url =
  //       'https://api.pexels.com/v1?per_page=80&page=' + page.toString();
  //   await http.get(Uri.parse(url), headers: {
  //     "Authorization":
  //         "XSfqY6sMYUN0lJGhyfMmSVoaMLUg3f2K0kLiVfvjfBwenSMl2gf3I4WS"
  //   }).then((value) {
  //     Map result = jsonDecode(value.body);

  //     setState(() {
  //       images.addAll(result['photos']);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode))
        ],
        title: Text(
          'Wallpaper App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 3,
                  childAspectRatio: 2 /
                      3, // Adjust this ratio based on your image aspect ratio
                ),
                itemBuilder: (context, index) {
                  var imageUrl = images[index]['cover_photo']['urls']
                      ['thumb']; // Assuming this is the image URL
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreen(
                                    imageurl: images[index]['cover_photo']
                                        ['urls']['raw'],
                                  )));
                    },
                    child: Container(
                      color: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: Add border radius
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  fetchMoreImages(); // Trigger fetching more images
                },
                child: Text(
                  'Load More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
