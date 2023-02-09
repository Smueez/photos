import 'package:flutter/material.dart';
import 'package:photos/screens/gallery/ui/gallery_ui.dart';

import '../../../globals/enums.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({Key? key}) : super(key: key);
  static const routeName = "/home_ui";
  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    GalleryUI(type: GalleryType.gallery),
    GalleryUI(type: GalleryType.bookmark),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Bookmarks',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
