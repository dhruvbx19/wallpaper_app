// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;
  const FullScreen({super.key, required this.imageurl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.network(widget.imageurl),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: GestureDetector(
                onTap: () {
                 // Trigger fetching more images
                },
                child: Text(
                  'Set Wallpaper',
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
      )),
    );
  }
}
