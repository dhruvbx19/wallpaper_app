// ignore_for_file: prefer_const_constructors

import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;
  const FullScreen({super.key, required this.imageurl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setwallpaper() async {
  try {
    File file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    if (file == null) {
      throw Exception('Failed to get image file from cache');
    }

    int location = WallpaperManager.BOTH_SCREEN;
    bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wallpaper set successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to set wallpaper')),
    );
    print('Error setting wallpaper: $e');
  }
}
  
  // Wrap with try catch for error management.file

  // Future<void> setwallpaper() async {
  //   int location = WallpaperManager.HOME_SCREEN;
  //   var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
  //   bool result =
  //       await WallpaperManager.setWallpaperFromFile(file.path, location);
  // }

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
                  setwallpaper();
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
